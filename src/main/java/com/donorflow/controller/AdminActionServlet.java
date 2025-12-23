package com.donorflow.controller;

import com.donorflow.services.AdminService;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/AdminActionServlet")
public class AdminActionServlet extends HttpServlet {

    private AdminService adminService = new AdminService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if (idStr == null) { response.sendRedirect("admin_dashboard.jsp?error=Invalid ID"); return; }
        int id = Integer.parseInt(idStr);
        String result = "";

        try {
            switch (action) {
                case "approveRequest":
                    result = adminService.approveRequest(id);
                    break;
                case "approveDonation":
                    result = adminService.approveDonation(id);
                    break;
                case "rejectRequest":
                    adminService.rejectRequest(id);
                    result = "Request Rejected";
                    break;
                case "rejectDonation":
                    adminService.rejectDonation(id);
                    result = "Donation Rejected";
                    break;
            }

            if (result.startsWith("Error")) {
                response.sendRedirect("admin_dashboard.jsp?error=" + result);
            } else {
                response.sendRedirect("admin_dashboard.jsp?msg=" + result);
            }

        } catch (Exception e) {
            response.sendRedirect("admin_dashboard.jsp?error=Server Error");
        }
    }
}