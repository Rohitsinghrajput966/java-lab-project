package com.shopsphere.web.controller;

import com.shopsphere.common.model.User;
import com.shopsphere.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCustomerServlet", urlPatterns = {
        "/admin/customers", "/admin/customers/status", "/admin/customers/role"
})
public class AdminCustomerServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("q");
        String roleFilter = request.getParameter("role");
        String statusFilter = request.getParameter("status");

        List<User> customers = userDAO.searchUsers(query, roleFilter, statusFilter);

        request.setAttribute("customers", customers);
        request.setAttribute("searchQuery", query);
        request.setAttribute("selectedRole", roleFilter);
        request.setAttribute("selectedStatus", statusFilter);

        request.getRequestDispatcher("/admin/customers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String servletPath = request.getServletPath();

        if ("/admin/customers/status".equals(servletPath)) {
            try {
                int userId = Integer.parseInt(request.getParameter("userId"));
                String currentStatus = request.getParameter("currentStatus");
                String newStatus = "ACTIVE".equalsIgnoreCase(currentStatus) ? "SUSPENDED" : "ACTIVE";

                userDAO.updateStatus(userId, newStatus);
                session.setAttribute("flashSuccess", "User account status updated to " + newStatus);
            } catch (Exception e) {
                session.setAttribute("flashError", "Failed to update account status: " + e.getMessage());
            }
        } else if ("/admin/customers/role".equals(servletPath)) {
            try {
                int userId = Integer.parseInt(request.getParameter("userId"));
                String currentRole = request.getParameter("currentRole");
                String newRole = "ADMIN".equalsIgnoreCase(currentRole) ? "CUSTOMER" : "ADMIN";

                userDAO.updateRole(userId, newRole);
                session.setAttribute("flashSuccess", "User role permission updated to " + newRole);
            } catch (Exception e) {
                session.setAttribute("flashError", "Failed to update user role: " + e.getMessage());
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/customers");
    }
}

