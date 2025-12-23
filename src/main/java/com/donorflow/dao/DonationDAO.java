package com.donorflow.dao;

import com.donorflow.config.DBClass;
import com.donorflow.model.DonationDTO;
import java.sql.*;

public class DonationDAO {

    // 1. SAVE: Insert donation & return the new ID
    public int saveDonation(DonationDTO d) throws Exception {
        Connection con = DBClass.getConnection();
        String sql = "INSERT INTO donations (user_id, donation_date, camp_location, units, status) VALUES (?, ?, ?, ?, 'Pending')";

        PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        ps.setInt(1, d.getUserId());
        ps.setString(2, d.getDate());
        ps.setString(3, d.getLocation());
        ps.setInt(4, d.getUnits());

        ps.executeUpdate();

        int newId = 0;
        ResultSet rs = ps.getGeneratedKeys();
        if (rs.next()) {
            newId = rs.getInt(1);
        }
        con.close();
        return newId;
    }

    // 2. GET: Retrieve details for the PDF Slip
    public DonationDTO getDonationById(int id) throws Exception {
        Connection con = DBClass.getConnection();
        PreparedStatement ps = con.prepareStatement("SELECT * FROM donations WHERE donation_id=?");
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();

        DonationDTO dto = null;
        if (rs.next()) {
            // Note: We use a simple DTO here just to carry data to the PDF generator
            dto = new DonationDTO(
                    rs.getInt("user_id"),
                    rs.getString("donation_date"),
                    rs.getString("camp_location"),
                    rs.getInt("units")
            );
            // You might need to add a 'status' field to your DTO if you want to print status
        }
        con.close();
        return dto;
    }

    // 3. UPDATE: Admin Approve/Reject
    public void updateStatus(int id, String status) throws Exception {
        Connection con = DBClass.getConnection();
        PreparedStatement ps = con.prepareStatement("UPDATE donations SET status=? WHERE donation_id=?");
        ps.setString(1, status);
        ps.setInt(2, id);
        ps.executeUpdate();
        con.close();
    }
}