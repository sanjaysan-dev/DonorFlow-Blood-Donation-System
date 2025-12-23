package com.donorflow.service;

import com.donorflow.dao.DonationDAO;
import com.donorflow.dao.UserDAO;
import com.donorflow.model.DonationDTO;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class DonationService {

    private DonationDAO donationDAO = new DonationDAO();
    private UserDAO userDAO = new UserDAO();

    public String processDonation(DonationDTO dto) {
        try {
            // 1. BUSINESS RULE: Check 90 Days
            Date lastDateSql = userDAO.getLastDonationDate(dto.getUserId());

            if (lastDateSql != null) {
                LocalDate lastDate = lastDateSql.toLocalDate();
                LocalDate newDate = LocalDate.parse(dto.getDate());
                long days = ChronoUnit.DAYS.between(lastDate, newDate);

                if (days < 90) {
                    return "Error: Safety Alert! Wait 90 days. Only " + days + " days passed.";
                }
            }

            // 2. If safe, save to DB
            int id = donationDAO.saveDonation(dto);
            return "Success:" + id;

        } catch (Exception e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        }
    }
}