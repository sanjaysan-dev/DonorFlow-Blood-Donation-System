package com.donorflow.dao;

import com.donorflow.config.DBClass;
import com.donorflow.model.RequestDTO;
import java.sql.*;

public class RequestDAO {

    // 1. SAVE: Insert request
    public boolean saveRequest(int userId, RequestDTO req) throws Exception {
        Connection con = DBClass.getConnection();
        String sql = "INSERT INTO requests (user_id, city, blood_group, units_needed, status) VALUES (?, ?, ?, ?, 'Pending')";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, userId);
        ps.setString(2, req.getCity());
        ps.setString(3, req.getBloodGroup());
        ps.setInt(4, req.getUnits());

        int rows = ps.executeUpdate();
        con.close();
        return rows > 0;
    }

    // 2. UPDATE: Admin Approve/Reject
    public void updateStatus(int id, String status) throws Exception {
        Connection con = DBClass.getConnection();
        PreparedStatement ps = con.prepareStatement("UPDATE requests SET status=? WHERE req_id=?");
        ps.setString(1, status);
        ps.setInt(2, id);
        ps.executeUpdate();
        con.close();
    }

    // 3. GET INFO: Needed for Admin stock check
    public RequestDTO getRequestById(int id) throws Exception {
        Connection con = DBClass.getConnection();
        PreparedStatement ps = con.prepareStatement("SELECT blood_group, units_needed, city FROM requests WHERE req_id=?");
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();

        RequestDTO dto = null;
        if(rs.next()){
            dto = new RequestDTO();
            dto.setBloodGroup(rs.getString("blood_group"));
            dto.setUnits(rs.getInt("units_needed"));
            dto.setCity(rs.getString("city"));
        }
        con.close();
        return dto;
    }
}