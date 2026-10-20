package com.shopsphere.dao;

import com.shopsphere.common.model.Review;
import com.shopsphere.dao.db.DBConnectionPool;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {
    private static final Logger logger = LoggerFactory.getLogger(ReviewDAO.class);

    public List<Review> findByProductId(int productId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.review_id, r.user_id, u.name AS user_name, r.product_id, r.rating, r.review_text, r.created_at " +
                     "FROM reviews r JOIN users u ON r.user_id = u.user_id " +
                     "WHERE r.product_id = ? ORDER BY r.created_at DESC";

        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review r = new Review();
                    r.setReviewId(rs.getInt("review_id"));
                    r.setUserId(rs.getInt("user_id"));
                    r.setUserName(rs.getString("user_name"));
                    r.setProductId(rs.getInt("product_id"));
                    r.setRating(rs.getInt("rating"));
                    r.setReviewText(rs.getString("review_text"));
                    r.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding reviews for product: {}", productId, e);
        }
        return list;
    }

    public boolean addReview(Review r) {
        String sql = "INSERT INTO reviews (user_id, product_id, rating, review_text) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, r.getUserId());
            ps.setInt(2, r.getProductId());
            ps.setInt(3, Math.min(5, Math.max(1, r.getRating())));
            ps.setString(4, r.getReviewText());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error adding review for product: {}", r.getProductId(), e);
        }
        return false;
    }
}

