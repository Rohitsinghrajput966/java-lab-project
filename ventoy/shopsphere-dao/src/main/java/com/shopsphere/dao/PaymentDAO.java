package com.shopsphere.dao;

import com.shopsphere.common.model.Payment;
import com.shopsphere.dao.db.DBConnectionPool;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;

public class PaymentDAO {
    private static final Logger logger = LoggerFactory.getLogger(PaymentDAO.class);

    public Payment findByOrderId(int orderId) {
        String sql = "SELECT payment_id, order_id, payment_method, transaction_reference, amount, payment_status, created_at FROM payments WHERE order_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Payment p = new Payment();
                    p.setPaymentId(rs.getInt("payment_id"));
                    p.setOrderId(rs.getInt("order_id"));
                    p.setPaymentMethod(rs.getString("payment_method"));
                    p.setTransactionReference(rs.getString("transaction_reference"));
                    p.setAmount(rs.getDouble("amount"));
                    p.setPaymentStatus(rs.getString("payment_status"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));
                    return p;
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding payment for order: {}", orderId, e);
        }
        return null;
    }
}

