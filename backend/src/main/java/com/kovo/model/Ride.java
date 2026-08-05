package com.kovo.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "rides")
public class Ride {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String origin;
    private String destination;
    private LocalDateTime departureTime;
    private int seatsAvailable;
    private Long driverId;

    @Version
    private Integer version;

    // getters/setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getOrigin() { return origin; }
    public void setOrigin(String origin) { this.origin = origin; }
    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }
    public LocalDateTime getDepartureTime() { return departureTime; }
    public void setDepartureTime(LocalDateTime departureTime) { this.departureTime = departureTime; }
    public int getSeatsAvailable() { return seatsAvailable; }
    public void setSeatsAvailable(int seatsAvailable) { this.seatsAvailable = seatsAvailable; }
    public Long getDriverId() { return driverId; }
    public void setDriverId(Long driverId) { this.driverId = driverId; }
    public Integer getVersion() { return version; }
    public void setVersion(Integer version) { this.version = version; }
}
