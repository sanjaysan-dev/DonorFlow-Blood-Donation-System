package com.donorflow.services;

import com.donorflow.config.DBClass;
import com.donorflow.dao.DonationDAO;
import com.donorflow.dao.RequestDAO;
import com.donorflow.dao.StockDAO;
import com.donorflow.model.RequestDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AdminService {

    private StockDAO stockDAO = new StockDAO();
    private RequestDAO requestDAO = new RequestDAO();
    private DonationDAO donationDAO = new DonationDAO();

    // 1. APPROVE REQUEST LOGIC
    public String approveRequest(int reqId) {
        try {
            RequestDTO req = requestDAO.getRequestById(reqId);
            if (req == null) return "Error: Request not found";

            int currentStock = stockDAO.getStock(req.getBloodGroup());
            if (currentStock >= req.getUnits()) {
                requestDAO.updateStatus(reqId, "Approved");
                stockDAO.updateStock(req.getBloodGroup(), -req.getUnits()); // Deduct Stock
                return "Request Approved & Stock Deducted";
            } else {
                return "Error: Insufficient Stock! Available: " + currentStock;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        }
    }

    // 2. APPROVE DONATION LOGIC (THIS WAS MISSING!)
    public String approveDonation(int donationId) {
        Connection con = null;
        try {
            con = DBClass.getConnection();

            // Step A: Get Donor Details (Need Blood Group from User table)
            String sqlGet = "SELECT d.donation_date, d.user_id, u.blood_group FROM donations d " +
                    "JOIN users u ON d.user_id = u.user_id WHERE d.donation_id = ?";

            PreparedStatement psGet = con.prepareStatement(sqlGet);
            psGet.setInt(1, donationId);
            ResultSet rs = psGet.executeQuery();

            if (rs.next()) {
                String bloodGroup = rs.getString("blood_group");
                int userId = rs.getInt("user_id");
                String date = rs.getString("donation_date");

                // Step B: Update Donation Status to 'Approved'
                PreparedStatement psUpdate = con.prepareStatement("UPDATE donations SET status='Approved' WHERE donation_id=?");
                psUpdate.setInt(1, donationId);
                psUpdate.executeUpdate();

                // Step C: Add to Stock (+1 unit)
                stockDAO.updateStock(bloodGroup, 1);

                // Step D: Update User's Last Donation Date
                PreparedStatement psUser = con.prepareStatement("UPDATE users SET last_donation_date=? WHERE user_id=?");
                psUser.setString(1, date);
                psUser.setInt(2, userId);
                psUser.executeUpdate();

                return "Donation Approved & Stock Updated";
            } else {
                return "Error: Donation ID not found";
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
    }

    // 3. REJECTION HELPERS
    public void rejectRequest(int id) throws Exception { requestDAO.updateStatus(id, "Rejected"); }
    public void rejectDonation(int id) throws Exception { donationDAO.updateStatus(id, "Rejected"); }
}