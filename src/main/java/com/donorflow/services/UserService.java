package com.donorflow.services;

import com.donorflow.dao.UserDAO;
import com.donorflow.model.UserDTO;
import java.util.regex.Pattern;

public class UserService {

    private UserDAO userDAO = new UserDAO();

    // Logic: Validate inputs before calling DAO
    public String registerUser(UserDTO user) {
        if (!Pattern.matches("^[a-zA-Z\\s]+$", user.getFullName())) {
            return "Invalid Name! Only letters allowed.";
        }
        if (!Pattern.matches("^[6-9]\\d{9}$", user.getPhoneNumber())) {
            return "Invalid Phone Number! Must start with 6-9 and be 10 digits.";
        }
        if (user.getPassword().length() < 8) {
            return "Password must be at least 8 characters.";
        }

        try {
            boolean success = userDAO.register(user);
            return success ? "SUCCESS" : "Database Error";
        } catch (Exception e) {
            e.printStackTrace();
            return "User Credentials Already Registered!";
        }
    }

    public UserDTO loginUser(String email, String password) {
        try {
            return userDAO.authenticate(email, password);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}