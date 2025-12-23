package com.donorflow.controller;

import com.donorflow.dao.RequestDAO;
import com.donorflow.model.RequestDTO;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/RequestServlet")
public class RequestServlet extends HttpServlet {

    // Direct DAO usage is okay for simple inserts without logic
    private RequestDAO requestDAO = new RequestDAO();

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
        RequestDTO reqData = gson.fromJson(request.getReader(), RequestDTO.class);

        try {
            boolean success = requestDAO.saveRequest(userId, reqData);
            if (success) {
                json.addProperty("status", "success");
                json.addProperty("message", "Request Posted!");
            } else {
                json.addProperty("status", "error");
                json.addProperty("message", "Database Error");
            }
        } catch (Exception e) {
            json.addProperty("status", "error");
            json.addProperty("message", "Server Error: " + e.getMessage());
        }
        response.getWriter().print(json);
    }
}