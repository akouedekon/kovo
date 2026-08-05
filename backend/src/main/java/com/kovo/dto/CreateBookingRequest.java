package com.kovo.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public class CreateBookingRequest {
    @NotNull
    private Long rideId;
    @NotNull
    private Long passengerId;
    @Min(1)
    private int seatsBooked = 1;

    public Long getRideId() { return rideId; }
    public void setRideId(Long rideId) { this.rideId = rideId; }
    public Long getPassengerId() { return passengerId; }
    public void setPassengerId(Long passengerId) { this.passengerId = passengerId; }
    public int getSeatsBooked() { return seatsBooked; }
    public void setSeatsBooked(int seatsBooked) { this.seatsBooked = seatsBooked; }
}
