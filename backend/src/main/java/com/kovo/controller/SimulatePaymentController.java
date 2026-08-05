package com.kovo.controller;

import org.springframework.core.io.ClassPathResource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.nio.charset.StandardCharsets;

@RestController
public class SimulatePaymentController {

    @GetMapping("/api/payments/simulate/{paymentId}")
    public ResponseEntity<String> simulate(@PathVariable String paymentId, @RequestParam(required = false) String bookingId) throws Exception{
        // load the static HTML from classpath:/templates/simulate_payment.html and return with substituted query params handled by client JS
        ClassPathResource r = new ClassPathResource("templates/simulate_payment.html");
        byte[] bytes = r.getInputStream().readAllBytes();
        String html = new String(bytes, StandardCharsets.UTF_8);
        return ResponseEntity.ok().contentType(MediaType.TEXT_HTML).body(html);
    }
}
