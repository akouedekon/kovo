package com.kovo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class MailService {

    private final JavaMailSender mailSender;

    @Autowired
    public MailService(JavaMailSender mailSender){
        this.mailSender = mailSender;
    }

    public void sendOtpEmail(String to, String code){
        SimpleMailMessage msg = new SimpleMailMessage();
        msg.setTo(to);
        msg.setSubject("Kovo — Votre code OTP");
        msg.setText("Votre code OTP pour Kovo est : " + code + "\nIl est valable 10 minutes.");
        mailSender.send(msg);
    }
}
