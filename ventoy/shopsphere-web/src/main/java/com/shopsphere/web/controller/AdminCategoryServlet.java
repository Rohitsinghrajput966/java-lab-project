package com.shopsphere.web.controller;

import com.shopsphere.common.model.Category;
import com.shopsphere.dao.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCategoryServlet", urlPatterns = {
        "/admin/categories", "/admin/categories/add", "/admin/categories/edit",
        "/admin/categories/toggle", "/admin/categories/delete"
})
public class AdminCategoryServlet extends HttpServlet {
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.findAllIncludingInactive();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String servletPath = request.getServletPath();

        if ("/admin/categories/toggle".equals(servletPath)) {
            try {
                int id = Integer.parseInt(request.getParameter("categoryId"));
                categoryDAO.toggleStatus(id);
                session.setAttribute("flashSuccess", "Category visibility status toggled.");
            } catch (Exception e) {
                session.setAttribute("flashError", "Failed to update category status: " + e.getMessage());
            }
        } else if ("/admin/categories/edit".equals(servletPath)) {
            try {
                int id = Integer.parseInt(request.getParameter("categoryId"));
                Category cat = categoryDAO.findById(id);
                if (cat != null) {
                    cat.setName(request.getParameter("name"));
                    String slug = request.getParameter("slug");
                    if (slug == null || slug.trim().isEmpty()) {
                        slug = cat.getName().toLowerCase().replaceAll("[^a-z0-9]+", "-");
                    }
                    cat.setSlug(slug);
                    cat.setDescription(request.getParameter("description"));
                    cat.setImageUrl(request.getParameter("imageUrl"));
                    cat.setStatus(request.getParameter("status") != null);

                    categoryDAO.update(cat);
                    session.setAttribute("flashSuccess", "Category '" + cat.getName() + "' updated successfully.");
                }
            } catch (Exception e) {
                session.setAttribute("flashError", "Failed to update category: " + e.getMessage());
            }
        } else if ("/admin/categories/delete".equals(servletPath)) {
            try {
                int id = Integer.parseInt(request.getParameter("categoryId"));
                categoryDAO.delete(id);
                session.setAttribute("flashSuccess", "Category deleted successfully.");
            } catch (Exception e) {
                session.setAttribute("flashError", "Cannot delete category linked to existing products.");
            }
        } else {
            // Add new category
            try {
                String name = request.getParameter("name");
                String slug = request.getParameter("slug");
                String description = request.getParameter("description");
                String imageUrl = request.getParameter("imageUrl");

                if (slug == null || slug.trim().isEmpty()) {
                    slug = name.toLowerCase().replaceAll("[^a-z0-9]+", "-");
                }

                Category cat = new Category();
                cat.setName(name);
                cat.setSlug(slug);
                cat.setDescription(description);
                cat.setImageUrl(imageUrl);
                cat.setStatus(true);

                categoryDAO.create(cat);
                session.setAttribute("flashSuccess", "Category '" + name + "' created successfully.");
            } catch (Exception e) {
                session.setAttribute("flashError", "Failed to create category: " + e.getMessage());
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
}

