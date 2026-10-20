package com.shopsphere.service;

import com.shopsphere.common.model.Order;
import com.shopsphere.dao.OrderDAO;

import java.util.List;

public class OrderService {
    private final OrderDAO orderDAO = new OrderDAO();

    public List<Order> getOrdersForUser(int userId) {
        return orderDAO.findByUserId(userId);
    }

    public Order getOrderDetails(int orderId) {
        return orderDAO.findById(orderId);
    }

    public List<Order> getAllOrders() {
        return orderDAO.findAll();
    }

    public boolean updateStatus(int orderId, String newStatus) {
        return orderDAO.updateOrderStatus(orderId, newStatus);
    }

    public boolean updatePaymentStatus(int orderId, String paymentStatus) {
        return orderDAO.updatePaymentStatus(orderId, paymentStatus);
    }

    public boolean updateOrderAndPaymentStatus(int orderId, String orderStatus, String paymentStatus) {
        return orderDAO.updateOrderAndPaymentStatus(orderId, orderStatus, paymentStatus);
    }

    public List<Order> searchOrders(String query, String statusFilter, String paymentFilter) {
        return orderDAO.searchOrders(query, statusFilter, paymentFilter);
    }

    public int getTotalOrderCount() {
        return orderDAO.countOrders();
    }

    public double getTotalRevenue() {
        return orderDAO.getTotalRevenue();
    }
}

