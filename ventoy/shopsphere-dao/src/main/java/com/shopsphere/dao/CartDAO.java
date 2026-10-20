package com.shopsphere.dao;

import com.shopsphere.common.model.CartItem;
import com.shopsphere.common.model.Product;
import com.shopsphere.dao.db.DBConnectionPool;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    private static final Logger logger = LoggerFactory.getLogger(CartDAO.class);
    private final ProductDAO productDAO = new ProductDAO();

    public List<CartItem> getItemsByUserId(int userId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT cart_id, user_id, product_id, quantity, created_at FROM cart WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setCartId(rs.getInt("cart_id"));
                    item.setUserId(rs.getInt("user_id"));
                    int pId = rs.getInt("product_id");
                    item.setProductId(pId);
                    item.setQuantity(rs.getInt("quantity"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));

                    Product p = productDAO.findById(pId);
                    item.setProduct(p);
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            logger.error("Error retrieving cart items for user: {}", userId, e);
        }
        return list;
    }

    public boolean addItem(int userId, int productId, int quantity) {
        String sql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity)";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setInt(3, Math.max(1, quantity));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error adding product {} to cart for user {}", productId, userId, e);
        }
        return false;
    }

    public boolean updateQuantity(int userId, int productId, int quantity) {
        if (quantity <= 0) {
            return removeItem(userId, productId);
        }
        String sql = "UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, userId);
            ps.setInt(3, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating cart quantity for user: {}", userId, e);
        }
        return false;
    }

    public boolean removeItem(int userId, int productId) {
        String sql = "DELETE FROM cart WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error removing item from cart for user: {}", userId, e);
        }
        return false;
    }

    public boolean clearCart(int userId) {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            logger.error("Error clearing cart for user: {}", userId, e);
        }
        return false;
    }

    public int getCartItemCount(int userId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM cart WHERE user_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.error("Error counting cart items for user: {}", userId, e);
        }
        return 0;
    }
}

