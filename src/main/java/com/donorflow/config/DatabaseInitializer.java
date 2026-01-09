package com.donorflow.config;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.Statement;

@WebListener
public class


DatabaseInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("--- SYSTEM STARTUP: CHECKING DATABASE TABLES ---");
        try (Connection con = DBClass.getConnection();
             Statement stmt = con.createStatement()) {

            // 1. Create Users Table
            String sqlUsers = "CREATE TABLE IF NOT EXISTS users (" +
                    "user_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "full_name VARCHAR(100), " +
                    "email VARCHAR(100) UNIQUE, " +
                    "password VARCHAR(100), " +
                    "phone_number VARCHAR(15), " +
                    "blood_group VARCHAR(5), " +
                    "city VARCHAR(50), " +
                    "last_donation_date DATE, " +
                    "role VARCHAR(10) DEFAULT 'USER')";
            stmt.executeUpdate(sqlUsers);
            System.out.println("✓ Users table verified.");

            // 2. Create Donations Table
            String sqlDonations = "CREATE TABLE IF NOT EXISTS donations (" +
                    "donation_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT, " +
                    "donation_date DATE, " +
                    "camp_location VARCHAR(100), " +
                    "units INT, " +
                    "status VARCHAR(20) DEFAULT 'Pending', " +
                    "FOREIGN KEY (user_id) REFERENCES users(user_id))";
            stmt.executeUpdate(sqlDonations);
            System.out.println("✓ Donations table verified.");

            // 3. Create Requests Table
            String sqlRequests = "CREATE TABLE IF NOT EXISTS requests (" +
                    "req_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT, " +
                    "city VARCHAR(50), " +
                    "blood_group VARCHAR(5), " +
                    "units_needed INT, " +
                    "status VARCHAR(20) DEFAULT 'Pending', " +
                    "FOREIGN KEY (user_id) REFERENCES users(user_id))";
            stmt.executeUpdate(sqlRequests);
            System.out.println("✓ Requests table verified.");

            // 4. Create Stock Table (And seed it if empty)
            String sqlStock = "CREATE TABLE IF NOT EXISTS blood_stock (" +
                    "blood_group VARCHAR(5) PRIMARY KEY, " +
                    "units_available INT DEFAULT 0)";
            stmt.executeUpdate(sqlStock);

            // Seed stock data only if table is empty
            if(!stmt.executeQuery("SELECT * FROM blood_stock").next()) {
                stmt.executeUpdate("INSERT INTO blood_stock VALUES " +
                        "('A+',0),('A-',0),('B+',0),('B-',0),('O+',0),('O-',0),('AB+',0),('AB-',0)");
                System.out.println("✓ Stock table seeded.");
            }

            // 5. Create Default Admin User
            String checkAdmin = "SELECT * FROM users WHERE email = 'admin@donorflow.com'";
            if (!stmt.executeQuery(checkAdmin).next()) {
                String createAdmin = "INSERT INTO users (full_name, email, password, role) VALUES " +
                        "('Admin', 'admin@donorflow.com', 'password', 'ADMIN')";
                stmt.executeUpdate(createAdmin);
                System.out.println("✓ Default Admin user created.");
            }

        } catch (Exception e) {
            e.printStackTrace(); // Check Render logs if this fails
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {}
}