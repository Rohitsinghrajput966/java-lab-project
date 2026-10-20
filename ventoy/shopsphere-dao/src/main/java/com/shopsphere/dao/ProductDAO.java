package com.shopsphere.dao;

import com.shopsphere.common.model.Product;
import com.shopsphere.dao.db.DBConnectionPool;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    private static final Logger logger = LoggerFactory.getLogger(ProductDAO.class);

    public Product findById(int productId) {
        String sql = "SELECT p.product_id, p.category_id, c.name AS category_name, p.name, p.brand, p.description, " +
                     "p.price, p.discount, p.stock, p.image_url, p.status, p.created_at, " +
                     "COALESCE(AVG(r.rating), 5.0) AS avg_rating, COUNT(r.review_id) AS review_count " +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "LEFT JOIN reviews r ON p.product_id = r.product_id " +
                     "WHERE p.product_id = ? " +
                     "GROUP BY p.product_id, p.category_id, c.name, p.name, p.brand, p.description, p.price, p.discount, p.stock, p.image_url, p.status, p.created_at";

        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding product by id: {}", productId, e);
        }
        return null;
    }

    public List<Product> findAll(boolean activeOnly) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.product_id, p.category_id, c.name AS category_name, p.name, p.brand, p.description, " +
                     "p.price, p.discount, p.stock, p.image_url, p.status, p.created_at, " +
                     "COALESCE(AVG(r.rating), 5.0) AS avg_rating, COUNT(r.review_id) AS review_count " +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "LEFT JOIN reviews r ON p.product_id = r.product_id " +
                     (activeOnly ? "WHERE p.status = TRUE " : "") +
                     "GROUP BY p.product_id, p.category_id, c.name, p.name, p.brand, p.description, p.price, p.discount, p.stock, p.image_url, p.status, p.created_at " +
                     "ORDER BY p.created_at DESC";

        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            logger.error("Error listing products", e);
        }
        return list;
    }

    public List<Product> findByCategory(int categoryId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.product_id, p.category_id, c.name AS category_name, p.name, p.brand, p.description, " +
                     "p.price, p.discount, p.stock, p.image_url, p.status, p.created_at, " +
                     "COALESCE(AVG(r.rating), 5.0) AS avg_rating, COUNT(r.review_id) AS review_count " +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "LEFT JOIN reviews r ON p.product_id = r.product_id " +
                     "WHERE p.category_id = ? AND p.status = TRUE " +
                     "GROUP BY p.product_id, p.category_id, c.name, p.name, p.brand, p.description, p.price, p.discount, p.stock, p.image_url, p.status, p.created_at " +
                     "ORDER BY p.created_at DESC";

        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding products by category: {}", categoryId, e);
        }
        return list;
    }

    public List<Product> searchAndFilter(String query, Integer categoryId, Double minPrice, Double maxPrice, String sortBy) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT p.product_id, p.category_id, c.name AS category_name, p.name, p.brand, p.description, ");
        sql.append("p.price, p.discount, p.stock, p.image_url, p.status, p.created_at, ");
        sql.append("COALESCE(AVG(r.rating), 5.0) AS avg_rating, COUNT(r.review_id) AS review_count ");
        sql.append("FROM products p ");
        sql.append("LEFT JOIN categories c ON p.category_id = c.category_id ");
        sql.append("LEFT JOIN reviews r ON p.product_id = r.product_id ");
        sql.append("WHERE p.status = TRUE ");

        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            sql.append("AND (LOWER(p.name) LIKE ? OR LOWER(p.brand) LIKE ? OR LOWER(p.description) LIKE ?) ");
            String likePattern = "%" + query.trim().toLowerCase() + "%";
            params.add(likePattern);
            params.add(likePattern);
            params.add(likePattern);
        }

        if (categoryId != null && categoryId > 0) {
            sql.append("AND p.category_id = ? ");
            params.add(categoryId);
        }

        if (minPrice != null && minPrice >= 0) {
            sql.append("AND p.price >= ? ");
            params.add(minPrice);
        }

        if (maxPrice != null && maxPrice > 0) {
            sql.append("AND p.price <= ? ");
            params.add(maxPrice);
        }

        sql.append("GROUP BY p.product_id, p.category_id, c.name, p.name, p.brand, p.description, p.price, p.discount, p.stock, p.image_url, p.status, p.created_at ");

        if ("price_asc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY p.price ASC");
        } else if ("price_desc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY p.price DESC");
        } else if ("discount".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY p.discount DESC");
        } else {
            sql.append("ORDER BY p.created_at DESC");
        }

        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error searching products with query: {}", query, e);
        }
        return list;
    }

    public boolean create(Product p) {
        String sql = "INSERT INTO products (category_id, name, brand, description, price, discount, stock, image_url, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, p.getCategoryId());
            ps.setString(2, p.getName());
            ps.setString(3, p.getBrand());
            ps.setString(4, p.getDescription());
            ps.setDouble(5, p.getPrice());
            ps.setDouble(6, p.getDiscount());
            ps.setInt(7, p.getStock());
            ps.setString(8, p.getImageUrl());
            ps.setBoolean(9, p.isStatus());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        p.setProductId(keys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error creating product: {}", p.getName(), e);
        }
        return false;
    }

    public boolean update(Product p) {
        String sql = "UPDATE products SET category_id = ?, name = ?, brand = ?, description = ?, " +
                     "price = ?, discount = ?, stock = ?, image_url = ?, status = ? WHERE product_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setString(2, p.getName());
            ps.setString(3, p.getBrand());
            ps.setString(4, p.getDescription());
            ps.setDouble(5, p.getPrice());
            ps.setDouble(6, p.getDiscount());
            ps.setInt(7, p.getStock());
            ps.setString(8, p.getImageUrl());
            ps.setBoolean(9, p.isStatus());
            ps.setInt(10, p.getProductId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating product: {}", p.getProductId(), e);
        }
        return false;
    }

    public boolean updateStock(int productId, int quantityDelta) {
        // Safe atomic stock update ensuring stock does not drop below zero
        String sql = "UPDATE products SET stock = stock + ? WHERE product_id = ? AND (stock + ?) >= 0";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantityDelta);
            ps.setInt(2, productId);
            ps.setInt(3, quantityDelta);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating stock for product: {}", productId, e);
        }
        return false;
    }

    public boolean setStock(int productId, int exactStock) {
        String sql = "UPDATE products SET stock = ? WHERE product_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, Math.max(0, exactStock));
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error setting stock for product: {}", productId, e);
        }
        return false;
    }

    public boolean delete(int productId) {
        String sql = "DELETE FROM products WHERE product_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error deleting product: {}", productId, e);
        }
        return false;
    }

    public int countProducts() {
        String sql = "SELECT COUNT(*) FROM products";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            logger.error("Error counting products", e);
        }
        return 0;
    }

    public List<Product> getLowStockProducts(int threshold) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.product_id, p.category_id, c.name AS category_name, p.name, p.brand, p.description, " +
                     "p.price, p.discount, p.stock, p.image_url, p.status, p.created_at, 5.0 AS avg_rating, 0 AS review_count " +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "WHERE p.stock <= ? ORDER BY p.stock ASC";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, threshold);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding low stock products", e);
        }
        return list;
    }

    public boolean toggleStatus(int productId) {
        String sql = "UPDATE products SET status = NOT status WHERE product_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error toggling product status: {}", productId, e);
        }
        return false;
    }

    public List<Product> searchForAdmin(String query, Integer categoryId, String stockFilter) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT p.product_id, p.category_id, c.name AS category_name, p.name, p.brand, p.description, ")
           .append("p.price, p.discount, p.stock, p.image_url, p.status, p.created_at, ")
           .append("COALESCE(AVG(r.rating), 5.0) AS avg_rating, COUNT(r.review_id) AS review_count ")
           .append("FROM products p ")
           .append("LEFT JOIN categories c ON p.category_id = c.category_id ")
           .append("LEFT JOIN reviews r ON p.product_id = r.product_id ")
           .append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            sql.append("AND (LOWER(p.name) LIKE ? OR LOWER(p.brand) LIKE ?) ");
            String pat = "%" + query.trim().toLowerCase() + "%";
            params.add(pat);
            params.add(pat);
        }

        if (categoryId != null && categoryId > 0) {
            sql.append("AND p.category_id = ? ");
            params.add(categoryId);
        }

        if ("out".equalsIgnoreCase(stockFilter)) {
            sql.append("AND p.stock <= 0 ");
        } else if ("low".equalsIgnoreCase(stockFilter)) {
            sql.append("AND p.stock > 0 AND p.stock <= 10 ");
        } else if ("in".equalsIgnoreCase(stockFilter)) {
            sql.append("AND p.stock > 10 ");
        }

        sql.append("GROUP BY p.product_id, p.category_id, c.name, p.name, p.brand, p.description, p.price, p.discount, p.stock, p.image_url, p.status, p.created_at ")
           .append("ORDER BY p.product_id DESC");

        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error searching products for admin", e);
        }
        return list;
    }

    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductId(rs.getInt("product_id"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setCategoryName(rs.getString("category_name"));
        p.setName(rs.getString("name"));
        p.setBrand(rs.getString("brand"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getDouble("price"));
        p.setDiscount(rs.getDouble("discount"));
        p.setStock(rs.getInt("stock"));
        p.setImageUrl(rs.getString("image_url"));
        p.setStatus(rs.getBoolean("status"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setRating(Math.round(rs.getDouble("avg_rating") * 10.0) / 10.0);
        p.setReviewCount(rs.getInt("review_count"));
        return p;
    }
}

