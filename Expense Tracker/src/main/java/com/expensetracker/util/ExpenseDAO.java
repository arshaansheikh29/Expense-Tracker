package com.expensetracker.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;
import java.sql.Statement;
import java.util.LinkedHashMap;
import java.util.Map;

public class ExpenseDAO {

    public boolean addExpense(Expense expense) throws SQLException {

        String sql = "INSERT INTO expenses "
                + "(user_id, title, amount, category, expense_date, description) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, expense.getUserId());
            ps.setString(2, expense.getTitle());
            ps.setBigDecimal(3, expense.getAmount());
            ps.setString(4, expense.getCategory());
            ps.setDate(5, expense.getExpenseDate());
            ps.setString(6, expense.getDescription());

            return ps.executeUpdate() > 0;
        }
    }

    public List<Expense> getAllExpenses(int userId) throws SQLException {

        List<Expense> expenses = new ArrayList<>();

        String sql = "SELECT id, user_id, title, amount, category, "
                + "expense_date, description FROM expenses "
                + "WHERE user_id = ? ORDER BY expense_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {

                    Expense expense = new Expense();

                    expense.setId(rs.getInt("id"));
                    expense.setUserId(rs.getInt("user_id"));
                    expense.setTitle(rs.getString("title"));
                    expense.setAmount(rs.getBigDecimal("amount"));
                    expense.setCategory(rs.getString("category"));
                    expense.setExpenseDate(rs.getDate("expense_date"));
                    expense.setDescription(rs.getString("description"));

                    expenses.add(expense);
                }
            }
        }

        return expenses;
    }
    

	public Expense getExpenseById(int expenseId, int userId)
	        throws SQLException {
	
	    String sql = "SELECT id, user_id, title, amount, category, "
	            + "expense_date, description FROM expenses "
	            + "WHERE id = ? AND user_id = ?";
	
	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	
	        ps.setInt(1, expenseId);
	        ps.setInt(2, userId);
	
	        try (ResultSet rs = ps.executeQuery()) {
	            if (rs.next()) {
	                Expense expense = new Expense();
	
	                expense.setId(rs.getInt("id"));
	                expense.setUserId(rs.getInt("user_id"));
	                expense.setTitle(rs.getString("title"));
	                expense.setAmount(rs.getBigDecimal("amount"));
	                expense.setCategory(rs.getString("category"));
	                expense.setExpenseDate(rs.getDate("expense_date"));
	                expense.setDescription(rs.getString("description"));
	
	                return expense;
	            }
	        }
	    }
	
	    return null;
	}
	
	public boolean updateExpense(Expense expense, int userId)
	        throws SQLException {
	
	    String sql = "UPDATE expenses SET title = ?, amount = ?, "
	            + "category = ?, expense_date = ?, description = ? "
	            + "WHERE id = ? AND user_id = ?";
	
	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	
	        ps.setString(1, expense.getTitle());
	        ps.setBigDecimal(2, expense.getAmount());
	        ps.setString(3, expense.getCategory());
	        ps.setDate(4, expense.getExpenseDate());
	        ps.setString(5, expense.getDescription());
	        ps.setInt(6, expense.getId());
	        ps.setInt(7, userId);
	
	        return ps.executeUpdate() > 0;
	    }
	}
	

	public boolean deleteExpense(int expenseId, int userId)
	        throws SQLException {
	
	    String sql = "DELETE FROM expenses WHERE id = ? AND user_id = ?";
	
	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	
	        ps.setInt(1, expenseId);
	        ps.setInt(2, userId);
	
	        return ps.executeUpdate() > 0;
	    }
	}
	

	public BigDecimal getTotalExpenses(int userId) throws SQLException {
	
	    String sql = "SELECT COALESCE(SUM(amount), 0) "
	               + "FROM expenses WHERE user_id = ?";
	
	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	
	        ps.setInt(1, userId);
	
	        try (ResultSet rs = ps.executeQuery()) {
	            if (rs.next()) {
	                return rs.getBigDecimal(1);
	            }
	        }
	    }
	
	    return BigDecimal.ZERO;
	}

	public int getExpenseCount(int userId) throws SQLException {
	
	    String sql = "SELECT COUNT(*) FROM expenses WHERE user_id = ?";
	
	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	
	        ps.setInt(1, userId);
	
	        try (ResultSet rs = ps.executeQuery()) {
	            if (rs.next()) {
	                return rs.getInt(1);
	            }
	        }
	    }
	
	    return 0;
	}
	

	public java.util.Map<String, java.math.BigDecimal> getCategorySummary(int userId)
	        throws java.sql.SQLException {
	
	    java.util.Map<String, java.math.BigDecimal> summary =
	            new java.util.LinkedHashMap<>();
	
	    String sql = "SELECT category, SUM(amount) AS total " +
	                 "FROM expenses WHERE user_id = ? " +
	                 "GROUP BY category ORDER BY total DESC";
	
	    try (java.sql.Connection con =
	                 com.expensetracker.util.DBConnection.getConnection();
	         java.sql.PreparedStatement ps = con.prepareStatement(sql)) {
	
	        ps.setInt(1, userId);
	
	        try (java.sql.ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                String category = rs.getString("category");
	
	                if (category == null || category.trim().isEmpty()) {
	                    category = "Uncategorized";
	                }
	
	                summary.put(category, rs.getBigDecimal("total"));
	            }
	        }
	    }
	
	    return summary;
	}
	

	public java.util.Map<String, java.math.BigDecimal> getMonthlySummary(int userId)
	        throws java.sql.SQLException {
	
	    java.util.Map<String, java.math.BigDecimal> summary =
	            new java.util.LinkedHashMap<>();
	
	    String sql = "SELECT DATE_FORMAT(expense_date, '%Y-%m') AS expense_month, " +
	                 "SUM(amount) AS total " +
	                 "FROM expenses " +
	                 "WHERE user_id = ? " +
	                 "GROUP BY DATE_FORMAT(expense_date, '%Y-%m') " +
	                 "ORDER BY expense_month DESC";
	
	    try (java.sql.Connection con =
	                 com.expensetracker.util.DBConnection.getConnection();
	         java.sql.PreparedStatement ps = con.prepareStatement(sql)) {
	
	        ps.setInt(1, userId);
	
	        try (java.sql.ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                summary.put(
	                    rs.getString("expense_month"),
	                    rs.getBigDecimal("total")
	                );
	            }
	        }
	    }
	
	    return summary;
	}
	

	public java.util.List<Expense> getExpensesByMonth(
	        int userId, int year, int month) throws java.sql.SQLException {
	
	    java.util.List<Expense> expenses = new java.util.ArrayList<>();
	
	    String sql = "SELECT id, title, amount, category, expense_date, " +
	                 "description, user_id FROM expenses " +
	                 "WHERE user_id = ? " +
	                 "AND YEAR(expense_date) = ? " +
	                 "AND MONTH(expense_date) = ? " +
	                 "ORDER BY expense_date DESC, id DESC";
	
	    try (java.sql.Connection con =
	                 com.expensetracker.util.DBConnection.getConnection();
	         java.sql.PreparedStatement ps = con.prepareStatement(sql)) {
	
	        ps.setInt(1, userId);
	        ps.setInt(2, year);
	        ps.setInt(3, month);
	
	        try (java.sql.ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                Expense expense = new Expense();
	
	                expense.setId(rs.getInt("id"));
	                expense.setTitle(rs.getString("title"));
	                expense.setAmount(rs.getBigDecimal("amount"));
	                expense.setCategory(rs.getString("category"));
	                expense.setExpenseDate(rs.getDate("expense_date"));
	                expense.setDescription(rs.getString("description"));
	                expense.setUserId(rs.getInt("user_id"));
	
	                expenses.add(expense);
	            }
	        }
	    }
	
	    return expenses;
	}
	

	public Map<String, BigDecimal> getCategorySummaryByMonth(
	        int userId, int year, int month) throws SQLException {
	
	    Map<String, BigDecimal> categorySummary = new LinkedHashMap<>();
	
	    String sql = "SELECT category, SUM(amount) AS total " +
	                 "FROM expenses " +
	                 "WHERE user_id = ? " +
	                 "AND YEAR(expense_date) = ? " +
	                 "AND MONTH(expense_date) = ? " +
	                 "GROUP BY category " +
	                 "ORDER BY total DESC";
	
	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	
	        ps.setInt(1, userId);
	        ps.setInt(2, year);
	        ps.setInt(3, month);
	
	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                categorySummary.put(
	                    rs.getString("category"),
	                    rs.getBigDecimal("total")
	                );
	            }
	        }
	    }
	
	    return categorySummary;
	}
}
