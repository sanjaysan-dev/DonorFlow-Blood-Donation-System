package com.donorflow.controller;

import com.donorflow.model.DonationDTO;
import com.donorflow.service.DonationService;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/DonateServlet")
public class DonateServlet extends HttpServlet {

    private DonationService donationService = new DonationService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        JsonObject json = new JsonObject();

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("uId");

        if (userId == null) {
            json.addProperty("status", "error");
            json.addProperty("message", "Session Expired");
            response.getWriter().print(json);
            return;
        }

        Gson gson = new Gson();
        JsonObject data = gson.fromJson(request.getReader(), JsonObject.class);

        // Create DTO
        DonationDTO dto = new DonationDTO(
                userId,
                data.get("date").getAsString(),
                data.get("location").getAsString(),
                data.has("units") ? data.get("units").getAsInt() : 1
        );

        // Call Service
        String result = donationService.processDonation(dto);

        if (result.startsWith("Success")) {
            json.addProperty("status", "success");
            json.addProperty("message", "Donation Scheduled!");
            json.addProperty("donationId", result.split(":")[1]); // Extract ID
        } else {
            json.addProperty("status", "error");
            json.addProperty("message", result.replace("Error: ", ""));
        }
        response.getWriter().print(json);
    }
}