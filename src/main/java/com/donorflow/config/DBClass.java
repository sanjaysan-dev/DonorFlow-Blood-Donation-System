package com.donorflow.config;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBClass {
    public static Connection getConnection() throws Exception{
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/donordb", "root" , "Sanjaysan3556@");
    }
}
