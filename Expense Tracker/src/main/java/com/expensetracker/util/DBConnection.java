package com.expensetracker.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL ="jdbc:mysql://localhost:3306/expense_tracker";

    private static final String USER = "root";
    private static final String PASSWORD = "mas29";

    private DBConnection() {
    }

    public static Connection getConnection() throws SQLException {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found. Check the Database Connector JAR.",e);
        }

        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
