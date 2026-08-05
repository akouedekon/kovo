package com.kovo.controller;

import com.kovo.dto.CreateBookingRequest;
import com.kovo.model.Booking;
import com.kovo.repository.BookingRepository;
import com.kovo.repository.RideRepository;
import com.kovo.service.BookingService;
import org.springframework.http.ResponseEntity;
import org.springframework.orm.ObjectOptimisticLockingFailureException;
import org.springframework.web.bind.annotation.*;

import jakarta.persistence.OptimisticLockException;
import jakarta.validation.Valid;
import java.util.Map;

@RestController
@RequestMapping("/api/bookings")
public class BookingController {

    private final BookingService bookingService;

    public BookingController(BookingService bookingService){
        this.bookingService = bookingService;
    }

    @PostMapping
    public ResponseEntity<?> createBooking(@Valid @RequestBody CreateBookingRequest req){
        int maxAttempts = 3;
        int attempts = 0;
        while(true){
            try{
                Booking saved = bookingService.createBookingTransactional(req.getRideId(), req.getPassengerId(), req.getSeatsBooked());
                return ResponseEntity.status(201).body(Map.of("bookingId", saved.getId()));
            }catch (ObjectOptimisticLockingFailureException | OptimisticLockException e){
                attempts++;
                if(attempts >= maxAttempts){
                    return ResponseEntity.status(409).body(Map.of("error","concurrent_update"));
                }
                // else retry
            }catch (jakarta.persistence.EntityNotFoundException e){
                return ResponseEntity.status(404).body(Map.of("error",e.getMessage()));
            }catch (IllegalStateException e){
                return ResponseEntity.status(400).body(Map.of("error",e.getMessage()));
            }
        }
    }
}
