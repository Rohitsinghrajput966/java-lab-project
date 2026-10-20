package com.shopsphere.web.controller;

import com.shopsphere.common.model.Review;
import com.shopsphere.common.model.User;
import com.shopsphere.dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ReviewServlet", urlPatterns = {"/review/add"})
public class ReviewServlet extends HttpServlet {
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        String productIdStr = request.getParameter("productId");
        String ratingStr = request.getParameter("rating");
        String reviewText = request.getParameter("reviewText");

        if (productIdStr != null && ratingStr != null) {
            try {
                int productId = Integer.parseInt(productIdStr);
                int rating = Integer.parseInt(ratingStr);

                Review review = new Review();
                review.setUserId(user.getUserId());
                review.setProductId(productId);
                review.setRating(rating);
                review.setReviewText(reviewText != null ? reviewText.trim() : "");

                reviewDAO.addReview(review);
                session.setAttribute("flashSuccess", "Thank you for your review!");
                response.sendRedirect(request.getContextPath() + "/product-details?id=" + productId);
                return;
            } catch (NumberFormatException ignored) {}
        }

        response.sendRedirect(request.getContextPath() + "/products");
    }
}

