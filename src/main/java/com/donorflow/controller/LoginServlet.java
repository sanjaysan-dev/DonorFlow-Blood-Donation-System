package com.donorflow.controller;

import com.donorflow.model.UserDTO;
import com.donorflow.services.UserService;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private UserService userService = new UserService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");

        Gson gson = new Gson();
        UserDTO loginData = gson.fromJson(request.getReader(), UserDTO.class);

        // Call Service
        UserDTO user = userService.loginUser(loginData.getEmail(), loginData.getPassword());

        JsonObject json = new JsonObject();
        if (user != null) {
            // Create Session
            HttpSession session = request.getSession();
            session.setAttribute("uId", user.getUserId());
            session.setAttribute("uName", user.getFullName());
            session.setAttribute("uRole", user.getRole());

            json.addProperty("status", "success");
            json.addProperty("message", "Login Successful!");
            json.addProperty("redirectUrl", "ADMIN".equals(user.getRole()) ? "admin_dashboard.jsp" : "user_dashboard.jsp");
        } else {
            json.addProperty("status", "error");
            json.addProperty("message", "Invalid Email or Password");
        }
        response.getWriter().print(json);
    }
}