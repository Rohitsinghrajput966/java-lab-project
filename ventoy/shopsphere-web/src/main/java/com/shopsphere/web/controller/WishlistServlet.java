package com.shopsphere.web.controller;

import com.shopsphere.common.model.User;
import com.shopsphere.common.model.WishlistItem;
import com.shopsphere.dao.WishlistDAO;
import com.shopsphere.service.CartService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "WishlistServlet", urlPatterns = {"/wishlist", "/wishlist/*"})
public class WishlistServlet extends HttpServlet {
    private final WishlistDAO wishlistDAO = new WishlistDAO();
    private final CartService cartService = new CartService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        List<WishlistItem> wishlist = wishlistDAO.getItemsByUserId(user.getUserId());
        request.setAttribute("wishlist", wishlist);
        request.getRequestDispatcher("/wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            if ("add".equalsIgnoreCase(action)) {
                wishlistDAO.addItem(user.getUserId(), productId);
                session.setAttribute("flashSuccess", "Item added to your wishlist!");
            } else if ("remove".equalsIgnoreCase(action)) {
                wishlistDAO.removeItem(user.getUserId(), productId);
                session.setAttribute("flashSuccess", "Item removed from your wishlist.");
            } else if ("moveToCart".equalsIgnoreCase(action)) {
                cartService.addToCart(user.getUserId(), productId, 1);
                wishlistDAO.removeItem(user.getUserId(), productId);
                session.setAttribute("cartCount", cartService.getCartItemCount(user.getUserId()));
                session.setAttribute("flashSuccess", "Item moved to your cart!");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
        } catch (Exception ignored) {}

        response.sendRedirect(request.getContextPath() + "/wishlist");
    }
}

