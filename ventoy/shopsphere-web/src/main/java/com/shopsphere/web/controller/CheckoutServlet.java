package com.shopsphere.web.controller;

import com.shopsphere.common.model.*;
import com.shopsphere.dao.AddressDAO;
import com.shopsphere.dao.OrderDAO;
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

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout", "/checkout/place-order", "/order-success"})
public class CheckoutServlet extends HttpServlet {
    private final CartService cartService = new CartService();
    private final CheckoutService checkoutService = new CheckoutService();
    private final AddressDAO addressDAO = new AddressDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if ("/order-success".equals(servletPath)) {
            String orderIdParam = request.getParameter("orderId");
            if (orderIdParam != null) {
                try {
                    int orderId = Integer.parseInt(orderIdParam);
                    Order order = orderDAO.findById(orderId);
                    if (order != null && order.getUserId() == user.getUserId()) {
                        request.setAttribute("order", order);
                        request.getRequestDispatcher("/order-success.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        List<CartItem> cartItems = cartService.getCartItems(user.getUserId());
        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        List<Address> addresses = addressDAO.findByUserId(user.getUserId());
        String couponCode = (String) session.getAttribute("appliedCouponCode");
        CheckoutService.OrderPricing pricing = checkoutService.calculatePricing(cartItems, couponCode);

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("addresses", addresses);
        request.setAttribute("pricing", pricing);
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        String addressIdStr = request.getParameter("addressId");
        String paymentMethod = request.getParameter("paymentMethod");
        String couponCode = (String) session.getAttribute("appliedCouponCode");

        int addressId = 0;
        if ("new".equalsIgnoreCase(addressIdStr) || addressIdStr == null || addressIdStr.isEmpty()) {
            // Create address on the fly
            String line = request.getParameter("newAddressLine");
            String city = request.getParameter("newCity");
            String state = request.getParameter("newState");
            String pincode = request.getParameter("newPincode");
            String type = request.getParameter("newAddressType");

            Address newAddr = new Address();
            newAddr.setUserId(user.getUserId());
            newAddr.setAddressLine(line != null ? line.trim() : "Default Street");
            newAddr.setCity(city != null ? city.trim() : "City");
            newAddr.setState(state != null ? state.trim() : "State");
            newAddr.setPincode(pincode != null ? pincode.trim() : "000000");
            newAddr.setAddressType(type != null ? type : "HOME");
            newAddr.setDefault(true);

            addressDAO.create(newAddr);
            addressId = newAddr.getAddressId();
        } else {
            try {
                addressId = Integer.parseInt(addressIdStr);
            } catch (NumberFormatException e) {
                session.setAttribute("flashError", "Please select a valid shipping address.");
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            }
        }

        Order order = checkoutService.processCheckout(user.getUserId(), addressId, couponCode, paymentMethod);

        if (order != null) {
            session.removeAttribute("appliedCouponCode");
            session.setAttribute("cartCount", 0);
            session.setAttribute("flashSuccess", "Order placed successfully! Thank you for your purchase.");
            response.sendRedirect(request.getContextPath() + "/order-success?orderId=" + order.getOrderId());
        } else {
            session.setAttribute("flashError", "Unable to complete order. Please verify item stock or address details.");
            response.sendRedirect(request.getContextPath() + "/checkout");
        }
    }
}

