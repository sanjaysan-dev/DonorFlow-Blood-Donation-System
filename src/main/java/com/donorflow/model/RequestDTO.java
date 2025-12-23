package com.donorflow.model;

public class RequestDTO {
    private String city;
    private String bloodGroup;
    private int units;

    public String getCity() { return city; }
    public String getBloodGroup() { return bloodGroup; }
    public int getUnits() { return units; }

    public void setCity(String city) {
        this.city = city;
    }

    public void setBloodGroup(String bloodGroup) {
        this.bloodGroup = bloodGroup;
    }

    public void setUnits(int units) {
        this.units = units;
    }
}
