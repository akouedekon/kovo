package com.kovo.service;

import com.kovo.model.RefreshToken;
import com.kovo.model.User;
import com.kovo.repository.RefreshTokenRepository;
import com.kovo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final JwtUtil jwtUtil;

    private final ConcurrentHashMap<String,String> otpStore = new ConcurrentHashMap<>();

    @Value("${jwt.refreshTokenDays:30}")
    private int refreshDays;

    @Value("${auth.debug:false}")
    private boolean debugOtp;

    public AuthService(UserRepository userRepository, RefreshTokenRepository refreshTokenRepository, JwtUtil jwtUtil){
        this.userRepository = userRepository;
        this.refreshTokenRepository = refreshTokenRepository;
        this.jwtUtil = jwtUtil;
    }

    public void requestOtp(String phone){
        String code = String.valueOf(100000 + (int)(Math.random()*900000));
        otpStore.put(phone, code);
        // In production: call SMS provider. For now log it so dev can read OTP.
        System.out.println("[OTP] phone="+phone+" code="+code);
    }

    public Map<String,String> verifyOtp(String phone, String code){
        String expected = otpStore.get(phone);
        if(expected == null || !expected.equals(code)){
            return Map.of("error","invalid_otp");
        }
        User user = userRepository.findByPhone(phone).orElseGet(() -> {
            User u = new User(); u.setPhone(phone); u.setRole("PASSENGER"); u.setName("");
            return userRepository.save(u);
        });
        String accessToken = jwtUtil.generateAccessToken(user.getId());
        String refresh = UUID.randomUUID().toString();
        RefreshToken rt = new RefreshToken();
        rt.setToken(refresh);
        rt.setUserId(user.getId());
        rt.setExpiryDate(LocalDateTime.ofInstant(Instant.now().plusSeconds((long)refreshDays*24*3600), ZoneId.systemDefault()));
        refreshTokenRepository.save(rt);
        otpStore.remove(phone);
        return Map.of("accessToken", accessToken, "refreshToken", refresh);
    }

    public Map<String,String> refreshAccessToken(String refreshToken){
        return refreshTokenRepository.findByToken(refreshToken).map(rt -> {
            if(rt.getExpiryDate().isBefore(LocalDateTime.now())){
                refreshTokenRepository.delete(rt);
                return Map.of("error","refresh_expired");
            }
            String newAccess = jwtUtil.generateAccessToken(rt.getUserId());
            return Map.of("accessToken", newAccess);
        }).orElse(Map.of("error","invalid_refresh"));
    }

    // Test helper: return OTP for a phone when debug enabled
    public String getOtpForPhone(String phone){
        if(!debugOtp) return null;
        return otpStore.get(phone);
    }
}
