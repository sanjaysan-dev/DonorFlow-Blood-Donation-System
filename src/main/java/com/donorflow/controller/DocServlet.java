package com.donorflow.controller;

import com.donorflow.config.DBClass;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DocServlet")
public class DocServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String type = request.getParameter("type");
        String doc = request.getParameter("doc");
        String idStr = request.getParameter("id");

        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (idStr == null) return;
        int id = Integer.parseInt(idStr);

        try {
            // Data Holders
            String date = "", location = "", group = "", units = "", status = "";
            String userName = "", userPhone = "", userEmail = "", userId = "";

            Connection con = DBClass.getConnection();

            // 1. FETCH DONATION DATA
            if ("donation".equals(type)) {
                String sql = "SELECT d.*, u.full_name, u.phone_number, u.email FROM donations d JOIN users u ON d.user_id = u.user_id WHERE d.donation_id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    date = rs.getString("donation_date");
                    location = rs.getString("camp_location");
                    units = String.valueOf(rs.getInt("units"));
                    status = rs.getString("status");
                    userId = String.valueOf(rs.getInt("user_id"));
                    userName = rs.getString("full_name");
                    userPhone = rs.getString("phone_number");
                    userEmail = rs.getString("email");
                }
            }
            // 2. FETCH REQUEST DATA
            else {
                String sql = "SELECT r.*, u.full_name, u.phone_number, u.email FROM requests r JOIN users u ON r.user_id = u.user_id WHERE r.req_id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    group = rs.getString("blood_group");
                    units = String.valueOf(rs.getInt("units_needed"));
                    location = rs.getString("city");
                    status = rs.getString("status");
                    userId = String.valueOf(rs.getInt("user_id"));
                    userName = rs.getString("full_name");
                    userPhone = rs.getString("phone_number");
                    userEmail = rs.getString("email");
                }
            }
            con.close();

            // --- HTML START ---
            out.println("<html><head><title>Official Document</title>");
            out.println("<style>");
            out.println("body { font-family: 'Segoe UI', sans-serif; background: #525659; padding: 40px; display: flex; justify-content: center; }");
            out.println(".paper { background: white; width: 800px; padding: 50px; border: 1px solid #ccc; position: relative; min-height: 800px; }");

            // Border Design
            out.println(".border-box { border: 5px double #333; height: 95%; padding: 30px; position: relative; }");

            // Header
            out.println(".header { text-align: center; margin-bottom: 30px; border-bottom: 2px solid #cc0000; padding-bottom: 20px; }");
            out.println("h1 { color: #cc0000; font-size: 40px; margin: 0; text-transform: uppercase; letter-spacing: 2px; }");
            out.println(".sub-head { color: #555; text-transform: uppercase; font-size: 12px; letter-spacing: 4px; }");

            // Content
            out.println(".content { margin-top: 30px; }");
            out.println(".row { display: flex; justify-content: space-between; border-bottom: 1px dashed #ddd; padding: 12px 0; font-size: 16px; }");
            out.println(".label { font-weight: bold; color: #666; }");
            out.println(".val { font-weight: bold; font-size: 18px; color: #000; }");

            // STAMPS & BADGES
            out.println(".badge-container { text-align: center; margin-top: 50px; }");
            out.println(".success-badge { border: 3px solid #2e7d32; color: #2e7d32; padding: 15px 40px; font-size: 24px; font-weight: bold; text-transform: uppercase; border-radius: 10px; display: inline-block; letter-spacing: 2px; transform: rotate(-5deg); box-shadow: 0 0 10px #a5d6a7 inset; }");
            out.println(".pending-badge { border: 3px dashed #757575; color: #757575; padding: 10px 30px; font-size: 20px; font-weight: bold; text-transform: uppercase; display: inline-block; }");

            // Footer
            out.println(".footer { position: absolute; bottom: 30px; width: 100%; text-align: center; font-size: 11px; color: #aaa; }");

            // Print Button
            out.println(".btn { position: fixed; bottom: 30px; right: 30px; padding: 15px 30px; background: #cc0000; color: white; border: none; font-weight: bold; cursor: pointer; border-radius: 5px; box-shadow: 0 5px 15px rgba(0,0,0,0.3); }");
            out.println("@media print { body { background: white; margin: 0; } .paper { box-shadow: none; border: none; } .btn { display: none; } }");
            out.println("</style></head><body>");

            out.println("<div class='paper'><div class='border-box'>");

            // Header
            out.println("<div class='header'>");
            out.println("<h1>DonorFlow</h1>");
            out.println("<div class='sub-head'>Life Saving Network • Official Record</div>");
            out.println("</div>");

            // --- LOGIC: WHAT TO SHOW? ---

            // 1. DONATION (APPROVED) -> CERTIFICATE
            if(type.equals("donation") && status.equalsIgnoreCase("Approved") && doc.equals("cert")) {
                out.println("<h2 style='text-align:center; color:#b8860b; font-family:serif; font-size:32px; margin-bottom:10px;'>Certificate of Appreciation</h2>");
                out.println("<p style='text-align:center; font-style:italic; font-size:18px;'>\"Presented with gratitude for saving a life.\"</p>");

                out.println("<div class='content'>");
                out.println("<p>This document certifies that <b>" + userName + "</b> (ID: " + userId + ") has successfully donated blood.</p>");
                out.println("<div class='row'><span class='label'>Donation Date:</span> <span class='val'>" + date + "</span></div>");
                out.println("<div class='row'><span class='label'>Camp Location:</span> <span class='val'>" + location + "</span></div>");
                out.println("<div class='row'><span class='label'>Units Donated:</span> <span class='val'>" + units + " Unit(s)</span></div>");
                out.println("</div>");

                out.println("<div class='badge-container'><div class='success-badge'>&#10004; SUCCESSFULLY COMPLETED</div></div>");
            }

            // 2. REQUEST (APPROVED) -> APPROVAL LETTER
            else if(type.equals("request") && status.equalsIgnoreCase("Approved") && doc.equals("cert")) {
                out.println("<h2 style='text-align:center; color:#2e7d32; text-decoration:underline;'>OFFICIAL APPROVAL LETTER</h2>");

                out.println("<div class='content'>");
                out.println("<p>This letter confirms that the blood request for <b>" + userName + "</b> has been reviewed and <b>APPROVED</b> by the Admin.</p>");
                out.println("<div class='row'><span class='label'>Blood Group:</span> <span class='val'>" + group + "</span></div>");
                out.println("<div class='row'><span class='label'>Units Allocated:</span> <span class='val'>" + units + " Unit(s)</span></div>");
                out.println("<div class='row'><span class='label'>Collection Center:</span> <span class='val'>" + location + "</span></div>");
                out.println("</div>");

                out.println("<div class='badge-container'><div class='success-badge'>&#10004; APPROVED & VERIFIED</div></div>");
                out.println("<p style='text-align:center; margin-top:20px; font-size:12px; color:blue;'>* Please present this digital letter at the hospital counter.</p>");
            }

            // 3. PENDING SLIPS (If status is not approved yet)
            else {
                out.println("<h2 style='text-align:center; color:#555;'>Receipt of Acknowledgement</h2>");
                out.println("<div class='content'>");

                if(type.equals("donation")) {
                    out.println("<div class='row'><span class='label'>Donor Name:</span> <span class='val'>" + userName + "</span></div>");
                    out.println("<div class='row'><span class='label'>Registration Date:</span> <span class='val'>" + date + "</span></div>");
                    out.println("<div class='row'><span class='label'>Location:</span> <span class='val'>" + location + "</span></div>");
                } else {
                    out.println("<div class='row'><span class='label'>Requester Name:</span> <span class='val'>" + userName + "</span></div>");
                    out.println("<div class='row'><span class='label'>Blood Needed:</span> <span class='val'>" + group + "</span></div>");
                    out.println("<div class='row'><span class='label'>Units:</span> <span class='val'>" + units + "</span></div>");
                }
                out.println("<div class='row'><span class='label'>Current Status:</span> <span class='val' style='color:#e65100;'>" + status + "</span></div>");
                out.println("</div>");

                out.println("<div class='badge-container'><div class='pending-badge'>WAITING FOR APPROVAL</div></div>");
            }

            out.println("<div class='footer'>DonorFlow Automated System • " + new java.util.Date() + "</div>");

            out.println("</div></div>"); // End Divs
            out.println("<button class='btn' onclick='window.print()'>🖨️ Print / Save PDF</button>");
            out.println("</body></html>");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}