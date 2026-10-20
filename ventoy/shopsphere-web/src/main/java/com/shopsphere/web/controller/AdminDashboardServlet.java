package com.shopsphere.web.controller;

import com.shopsphere.common.model.Order;
import com.shopsphere.common.model.Product;
import com.shopsphere.dao.OrderDAO;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.dao.UserDAO;
import com.shopsphere.dao.db.DBConnectionPool;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.lang.management.ManagementFactory;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        double totalRevenue = orderDAO.getTotalRevenue();
        int totalOrders = orderDAO.countOrders();
        int totalCustomers = userDAO.countCustomers();
        int totalProducts = productDAO.countProducts();

        double avgOrderValue = totalOrders > 0 ? (totalRevenue / totalOrders) : 0.0;

        List<Product> lowStockProducts = productDAO.getLowStockProducts(15);
        List<Order> allOrders = orderDAO.findAll();
        
        List<Order> recentOrders = allOrders;
        if (recentOrders.size() > 6) {
            recentOrders = recentOrders.subList(0, 6);
        }

        // Status counts for visual breakdown
        Map<String, Integer> orderStatusCounts = new HashMap<>();
        orderStatusCounts.put("DELIVERED", 0);
        orderStatusCounts.put("CONFIRMED", 0);
        orderStatusCounts.put("SHIPPED", 0);
        orderStatusCounts.put("PENDING", 0);
        orderStatusCounts.put("CANCELLED", 0);

        for (Order o : allOrders) {
            String st = o.getOrderStatus();
            if (st != null) {
                orderStatusCounts.put(st.toUpperCase(), orderStatusCounts.getOrDefault(st.toUpperCase(), 0) + 1);
            }
        }

        // System telemetry
        Runtime runtime = Runtime.getRuntime();
        long maxMemory = runtime.maxMemory() / (1024 * 1024);
        long totalMemory = runtime.totalMemory() / (1024 * 1024);
        long freeMemory = runtime.freeMemory() / (1024 * 1024);
        long usedMemory = totalMemory - freeMemory;
        long uptimeMinutes = ManagementFactory.getRuntimeMXBean().getUptime() / (1000 * 60);

        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("avgOrderValue", avgOrderValue);
        request.setAttribute("lowStockProducts", lowStockProducts);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("orderStatusCounts", orderStatusCounts);
        request.setAttribute("usedMemory", usedMemory);
        request.setAttribute("maxMemory", maxMemory);
        request.setAttribute("uptimeMinutes", uptimeMinutes);
        request.setAttribute("isEmbeddedDB", DBConnectionPool.isEmbedded());

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}

