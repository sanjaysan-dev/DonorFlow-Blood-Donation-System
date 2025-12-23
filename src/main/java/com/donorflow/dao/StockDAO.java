package com.donorflow.dao;

import com.donorflow.config.DBClass;
import java.sql.*;

public class StockDAO {

    // 1. GET STOCK: Check how many units we have
    public int getStock(String bloodGroup) throws Exception {
        Connection con = DBClass.getConnection();
        PreparedStatement ps = con.prepareStatement("SELECT units_available FROM blood_stock WHERE blood_group=?");
        ps.setString(1, bloodGroup);
        ResultSet rs = ps.executeQuery();

        int stock = 0;
        if (rs.next()) {
            stock = rs.getInt("units_available");
        }
        con.close();
        return stock;
    }

    // 2. UPDATE STOCK: Increase or Decrease
    public void updateStock(String bloodGroup, int amount) throws Exception {
        Connection con = DBClass.getConnection();
        // 'amount' can be positive (Donate) or negative (Request)
        String sql = "UPDATE blood_stock SET units_available = units_available + ? WHERE blood_group=?";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, amount);
        ps.setString(2, bloodGroup);
        ps.executeUpdate();
        con.close();
    }
}