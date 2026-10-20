package com.shopsphere.dao;

import com.shopsphere.common.model.OrderItem;
import com.shopsphere.common.model.Product;
import com.shopsphere.dao.db.DBConnectionPool;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderItemDAO {
    private static final Logger logger = LoggerFactory.getLogger(OrderItemDAO.class);
    private final ProductDAO productDAO = new ProductDAO();

    public List<OrderItem> findByOrderId(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT order_item_id, order_id, product_id, quantity, price, created_at FROM order_items WHERE order_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderItemId(rs.getInt("order_item_id"));
                    item.setOrderId(rs.getInt("order_id"));
                    int pId = rs.getInt("product_id");
                    item.setProductId(pId);
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getDouble("price"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));

                    Product p = productDAO.findById(pId);
                    item.setProduct(p);
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding items for order: {}", orderId, e);
        }
        return list;
    }

    public boolean create(OrderItem item, Connection conn) throws SQLException {
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, item.getOrderId());
            ps.setInt(2, item.getProductId());
            ps.setInt(3, item.getQuantity());
            ps.setDouble(4, item.getPrice());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        item.setOrderItemId(keys.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }
}

