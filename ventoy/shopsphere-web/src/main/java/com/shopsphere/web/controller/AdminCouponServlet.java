package com.shopsphere.web.controller;

import com.shopsphere.common.model.Coupon;
import com.shopsphere.dao.CouponDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "AdminCouponServlet", urlPatterns = {
        "/admin/coupons", "/admin/coupons/add", "/admin/coupons/edit",
        "/admin/coupons/toggle", "/admin/coupons/delete"
})
public class AdminCouponServlet extends HttpServlet {
    private final CouponDAO couponDAO = new CouponDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("q");
        List<Coupon> coupons = couponDAO.searchCoupons(query);

        request.setAttribute("coupons", coupons);
        request.setAttribute("searchQuery", query);
        request.getRequestDispatcher("/admin/coupons.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String servletPath = request.getServletPath();

        if ("/admin/coupons/toggle".equals(servletPath)) {
            try {
                int id = Integer.parseInt(request.getParameter("couponId"));
                boolean current = Boolean.parseBoolean(request.getParameter("status"));
                couponDAO.updateStatus(id, !current);
                session.setAttribute("flashSuccess", "Coupon status updated.");
            } catch (Exception e) {
                session.setAttribute("flashError", "Failed to toggle coupon status: " + e.getMessage());
            }
        } else if ("/admin/coupons/delete".equals(servletPath)) {
            try {
                int id = Integer.parseInt(request.getParameter("couponId"));
                couponDAO.delete(id);
                session.setAttribute("flashSuccess", "Coupon deleted successfully.");
            } catch (Exception e) {
                session.setAttribute("flashError", "Failed to delete coupon: " + e.getMessage());
            }
        } else if ("/admin/coupons/edit".equals(servletPath)) {
            try {
                int id = Integer.parseInt(request.getParameter("couponId"));
                String code = request.getParameter("code");
                String type = request.getParameter("discountType");
                double val = Double.parseDouble(request.getParameter("discountValue"));
                double minOrder = Double.parseDouble(request.getParameter("minimumOrder"));
                String maxDiscStr = request.getParameter("maximumDiscount");
                Double maxDisc = (maxDiscStr != null && !maxDiscStr.trim().isEmpty()) ? Double.parseDouble(maxDiscStr.trim()) : null;

                Coupon c = new Coupon();
                c.setCouponId(id);
                c.setCode(code);
                c.setDiscountType(type);
                c.setDiscountValue(val);
                c.setMinimumOrder(minOrder);
                c.setMaximumDiscount(maxDisc);
                c.setExpiryDate(Timestamp.valueOf(LocalDateTime.now().plusMonths(6)));
                c.setStatus(request.getParameter("status") != null);

                couponDAO.update(c);
                session.setAttribute("flashSuccess", "Coupon '" + code + "' updated successfully.");
            } catch (Exception e) {
                session.setAttribute("flashError", "Failed to update coupon: " + e.getMessage());
            }
        } else {
            // Add new coupon
            try {
                String code = request.getParameter("code");
                String type = request.getParameter("discountType");
                double val = Double.parseDouble(request.getParameter("discountValue"));
                double minOrder = Double.parseDouble(request.getParameter("minimumOrder"));
                String maxDiscStr = request.getParameter("maximumDiscount");
                Double maxDisc = (maxDiscStr != null && !maxDiscStr.trim().isEmpty()) ? Double.parseDouble(maxDiscStr.trim()) : null;

                Coupon c = new Coupon();
                c.setCode(code);
                c.setDiscountType(type);
                c.setDiscountValue(val);
                c.setMinimumOrder(minOrder);
                c.setMaximumDiscount(maxDisc);
                c.setExpiryDate(Timestamp.valueOf(LocalDateTime.now().plusMonths(6)));
                c.setStatus(true);

                couponDAO.create(c);
                session.setAttribute("flashSuccess", "Coupon code '" + code + "' created successfully.");
            } catch (Exception e) {
                session.setAttribute("flashError", "Failed to create coupon: " + e.getMessage());
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/coupons");
    }
}

