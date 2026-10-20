package com.shopsphere.dao;

import com.shopsphere.common.model.Coupon;
import com.shopsphere.dao.db.DBConnectionPool;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CouponDAO {
    private static final Logger logger = LoggerFactory.getLogger(CouponDAO.class);

    public Coupon findByCode(String code) {
        String sql = "SELECT coupon_id, code, discount_type, discount_value, minimum_order, maximum_discount, expiry_date, status, created_at " +
                     "FROM coupons WHERE UPPER(code) = UPPER(?) AND status = TRUE";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding coupon by code: {}", code, e);
        }
        return null;
    }

    public List<Coupon> findAll() {
        List<Coupon> list = new ArrayList<>();
        String sql = "SELECT coupon_id, code, discount_type, discount_value, minimum_order, maximum_discount, expiry_date, status, created_at FROM coupons ORDER BY created_at DESC";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            logger.error("Error finding all coupons", e);
        }
        return list;
    }

    public boolean create(Coupon c) {
        String sql = "INSERT INTO coupons (code, discount_type, discount_value, minimum_order, maximum_discount, expiry_date, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, c.getCode().trim().toUpperCase());
            ps.setString(2, c.getDiscountType());
            ps.setDouble(3, c.getDiscountValue());
            ps.setDouble(4, c.getMinimumOrder());
            if (c.getMaximumDiscount() != null) {
                ps.setDouble(5, c.getMaximumDiscount());
            } else {
                ps.setNull(5, Types.DECIMAL);
            }
            ps.setTimestamp(6, c.getExpiryDate());
            ps.setBoolean(7, c.isStatus());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        c.setCouponId(keys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error creating coupon: {}", c.getCode(), e);
        }
        return false;
    }

    public boolean updateStatus(int couponId, boolean status) {
        String sql = "UPDATE coupons SET status = ? WHERE coupon_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, status);
            ps.setInt(2, couponId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating coupon status: {}", couponId, e);
        }
        return false;
    }

    public boolean delete(int couponId) {
        String sql = "DELETE FROM coupons WHERE coupon_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, couponId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error deleting coupon: {}", couponId, e);
        }
        return false;
    }

    public boolean update(Coupon c) {
        String sql = "UPDATE coupons SET code = ?, discount_type = ?, discount_value = ?, minimum_order = ?, maximum_discount = ?, expiry_date = ?, status = ? WHERE coupon_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getCode().trim().toUpperCase());
            ps.setString(2, c.getDiscountType());
            ps.setDouble(3, c.getDiscountValue());
            ps.setDouble(4, c.getMinimumOrder());
            if (c.getMaximumDiscount() != null) {
                ps.setDouble(5, c.getMaximumDiscount());
            } else {
                ps.setNull(5, Types.DECIMAL);
            }
            ps.setTimestamp(6, c.getExpiryDate());
            ps.setBoolean(7, c.isStatus());
            ps.setInt(8, c.getCouponId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating coupon: {}", c.getCouponId(), e);
        }
        return false;
    }

    public List<Coupon> searchCoupons(String query) {
        if (query == null || query.trim().isEmpty()) {
            return findAll();
        }
        List<Coupon> list = new ArrayList<>();
        String sql = "SELECT coupon_id, code, discount_type, discount_value, minimum_order, maximum_discount, expiry_date, status, created_at " +
                     "FROM coupons WHERE UPPER(code) LIKE ? ORDER BY created_at DESC";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + query.trim().toUpperCase() + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error searching coupons", e);
        }
        return list;
    }

    private Coupon mapRow(ResultSet rs) throws SQLException {
        Coupon c = new Coupon();
        c.setCouponId(rs.getInt("coupon_id"));
        c.setCode(rs.getString("code"));
        c.setDiscountType(rs.getString("discount_type"));
        c.setDiscountValue(rs.getDouble("discount_value"));
        c.setMinimumOrder(rs.getDouble("minimum_order"));
        double maxDisc = rs.getDouble("maximum_discount");
        if (!rs.wasNull()) {
            c.setMaximumDiscount(maxDisc);
        }
        c.setExpiryDate(rs.getTimestamp("expiry_date"));
        c.setStatus(rs.getBoolean("status"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        return c;
    }
}

