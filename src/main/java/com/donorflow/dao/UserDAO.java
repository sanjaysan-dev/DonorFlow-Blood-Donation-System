package com.donorflow.dao;

import com.donorflow.config.DBClass;
import com.donorflow.model.UserDTO;
import java.sql.*;

public class UserDAO {

    // 1. LOGIN: Check if user exists
    public UserDTO authenticate(String email, String password) throws Exception {
        Connection con = DBClass.getConnection();
        String sql = "SELECT * FROM users WHERE email=? AND password=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, email);
        ps.setString(2, password);
        ResultSet rs = ps.executeQuery();

        UserDTO user = null;
        if (rs.next()) {
            user = new UserDTO();
            user.setUserId(rs.getInt("user_id"));
            user.setFullName(rs.getString("full_name"));
            user.setRole(rs.getString("role"));
        }
        con.close();
        return user;
    }

    public boolean register(UserDTO user) throws Exception {
        Connection con = DBClass.getConnection();
        String sql = "INSERT INTO users(full_name, email, phone_number, password, blood_group, city, last_donation_date, role) VALUES (?, ?, ?, ?, ?, ?, ?, 'USER')";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, user.getFullName());
        ps.setString(2, user.getEmail());
        ps.setString(3, user.getPhoneNumber());
        ps.setString(4, user.getPassword());
        ps.setString(5, user.getBloodGroup());
        ps.setString(6, user.getCity());

        if (user.getLastDonateDate() == null || user.getLastDonateDate().isEmpty()) {
            ps.setNull(7, Types.DATE);
        } else {
            ps.setString(7, user.getLastDonateDate());
        }

        int rows = ps.executeUpdate();
        con.close();
        return rows > 0;
    }

    public Date getLastDonationDate(int userId) throws Exception {
        Connection con = DBClass.getConnection();
        PreparedStatement ps = con.prepareStatement("SELECT last_donation_date FROM users WHERE user_id=?");
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        Date date = null;
        if (rs.next()) {
            date = rs.getDate("last_donation_date");
        }
        con.close();
        return date;
    }
}