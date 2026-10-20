package com.shopsphere.web.controller;

import com.shopsphere.common.model.CartItem;
import com.shopsphere.common.model.User;
import com.shopsphere.service.CartService;
import com.shopsphere.service.CheckoutService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart", "/cart/*"})
public class CartServlet extends HttpServlet {
    private final CartService cartService = new CartService();
    private final CheckoutService checkoutService = new CheckoutService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        List<CartItem> cartItems = cartService.getCartItems(user.getUserId());
        String couponCode = (String) session.getAttribute("appliedCouponCode");

        CheckoutService.OrderPricing pricing = checkoutService.calculatePricing(cartItems, couponCode);

        // Synchronize cart item count in session
        session.setAttribute("cartCount", cartService.getCartItemCount(user.getUserId()));

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("pricing", pricing);
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");

        if (action == null && pathInfo != null) {
            action = pathInfo.replace("/", "");
        }

        if ("add".equalsIgnoreCase(action)) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = 1;
                String qParam = request.getParameter("quantity");
                if (qParam != null && !qParam.trim().isEmpty()) {
                    quantity = Integer.parseInt(qParam.trim());
                }
                cartService.addToCart(user.getUserId(), productId, quantity);
                session.setAttribute("flashSuccess", "Item added to your shopping cart!");
            } catch (Exception ignored) {}
        } else if ("update".equalsIgnoreCase(action)) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                cartService.updateCartQuantity(user.getUserId(), productId, quantity);
            } catch (Exception ignored) {}
        } else if ("remove".equalsIgnoreCase(action)) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                cartService.removeFromCart(user.getUserId(), productId);
                session.setAttribute("flashSuccess", "Item removed from your cart.");
            } catch (Exception ignored) {}
        } else if ("clear".equalsIgnoreCase(action)) {
            cartService.clearCart(user.getUserId());
            session.removeAttribute("appliedCouponCode");
            session.setAttribute("flashSuccess", "Shopping cart cleared.");
        } else if ("applyCoupon".equalsIgnoreCase(action)) {
            String code = request.getParameter("couponCode");
            if (code != null && !code.trim().isEmpty()) {
                List<CartItem> items = cartService.getCartItems(user.getUserId());
                CheckoutService.OrderPricing p = checkoutService.calculatePricing(items, code.trim());
                if (p.appliedCoupon != null) {
                    session.setAttribute("appliedCouponCode", code.trim().toUpperCase());
                    session.setAttribute("flashSuccess", "Coupon '" + code.trim().toUpperCase() + "' applied successfully!");
                } else {
                    session.setAttribute("flashError", "Invalid coupon code or minimum order requirements not met.");
                }
            }
        } else if ("removeCoupon".equalsIgnoreCase(action)) {
            session.removeAttribute("appliedCouponCode");
            session.setAttribute("flashSuccess", "Coupon removed.");
        }

        session.setAttribute("cartCount", cartService.getCartItemCount(user.getUserId()));
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}

