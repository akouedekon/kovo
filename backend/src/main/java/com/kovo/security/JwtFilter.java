package com.kovo.security;

import com.kovo.service.JwtUtil;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@Component
public class JwtFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;

    public JwtFilter(JwtUtil jwtUtil){
        this.jwtUtil = jwtUtil;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        String auth = request.getHeader("Authorization");
        if(auth != null && auth.startsWith("Bearer ")){
            String token = auth.substring(7);
            if(jwtUtil.validateToken(token)){
                Long userId = jwtUtil.parseUserIdFromToken(token);
                if(userId != null){
                    // set simple authentication with userId as principal
                    UsernamePasswordAuthenticationToken a = new UsernamePasswordAuthenticationToken(userId, null, List.of(new SimpleGrantedAuthority("USER")));
                    SecurityContextHolder.getContext().setAuthentication(a);
                }
            }
        }
        filterChain.doFilter(request, response);
    }
}
