package com.donorflow.controller;

import com.donorflow.model.UserDTO;
import com.donorflow.services.UserService;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private UserService userService = new UserService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");

        // 1. Parse Data
        Gson gson = new Gson();
        UserDTO user = gson.fromJson(request.getReader(), UserDTO.class);

        // 2. Call Service
        String result = userService.registerUser(user);

        // 3. Send Response
        JsonObject json = new JsonObject();
        if ("SUCCESS".equals(result)) {
            json.addProperty("status", "success");
            json.addProperty("message", "Registration Successful!");
        } else {
            json.addProperty("status", "error");
            json.addProperty("message", result);
        }
        response.getWriter().print(json);
    }
}