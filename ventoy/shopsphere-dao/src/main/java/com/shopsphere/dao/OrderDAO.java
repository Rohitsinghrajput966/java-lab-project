package com.shopsphere.dao;

import com.shopsphere.common.model.*;
import com.shopsphere.dao.db.DBConnectionPool;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    private static final Logger logger = LoggerFactory.getLogger(OrderDAO.class);
    private final OrderItemDAO orderItemDAO = new OrderItemDAO();
    private final AddressDAO addressDAO = new AddressDAO();

    /**
     * Executes atomic, transactional order placement across orders, order_items, payments, stock, and cart.
     */
    public boolean placeOrderTransaction(Order order, List<CartItem> cartItems, Payment payment, Integer couponId) {
        String insertOrderSql = "INSERT INTO orders (user_id, address_id, total_amount, discount, shipping_fee, final_amount, " +
                               "payment_method, payment_status, order_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String updateStockSql = "UPDATE products SET stock = stock - ? WHERE product_id = ? AND stock >= ?";
        String insertPaymentSql = "INSERT INTO payments (order_id, payment_method, transaction_reference, amount, payment_status) VALUES (?, ?, ?, ?, ?)";
        String insertCouponUsageSql = "INSERT INTO coupon_usage (coupon_id, user_id, order_id) VALUES (?, ?, ?)";
        String clearCartSql = "DELETE FROM cart WHERE user_id = ?";

        Connection conn = null;
        try {
            conn = DBConnectionPool.getConnection();
            conn.setAutoCommit(false); // Begin ACID Transaction

            // 1. Insert Order
            try (PreparedStatement psOrder = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, order.getUserId());
                psOrder.setInt(2, order.getAddressId());
                psOrder.setDouble(3, order.getTotalAmount());
                psOrder.setDouble(4, order.getDiscount());
                psOrder.setDouble(5, order.getShippingFee());
                psOrder.setDouble(6, order.getFinalAmount());
                psOrder.setString(7, order.getPaymentMethod());
                psOrder.setString(8, order.getPaymentStatus());
                psOrder.setString(9, order.getOrderStatus() != null ? order.getOrderStatus() : "CONFIRMED");

                int affected = psOrder.executeUpdate();
                if (affected == 0) {
                    conn.rollback();
                    return false;
                }
                try (ResultSet keys = psOrder.getGeneratedKeys()) {
                    if (keys.next()) {
                        order.setOrderId(keys.getInt(1));
                    }
                }
            }

            // 2. Insert Order Items & Update Stock atomically
            for (CartItem item : cartItems) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderId(order.getOrderId());
                orderItem.setProductId(item.getProductId());
                orderItem.setQuantity(item.getQuantity());
                orderItem.setPrice(item.getProduct() != null ? item.getProduct().getDiscountedPrice() : 0.0);

                orderItemDAO.create(orderItem, conn);

                // Atomic stock decrement
                try (PreparedStatement psStock = conn.prepareStatement(updateStockSql)) {
                    psStock.setInt(1, item.getQuantity());
                    psStock.setInt(2, item.getProductId());
                    psStock.setInt(3, item.getQuantity());
                    int stockUpdated = psStock.executeUpdate();
                    if (stockUpdated == 0) {
                        logger.warn("Insufficient stock for product id {}", item.getProductId());
                        conn.rollback();
                        return false;
                    }
                }
            }

            // 3. Record Payment
            if (payment != null) {
                payment.setOrderId(order.getOrderId());
                try (PreparedStatement psPay = conn.prepareStatement(insertPaymentSql, Statement.RETURN_GENERATED_KEYS)) {
                    psPay.setInt(1, payment.getOrderId());
                    psPay.setString(2, payment.getPaymentMethod());
                    psPay.setString(3, payment.getTransactionReference());
                    psPay.setDouble(4, payment.getAmount());
                    psPay.setString(5, payment.getPaymentStatus());
                    psPay.executeUpdate();
                }
            }

            // 4. Record Coupon Usage (if coupon applied)
            if (couponId != null && couponId > 0) {
                try (PreparedStatement psCoupon = conn.prepareStatement(insertCouponUsageSql)) {
                    psCoupon.setInt(1, couponId);
                    psCoupon.setInt(2, order.getUserId());
                    psCoupon.setInt(3, order.getOrderId());
                    psCoupon.executeUpdate();
                }
            }

            // 5. Clear User's Cart
            try (PreparedStatement psCart = conn.prepareStatement(clearCartSql)) {
                psCart.setInt(1, order.getUserId());
                psCart.executeUpdate();
            }

            conn.commit(); // Transaction successful
            return true;
        } catch (Exception e) {
            logger.error("Transaction failed during order placement, rolling back", e);
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback error", ex); }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    logger.error("Connection close error", ex);
                }
            }
        }
    }

    public Order findById(int orderId) {
        String sql = "SELECT o.order_id, o.user_id, u.name AS user_name, u.email AS user_email, " +
                     "o.address_id, o.total_amount, o.discount, o.shipping_fee, o.final_amount, " +
                     "o.payment_method, o.payment_status, o.order_status, o.created_at, o.updated_at " +
                     "FROM orders o " +
                     "JOIN users u ON o.user_id = u.user_id " +
                     "WHERE o.order_id = ?";

        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapRow(rs);
                    order.setAddress(addressDAO.findById(order.getAddressId()));
                    order.setItems(orderItemDAO.findByOrderId(orderId));
                    return order;
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding order by id: {}", orderId, e);
        }
        return null;
    }

    public List<Order> findByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.order_id, o.user_id, u.name AS user_name, u.email AS user_email, " +
                     "o.address_id, o.total_amount, o.discount, o.shipping_fee, o.final_amount, " +
                     "o.payment_method, o.payment_status, o.order_status, o.created_at, o.updated_at " +
                     "FROM orders o " +
                     "JOIN users u ON o.user_id = u.user_id " +
                     "WHERE o.user_id = ? ORDER BY o.created_at DESC";

        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = mapRow(rs);
                    order.setAddress(addressDAO.findById(order.getAddressId()));
                    order.setItems(orderItemDAO.findByOrderId(order.getOrderId()));
                    list.add(order);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding orders for user: {}", userId, e);
        }
        return list;
    }

    public List<Order> findAll() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.order_id, o.user_id, u.name AS user_name, u.email AS user_email, " +
                     "o.address_id, o.total_amount, o.discount, o.shipping_fee, o.final_amount, " +
                     "o.payment_method, o.payment_status, o.order_status, o.created_at, o.updated_at " +
                     "FROM orders o " +
                     "JOIN users u ON o.user_id = u.user_id ORDER BY o.created_at DESC";

        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order order = mapRow(rs);
                order.setItems(orderItemDAO.findByOrderId(order.getOrderId()));
                list.add(order);
            }
        } catch (SQLException e) {
            logger.error("Error finding all orders", e);
        }
        return list;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET order_status = ? WHERE order_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating status for order: {}", orderId, e);
        }
        return false;
    }

    public boolean updatePaymentStatus(int orderId, String paymentStatus) {
        String sql = "UPDATE orders SET payment_status = ? WHERE order_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, paymentStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating payment status for order: {}", orderId, e);
        }
        return false;
    }

    public int countOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            logger.error("Error counting orders", e);
        }
        return 0;
    }

    public double getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(final_amount), 0.0) FROM orders WHERE payment_status = 'PAID'";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return Math.round(rs.getDouble(1) * 100.0) / 100.0;
        } catch (SQLException e) {
            logger.error("Error calculating total revenue", e);
        }
        return 0.0;
    }

    public boolean updateOrderAndPaymentStatus(int orderId, String orderStatus, String paymentStatus) {
        String sql = "UPDATE orders SET order_status = ?, payment_status = ?, updated_at = CURRENT_TIMESTAMP WHERE order_id = ?";
        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderStatus);
            ps.setString(2, paymentStatus);
            ps.setInt(3, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating order and payment status for order: {}", orderId, e);
        }
        return false;
    }

    public List<Order> searchOrders(String query, String statusFilter, String paymentFilter) {
        List<Order> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT o.order_id, o.user_id, u.name AS user_name, u.email AS user_email, ")
           .append("o.address_id, o.total_amount, o.discount, o.shipping_fee, o.final_amount, ")
           .append("o.payment_method, o.payment_status, o.order_status, o.created_at, o.updated_at ")
           .append("FROM orders o ")
           .append("JOIN users u ON o.user_id = u.user_id ")
           .append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            String q = query.trim();
            try {
                int oid = Integer.parseInt(q.replace("#SPH-", "").replace("#", ""));
                sql.append("AND (o.order_id = ? OR LOWER(u.name) LIKE ? OR LOWER(u.email) LIKE ?) ");
                params.add(oid);
                params.add("%" + q.toLowerCase() + "%");
                params.add("%" + q.toLowerCase() + "%");
            } catch (NumberFormatException nfe) {
                sql.append("AND (LOWER(u.name) LIKE ? OR LOWER(u.email) LIKE ?) ");
                params.add("%" + q.toLowerCase() + "%");
                params.add("%" + q.toLowerCase() + "%");
            }
        }

        if (statusFilter != null && !statusFilter.isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            sql.append("AND o.order_status = ? ");
            params.add(statusFilter.toUpperCase());
        }

        if (paymentFilter != null && !paymentFilter.isEmpty() && !"ALL".equalsIgnoreCase(paymentFilter)) {
            sql.append("AND o.payment_status = ? ");
            params.add(paymentFilter.toUpperCase());
        }

        sql.append("ORDER BY o.created_at DESC");

        try (Connection conn = DBConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = mapRow(rs);
                    order.setItems(orderItemDAO.findByOrderId(order.getOrderId()));
                    list.add(order);
                }
            }
        } catch (SQLException e) {
            logger.error("Error searching orders", e);
        }
        return list;
    }

    private Order mapRow(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setUserId(rs.getInt("user_id"));
        o.setUserName(rs.getString("user_name"));
        o.setUserEmail(rs.getString("user_email"));
        o.setAddressId(rs.getInt("address_id"));
        o.setTotalAmount(rs.getDouble("total_amount"));
        o.setDiscount(rs.getDouble("discount"));
        o.setShippingFee(rs.getDouble("shipping_fee"));
        o.setFinalAmount(rs.getDouble("final_amount"));
        o.setPaymentMethod(rs.getString("payment_method"));
        o.setPaymentStatus(rs.getString("payment_status"));
        o.setOrderStatus(rs.getString("order_status"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        o.setUpdatedAt(rs.getTimestamp("updated_at"));
        return o;
    }
}

