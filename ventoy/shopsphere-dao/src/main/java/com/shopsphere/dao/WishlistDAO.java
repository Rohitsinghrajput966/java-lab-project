package com.shopsphere.dao;

import com.shopsphere.common.model.Product;
import com.shopsphere.common.model.WishlistItem;
import com.shopsphere.dao.db.DBConnectionPool;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WishlistDAO {
    private static final Logger logger = LoggerFactory.getLogger(WishlistDAO.class);
    private final ProductDAO productDAO = new ProductDAO();

    public List<WishlistItem> getItemsByUserId(int userId) {
        List<WishlistItem> list = new ArrayList<>();
        String sql = "SELECT wishlist_id, user_id, product_id, created_at FROM wishlist WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WishlistItem item = new WishlistItem();
                    item.setWishlistId(rs.getInt("wishlist_id"));
                    item.setUserId(rs.getInt("user_id"));
                    int pId = rs.getInt("product_id");
                    item.setProductId(pId);
                    item.setCreatedAt(rs.getTimestamp("created_at"));

                    Product p = productDAO.findById(pId);
                    item.setProduct(p);
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            logger.error("Error retrieving wishlist for user: {}", userId, e);
        }
        return list;
    }

    public boolean addItem(int userId, int productId) {
        String sql = "INSERT IGNORE INTO wishlist (user_id, product_id) VALUES (?, ?)";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error adding to wishlist for user: {}", userId, e);
        }
        return false;
    }

    public boolean removeItem(int userId, int productId) {
        String sql = "DELETE FROM wishlist WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error removing from wishlist for user: {}", userId, e);
        }
        return false;
    }

    public boolean isInWishlist(int userId, int productId) {
        String sql = "SELECT 1 FROM wishlist WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.error("Error checking wishlist", e);
        }
        return false;
    }
}

