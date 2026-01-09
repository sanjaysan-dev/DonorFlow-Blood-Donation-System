package com.donorflow.config;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBClass {
    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");

        // 1. Try to get the database URL from the Cloud Environment
        String dbUrl = System.getenv("DB_URL");
        String dbUser = System.getenv("DB_USER");
        String dbPass = System.getenv("DB_PASS");

        // 2. If no cloud variable is found, use Localhost (Fallback)
        if (dbUrl == null || dbUrl.isEmpty()) {
            // This is for when you run it in IntelliJ/Eclipse
            return DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/donordb",
                    "root",
                    "Sanjaysan3556@"
            );
        }

        // 3. If cloud variable exists, connect to Aiven/Cloud DB
        return DriverManager.getConnection(dbUrl, dbUser, dbPass);
    }
}