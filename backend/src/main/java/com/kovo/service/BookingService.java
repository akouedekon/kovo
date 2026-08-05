package com.kovo.service;

import com.kovo.model.Booking;
import com.kovo.model.Ride;
import com.kovo.repository.BookingRepository;
import com.kovo.repository.RideRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import jakarta.persistence.EntityNotFoundException;

@Service
public class BookingService {

    private final BookingRepository bookingRepository;
    private final RideRepository rideRepository;

    public BookingService(BookingRepository bookingRepository, RideRepository rideRepository){
        this.bookingRepository = bookingRepository;
        this.rideRepository = rideRepository;
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public Booking createBookingTransactional(Long rideId, Long passengerId, int seatsToBook){
        Ride ride = rideRepository.findById(rideId).orElseThrow(() -> new EntityNotFoundException("ride_not_found"));
        if(ride.getSeatsAvailable() < seatsToBook){
            throw new IllegalStateException("insufficient_seats");
        }
        ride.setSeatsAvailable(ride.getSeatsAvailable() - seatsToBook);
        rideRepository.save(ride);
        Booking booking = new Booking();
        booking.setRideId(rideId);
        booking.setPassengerId(passengerId);
        booking.setSeatsBooked(seatsToBook);
        booking.setStatus("RESERVED");
        return bookingRepository.save(booking);
    }
}
