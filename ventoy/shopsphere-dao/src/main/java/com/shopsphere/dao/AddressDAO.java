package com.shopsphere.dao;

import com.shopsphere.common.model.Address;
import com.shopsphere.dao.db.DBConnectionPool;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AddressDAO {
    private static final Logger logger = LoggerFactory.getLogger(AddressDAO.class);

    public List<Address> findByUserId(int userId) {
        List<Address> list = new ArrayList<>();
        String sql = "SELECT address_id, user_id, address_line, city, state, pincode, address_type, is_default, created_at FROM addresses WHERE user_id = ? ORDER BY is_default DESC, created_at DESC";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding addresses for user: {}", userId, e);
        }
        return list;
    }

    public Address findById(int addressId) {
        String sql = "SELECT address_id, user_id, address_line, city, state, pincode, address_type, is_default, created_at FROM addresses WHERE address_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addressId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding address by id: {}", addressId, e);
        }
        return null;
    }

    public boolean create(Address addr) {
        String sql = "INSERT INTO addresses (user_id, address_line, city, state, pincode, address_type, is_default) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, addr.getUserId());
            ps.setString(2, addr.getAddressLine());
            ps.setString(3, addr.getCity());
            ps.setString(4, addr.getState());
            ps.setString(5, addr.getPincode());
            ps.setString(6, addr.getAddressType() != null ? addr.getAddressType() : "HOME");
            ps.setBoolean(7, addr.isDefault());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        addr.setAddressId(keys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error creating address for user: {}", addr.getUserId(), e);
        }
        return false;
    }

    public boolean update(Address addr) {
        String sql = "UPDATE addresses SET address_line = ?, city = ?, state = ?, pincode = ?, address_type = ?, is_default = ? WHERE address_id = ? AND user_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, addr.getAddressLine());
            ps.setString(2, addr.getCity());
            ps.setString(3, addr.getState());
            ps.setString(4, addr.getPincode());
            ps.setString(5, addr.getAddressType());
            ps.setBoolean(6, addr.isDefault());
            ps.setInt(7, addr.getAddressId());
            ps.setInt(8, addr.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating address: {}", addr.getAddressId(), e);
        }
        return false;
    }

    public boolean delete(int addressId, int userId) {
        String sql = "DELETE FROM addresses WHERE address_id = ? AND user_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addressId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error deleting address: {}", addressId, e);
        }
        return false;
    }

    private Address mapRow(ResultSet rs) throws SQLException {
        Address a = new Address();
        a.setAddressId(rs.getInt("address_id"));
        a.setUserId(rs.getInt("user_id"));
        a.setAddressLine(rs.getString("address_line"));
        a.setCity(rs.getString("city"));
        a.setState(rs.getString("state"));
        a.setPincode(rs.getString("pincode"));
        a.setAddressType(rs.getString("address_type"));
        a.setDefault(rs.getBoolean("is_default"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        return a;
    }
}

