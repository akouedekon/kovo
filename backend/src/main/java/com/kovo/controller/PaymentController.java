package com.kovo.controller;

import com.kovo.model.Payment;
import com.kovo.repository.BookingRepository;
import com.kovo.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.Map;
import java.util.UUID;

@RestController
public class PaymentController {

    private final PaymentRepository paymentRepository;
    private final BookingRepository bookingRepository;
    private final RestTemplate rest = new RestTemplate();

    @Value("${kkiapay.publicKey:}")
    private String publicKey;
    @Value("${kkiapay.privateKey:}")
    private String privateKey;
    @Value("${kkiapay.apiUrl:https://sandbox.kkiapay.me}")
    private String apiUrl;

    public PaymentController(PaymentRepository paymentRepository, BookingRepository bookingRepository){
        this.paymentRepository = paymentRepository;
        this.bookingRepository = bookingRepository;
    }

    @PostMapping("/api/payments/create")
    public ResponseEntity<?> createPayment(@RequestBody Map<String,Object> body) {
        String bookingIdStr = String.valueOf(body.getOrDefault("bookingId", ""));
        String amountStr = String.valueOf(body.getOrDefault("amount", "0"));
        long amount = 0L;
        try{ amount = Long.parseLong(amountStr); }catch(Exception e){ }

        // create payment record
        Payment p = new Payment();
        try { p.setBookingId(Long.parseLong(bookingIdStr)); } catch(Exception e) { p.setBookingId(null); }
        p.setAmountCfa(amount);
        p.setStatus("PENDING");
        p = paymentRepository.save(p);

        // Try to call Kkiapay create checkout if keys available
        if(publicKey != null && !publicKey.isBlank() && apiUrl != null && !apiUrl.isBlank()){
            try{
                // Build a simple payload expected by Kkiapay (best-effort). If it fails, fallback to simulation URL.
                Map<String,Object> payload = Map.of("public_key", publicKey, "amount", amount, "currency", "XOF", "order_id", p.getId().toString(), "callback_url", apiUrl + "/api/payments/webhook");
                @SuppressWarnings("unchecked")
                Map<String,Object> resp = rest.postForObject(apiUrl + "/v1/merchant/checkout", payload, Map.class);
                if(resp != null && resp.get("url") != null){
                    p.setProviderPaymentId(String.valueOf(resp.getOrDefault("id", UUID.randomUUID().toString())));
                    p.setRawPayload(resp.toString());
                    paymentRepository.save(p);
                    return ResponseEntity.ok(Map.of("paymentId", p.getId(), "paymentUrl", resp.get("url")));
                }
            }catch(Exception e){
                // ignore and fallback
            }
        }

        // fallback - return local simulate URL
        String url = "/api/payments/simulate/" + p.getId() + "?bookingId=" + bookingIdStr + "&paymentId=" + p.getId();
        return ResponseEntity.ok(Map.of("paymentId", p.getId(), "paymentUrl", url));
    }

    @PostMapping(value = "/api/payments/webhook", consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> webhook(@RequestBody Map<String,Object> body, @RequestHeader Map<String,String> headers) {
        try{
            // For provider calls, verify signature header if present
            String sigHeader = headers.getOrDefault("x-kkiapay-signature", headers.getOrDefault("x-signature", ""));
            String raw = body.toString();
            boolean valid = false;
            if(sigHeader != null && !sigHeader.isBlank() && privateKey != null && !privateKey.isBlank()){
                // compute HMAC-SHA256 of body using privateKey
                try{
                    javax.crypto.Mac mac = javax.crypto.Mac.getInstance("HmacSHA256");
                    javax.crypto.spec.SecretKeySpec keySpec = new javax.crypto.spec.SecretKeySpec(privateKey.getBytes(java.nio.charset.StandardCharsets.UTF_8), "HmacSHA256");
                    mac.init(keySpec);
                    byte[] sig = mac.doFinal(raw.getBytes(java.nio.charset.StandardCharsets.UTF_8));
                    StringBuilder sb = new StringBuilder();
                    for(byte b: sig) sb.append(String.format("%02x", b));
                    String computed = sb.toString();
                    valid = computed.equalsIgnoreCase(sigHeader);
                }catch(Exception e){ valid = false; }
            } else {
                // no signature header -> accept if body contains status=success (demo)
                valid = "success".equalsIgnoreCase(String.valueOf(body.getOrDefault("status", "")));
            }

            if(!valid){
                return ResponseEntity.status(400).body(Map.of("error","invalid_signature"));
            }

            // mark payment & booking
            String providerId = String.valueOf(body.getOrDefault("id", body.getOrDefault("paymentId", body.getOrDefault("payment_id", ""))));
            Payment p = paymentRepository.findByProviderPaymentId(providerId);
            if(p == null){
                // try fallback: maybe provider used our internal id
                try{
                    Long pid = Long.parseLong(String.valueOf(body.getOrDefault("paymentId", body.getOrDefault("id", body.getOrDefault("provider_id", "0")))));
                    p = paymentRepository.findById(pid).orElse(null);
                }catch(Exception ignored){ p = null; }
            }
            if(p == null){
                // create a minimal payment record
                Payment np = new Payment();
                np.setProviderPaymentId(providerId);
                np.setRawPayload(body.toString());
                np.setAmountCfa(Long.parseLong(String.valueOf(body.getOrDefault("amount", "0"))));
                np.setStatus("SUCCESS");
                paymentRepository.save(np);
            } else {
                p.setRawPayload(body.toString());
                p.setStatus("SUCCESS");
                paymentRepository.save(p);
                // update booking status to COMPLETED
                if(p.getBookingId() != null){
                    bookingRepository.findById(p.getBookingId()).ifPresent(b -> { b.setStatus("COMPLETED"); bookingRepository.save(b); });
                }
            }

            return ResponseEntity.ok(Map.of("status","ok"));
        }catch(Exception e){
            e.printStackTrace();
            return ResponseEntity.status(500).body(Map.of("error","server_error"));
        }
    }
}
