package com.kovo.controller;

import com.kovo.dto.CreateRideRequest;
import com.kovo.model.Ride;
import com.kovo.repository.RideRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/rides")
public class RideController {

    private final RideRepository rideRepository;

    public RideController(RideRepository rideRepository){
        this.rideRepository = rideRepository;
    }

    @GetMapping
    public ResponseEntity<?> searchRides(@RequestParam(required=false) String from, @RequestParam(required=false) String to){
        List<Ride> rides = rideRepository.findAll();
        // Basic filtering by origin/destination if provided
        if(from != null){
            rides.removeIf(r -> r.getOrigin() == null || !r.getOrigin().toLowerCase().contains(from.toLowerCase()));
        }
        if(to != null){
            rides.removeIf(r -> r.getDestination() == null || !r.getDestination().toLowerCase().contains(to.toLowerCase()));
        }
        return ResponseEntity.ok(rides);
    }

    @PostMapping
    public ResponseEntity<?> createRide(@Valid @RequestBody CreateRideRequest req){
        Ride r = new Ride();
        r.setOrigin(req.getOrigin());
        r.setDestination(req.getDestination());
        if(req.getDepartureTime() != null && !req.getDepartureTime().isBlank()){
            r.setDepartureTime(LocalDateTime.parse(req.getDepartureTime()));
        } else {
            r.setDepartureTime(LocalDateTime.now().plusHours(1));
        }
        r.setSeatsAvailable(req.getSeatsAvailable());
        r.setDriverId(req.getDriverId());
        Ride saved = rideRepository.save(r);
        return ResponseEntity.status(201).body(Map.of("id", saved.getId()));
    }
}
