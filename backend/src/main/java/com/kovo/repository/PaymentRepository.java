package com.kovo.repository;

import com.kovo.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PaymentRepository extends JpaRepository<Payment, Long> {
    Payment findByProviderPaymentId(String providerPaymentId);
}
