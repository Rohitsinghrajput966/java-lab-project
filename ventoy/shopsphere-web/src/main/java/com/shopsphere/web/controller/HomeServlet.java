package com.shopsphere.web.controller;

import com.shopsphere.common.model.Category;
import com.shopsphere.common.model.Product;
import com.shopsphere.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller for shopsphere Women's & Girls' Fashion Storefront.
 * Prepares curated collections: Ethnic Wear, Western Dresses, Accessories, and New Arrivals.
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"", "/home", "/index"})
public class HomeServlet extends HttpServlet {
    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = productService.getActiveCategories();
        List<Product> allProducts = productService.getAllActiveProducts();

        // 1. Flagship Tech & Computing (Smartphones & Laptops: Cat 1, 2)
        List<Product> techProducts = allProducts.stream()
                .filter(p -> p.getCategoryId() == 1 || p.getCategoryId() == 2)
                .limit(4)
                .toList();

        // 2. Trending Men's & Women's Fashion & Footwear (Cat 5, 6, 7)
        List<Product> fashionProducts = allProducts.stream()
                .filter(p -> p.getCategoryId() == 5 || p.getCategoryId() == 6 || p.getCategoryId() == 7)
                .limit(4)
                .toList();

        // 3. Audio, Wearables & Gadgets (Cat 3, 4, 9)
        List<Product> audioProducts = allProducts.stream()
                .filter(p -> p.getCategoryId() == 3 || p.getCategoryId() == 4 || p.getCategoryId() == 9)
                .limit(4)
                .toList();

        // 4. Smart Home & Kitchen Appliances (Cat 8)
        List<Product> homeLivingProducts = allProducts.stream()
                .filter(p -> p.getCategoryId() == 8)
                .limit(4)
                .toList();

        // 5. New Season Arrivals (latest products)
        List<Product> newArrivals = allProducts.stream()
                .sorted((p1, p2) -> Integer.compare(p2.getProductId(), p1.getProductId()))
                .limit(4)
                .toList();

        // 6. Featured Trending Deals
        List<Product> featuredProducts = allProducts.stream().limit(8).toList();

        // Attributes with backward-compatible aliases
        request.setAttribute("categories", categories);
        request.setAttribute("techProducts", techProducts);
        request.setAttribute("fashionProducts", fashionProducts);
        request.setAttribute("audioProducts", audioProducts);
        request.setAttribute("homeLivingProducts", homeLivingProducts);
        request.setAttribute("ethnicProducts", techProducts);       // fallback alias
        request.setAttribute("westernProducts", fashionProducts);   // fallback alias
        request.setAttribute("accessoryProducts", audioProducts);   // fallback alias
        request.setAttribute("newArrivals", newArrivals);
        request.setAttribute("featuredProducts", featuredProducts);
        request.setAttribute("totalProductCount", allProducts.size());

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}

