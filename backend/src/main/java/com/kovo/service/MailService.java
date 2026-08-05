package com.kovo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.util.StreamUtils;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.Locale;

@Service
public class MailService {

    private final JavaMailSender mailSender;
    private final MessageSource messageSource;

    @Autowired
    public MailService(JavaMailSender mailSender, MessageSource messageSource){
        this.mailSender = mailSender;
        this.messageSource = messageSource;
    }

    public void sendOtpEmail(String to, String code){
        String subject = messageSource.getMessage("email.subject.otp", new Object[]{"Kovo"}, "Kovo - Votre code OTP", Locale.FRENCH);
        String html = loadTemplateAndRender(code);

        try{
            MimeMessage mime = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mime, mime.getMimeType() != null, StandardCharsets.UTF_8.name());
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(html, true);
            mailSender.send(mime);
        }catch(MessagingException | MailException ex){
            // fallback to simple text email
            try{
                SimpleMailMessage msg = new SimpleMailMessage();
                msg.setTo(to);
                msg.setSubject(subject);
                msg.setText("Votre code OTP pour Kovo est : " + code + "\nIl est valable 10 minutes.");
                mailSender.send(msg);
            }catch(Exception e){
                // last resort: log
                System.out.println("[OTP email failed] to="+to+" code="+code+" error="+ex.getMessage());
            }
        }
    }

    private String loadTemplateAndRender(String code){
        try(InputStream is = getClass().getResourceAsStream("/templates/otp_email.html")){
            if(is == null) return "<p>Votre code OTP pour Kovo est : <strong>"+code+"</strong></p>";
            String tpl = StreamUtils.copyToString(is, StandardCharsets.UTF_8);
            return tpl.replace("{{code}}", code).replace("{{appName}}","Kovo");
        }catch(Exception e){
            return "<p>Votre code OTP pour Kovo est : <strong>"+code+"</strong></p>";
        }
    }
}
