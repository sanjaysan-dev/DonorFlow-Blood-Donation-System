package com.donorflow.model;

public class DonationDTO {
    private int userId;
    private String date;
    private String location;
    private int units;

    // Constructor to make creating it easier
    public DonationDTO(int userId, String date, String location, int units) {
        this.userId = userId;
        this.date = date;
        this.location = location;
        this.units = units;
    }

    // Getters
    public int getUserId() { return userId; }
    public String getDate() { return date; }
    public String getLocation() { return location; }
    public int getUnits() { return units; }
}