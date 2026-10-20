package com.shopsphere.web.controller;

import com.shopsphere.common.model.Product;
import com.shopsphere.common.model.Review;
import com.shopsphere.dao.ReviewDAO;
import com.shopsphere.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "ProductDetailsServlet", urlPatterns = {"/product-details"})
public class ProductDetailsServlet extends HttpServlet {
    private final ProductService productService = new ProductService();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            int productId = Integer.parseInt(idParam.trim());
            Product product = productService.getProductById(productId);

            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }

            List<Review> reviews = reviewDAO.findByProductId(productId);
            request.setAttribute("product", product);
            request.setAttribute("reviews", reviews);

            // Handle Recently Viewed Cookie (RTU syllabus requirement)
            updateRecentlyViewedCookie(request, response, productId);

            // Related Products in same category
            List<Product> related = productService.getProductsByCategory(product.getCategoryId());
            related.removeIf(p -> p.getProductId() == productId);
            if (related.size() > 4) {
                related = related.subList(0, 4);
            }
            request.setAttribute("relatedProducts", related);

            request.getRequestDispatcher("/product-details.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }

    private void updateRecentlyViewedCookie(HttpServletRequest request, HttpServletResponse response, int currentProductId) {
        String cookieName = "shopsphere_recent";
        String existingVal = "";

        if (request.getCookies() != null) {
            for (Cookie c : request.getCookies()) {
                if (cookieName.equals(c.getName())) {
                    existingVal = c.getValue();
                    break;
                }
            }
        }

        List<String> ids = new ArrayList<>();
        if (!existingVal.isEmpty()) {
            ids.addAll(Arrays.asList(existingVal.split("-")));
        }

        String curIdStr = String.valueOf(currentProductId);
        ids.remove(curIdStr);
        ids.add(0, curIdStr);
        if (ids.size() > 5) {
            ids = ids.subList(0, 5);
        }

        String newVal = String.join("-", ids);
        Cookie recentCookie = new Cookie(cookieName, newVal);
        recentCookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
        recentCookie.setPath("/");
        recentCookie.setHttpOnly(true);
        response.addCookie(recentCookie);
    }
}

