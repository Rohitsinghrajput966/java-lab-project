package com.shopsphere.web.controller;

import com.shopsphere.common.model.Order;
import com.shopsphere.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminOrderServlet", urlPatterns = {
        "/admin/orders", "/admin/orders/update-status", "/admin/orders/update-payment"
})
public class AdminOrderServlet extends HttpServlet {
    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("q");
        String statusFilter = request.getParameter("status");
        String paymentFilter = request.getParameter("payment");

        List<Order> orders = orderService.searchOrders(query, statusFilter, paymentFilter);

        request.setAttribute("orders", orders);
        request.setAttribute("searchQuery", query);
        request.setAttribute("selectedStatus", statusFilter);
        request.setAttribute("selectedPayment", paymentFilter);

        request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String servletPath = request.getServletPath();

        if ("/admin/orders/update-payment".equals(servletPath)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String paymentStatus = request.getParameter("paymentStatus");
                orderService.updatePaymentStatus(orderId, paymentStatus);
                session.setAttribute("flashSuccess", "Payment status for Order #SPH-" + orderId + " updated to " + paymentStatus);
            } catch (Exception e) {
                session.setAttribute("flashError", "Failed to update payment status: " + e.getMessage());
            }
        } else {
            // Update order status or both
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String newStatus = request.getParameter("orderStatus");
                String paymentStatus = request.getParameter("paymentStatus");

                if (paymentStatus != null && !paymentStatus.trim().isEmpty()) {
                    orderService.updateOrderAndPaymentStatus(orderId, newStatus, paymentStatus);
                    session.setAttribute("flashSuccess", "Order #SPH-" + orderId + " status updated to " + newStatus + " (Payment: " + paymentStatus + ")");
                } else {
                    orderService.updateStatus(orderId, newStatus);
                    session.setAttribute("flashSuccess", "Order #SPH-" + orderId + " status updated to " + newStatus);
                }
            } catch (Exception e) {
                session.setAttribute("flashError", "Failed to update order status: " + e.getMessage());
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}

