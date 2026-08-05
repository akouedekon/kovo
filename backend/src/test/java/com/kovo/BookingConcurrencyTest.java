package com.kovo;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kovo.model.Ride;
import com.kovo.repository.BookingRepository;
import com.kovo.repository.RideRepository;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import com.kovo.service.JwtUtil;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.*;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;

@SpringBootTest
@AutoConfigureMockMvc
@TestPropertySource(properties = {
        "spring.datasource.url=jdbc:h2:mem:testdb;DB_CLOSE_DELAY=-1;MODE=PostgreSQL",
        "spring.datasource.driverClassName=org.h2.Driver",
        "spring.jpa.hibernate.ddl-auto=create-drop",
        "auth.debug=true",
        "jwt.secret=01234567890123456789012345678901"
})
public class BookingConcurrencyTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private RideRepository rideRepository;

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private JwtUtil jwtUtil;

    @Test
    public void concurrentBookings_onlyOneSucceeds() throws Exception{
        // create a ride with 1 seat
        Ride r = new Ride();
        r.setOrigin("A");
        r.setDestination("B");
        r.setDepartureTime(LocalDateTime.now().plusHours(1));
        r.setSeatsAvailable(1);
        Ride saved = rideRepository.save(r);

        int threads = 2;
        // Prepare authenticated passengers: request OTP, fetch debug OTP, verify to get access tokens and user ids
        List<String> accessTokens = new ArrayList<>();
        List<Long> passengerIds = new ArrayList<>();
        for(int i=0;i<threads;i++){
            String email = "test" + (i+1) + "@example.com";
            Map<String,String> req = Map.of("email", email);
            mockMvc.perform(post("/api/auth/request-otp").contentType(MediaType.APPLICATION_JSON).content(objectMapper.writeValueAsString(req))).andReturn();
            MvcResult otpRes = mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get("/api/auth/debug-otp").param("email", email)).andReturn();
            String otp = objectMapper.readTree(otpRes.getResponse().getContentAsString()).get("otp").asText();
            Map<String,String> verify = Map.of("email", email, "code", otp);
            MvcResult verifyRes = mockMvc.perform(post("/api/auth/verify-otp").contentType(MediaType.APPLICATION_JSON).content(objectMapper.writeValueAsString(verify))).andReturn();
            String token = objectMapper.readTree(verifyRes.getResponse().getContentAsString()).get("accessToken").asText();
            // parse user id from token using JwtUtil bean
            Long userId = jwtUtil.parseUserIdFromToken(token);
            accessTokens.add(token);
            passengerIds.add(userId);
        }

        ExecutorService ex = Executors.newFixedThreadPool(threads);
        CountDownLatch startLatch = new CountDownLatch(1);
        List<Future<Integer>> futures = new ArrayList<>();

        for(int i=0;i<threads;i++){
            final String token = accessTokens.get(i);
            final Long passengerId = passengerIds.get(i);
            futures.add(ex.submit(() -> {
                startLatch.await();
                Map<String,Object> payload = Map.of("rideId", saved.getId(), "passengerId", passengerId, "seatsBooked", 1);
                MvcResult res = mockMvc.perform(post("/api/bookings")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(payload)))
                        .andReturn();
                return res.getResponse().getStatus();
            }));
        }

        // start all threads
        startLatch.countDown();

        int successCount = 0;
        int conflictCount = 0;
        int badCount = 0;
        for(Future<Integer> f : futures){
            int status = f.get(5, TimeUnit.SECONDS);
            if(status == 201) successCount++;
            else if(status == 409) conflictCount++;
            else badCount++;
        }

        // ensure exactly one succeeded
        Assertions.assertEquals(1, successCount, "Exactly one booking should succeed");
        // DB state: one booking
        Assertions.assertEquals(1, bookingRepository.count());
        Ride updated = rideRepository.findById(saved.getId()).orElseThrow();
        Assertions.assertEquals(0, updated.getSeatsAvailable());

        ex.shutdownNow();
    }
}
