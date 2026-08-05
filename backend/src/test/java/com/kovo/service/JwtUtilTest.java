package com.kovo.service;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class JwtUtilTest {

    @Test
    public void generateAndParse(){
        String secret = "01234567890123456789012345678901"; // 32 chars
        JwtUtil util = new JwtUtil(secret);
        Long userId = 42L;
        String token = util.generateAccessToken(userId);
        Assertions.assertTrue(util.validateToken(token));
        Long parsed = util.parseUserIdFromToken(token);
        Assertions.assertEquals(userId, parsed);
    }
}
