package com.kovo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.ui.Model;

@Controller
public class SuccessRedirectController {

    @GetMapping("/payments/success")
    public String success(@RequestParam(required = false) String bookingId, @RequestParam(required=false) String paymentId, Model model){
        model.addAttribute("bookingId", bookingId == null ? "" : bookingId);
        model.addAttribute("paymentId", paymentId == null ? "" : paymentId);
        return "payments_success"; // will render a small HTML page
    }
}
