package com.shopsphere.dao;

import com.shopsphere.common.model.Category;
import com.shopsphere.dao.db.DBConnectionPool;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    private static final Logger logger = LoggerFactory.getLogger(CategoryDAO.class);

    public List<Category> findAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT category_id, name, slug, description, image_url, status, created_at FROM categories WHERE status = TRUE ORDER BY name ASC";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            logger.error("Error finding categories", e);
        }
        return list;
    }

    public List<Category> findAllIncludingInactive() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT category_id, name, slug, description, image_url, status, created_at FROM categories ORDER BY name ASC";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            logger.error("Error finding all categories", e);
        }
        return list;
    }

    public Category findById(int categoryId) {
        String sql = "SELECT category_id, name, slug, description, image_url, status, created_at FROM categories WHERE category_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding category by id: {}", categoryId, e);
        }
        return null;
    }

    public Category findBySlug(String slug) {
        String sql = "SELECT category_id, name, slug, description, image_url, status, created_at FROM categories WHERE slug = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding category by slug: {}", slug, e);
        }
        return null;
    }

    public boolean create(Category c) {
        String sql = "INSERT INTO categories (name, slug, description, image_url, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getSlug());
            ps.setString(3, c.getDescription());
            ps.setString(4, c.getImageUrl());
            ps.setBoolean(5, c.isStatus());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        c.setCategoryId(keys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error creating category: {}", c.getName(), e);
        }
        return false;
    }

    public boolean update(Category c) {
        String sql = "UPDATE categories SET name = ?, slug = ?, description = ?, image_url = ?, status = ? WHERE category_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getSlug());
            ps.setString(3, c.getDescription());
            ps.setString(4, c.getImageUrl());
            ps.setBoolean(5, c.isStatus());
            ps.setInt(6, c.getCategoryId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating category: {}", c.getCategoryId(), e);
        }
        return false;
    }

    public boolean delete(int categoryId) {
        String sql = "DELETE FROM categories WHERE category_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error deleting category: {}", categoryId, e);
        }
        return false;
    }

    public boolean toggleStatus(int categoryId) {
        String sql = "UPDATE categories SET status = NOT status WHERE category_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error toggling category status: {}", categoryId, e);
        }
        return false;
    }

    private Category mapRow(ResultSet rs) throws SQLException {
        Category c = new Category();
        c.setCategoryId(rs.getInt("category_id"));
        c.setName(rs.getString("name"));
        c.setSlug(rs.getString("slug"));
        c.setDescription(rs.getString("description"));
        c.setImageUrl(rs.getString("image_url"));
        c.setStatus(rs.getBoolean("status"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        return c;
    }
}

