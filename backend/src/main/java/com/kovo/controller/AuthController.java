package com.kovo.controller;

import com.kovo.dto.RequestOtpDto;
import com.kovo.dto.VerifyOtpDto;
import com.kovo.service.AuthService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService){
        this.authService = authService;
    }

    @PostMapping("/request-otp")
    public ResponseEntity<?> requestOtp(@Valid @RequestBody RequestOtpDto req){
        authService.requestOtp(req.getPhone());
        return ResponseEntity.ok(Map.of("status","otp_sent"));
    }

    @PostMapping("/verify-otp")
    public ResponseEntity<?> verifyOtp(@Valid @RequestBody VerifyOtpDto req){
        Map<String,String> tokens = authService.verifyOtp(req.getPhone(), req.getCode());
        if(tokens.containsKey("error")){
            return ResponseEntity.status(400).body(tokens);
        }
        return ResponseEntity.ok(tokens);
    }

    @PostMapping("/refresh")
    public ResponseEntity<?> refresh(@RequestBody Map<String,String> body){
        String refresh = body.get("refreshToken");
        Map<String,String> result = authService.refreshAccessToken(refresh);
        if(result.containsKey("error")) return ResponseEntity.status(400).body(result);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/debug-otp")
    public ResponseEntity<?> debugOtp(@RequestParam String phone){
        String code = authService.getOtpForPhone(phone);
        if(code == null) return ResponseEntity.status(404).body(Map.of("error","not_available"));
        return ResponseEntity.ok(Map.of("otp", code));
    }
}

