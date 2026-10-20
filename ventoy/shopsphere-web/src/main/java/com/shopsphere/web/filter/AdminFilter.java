package com.shopsphere.web.filter;

import com.shopsphere.common.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * Security filter enforcing role-based access control (RBAC).
 * Restricts all paths under /admin/* strictly to authenticated users with ADMIN role.
 */
@WebFilter(filterName = "AdminFilter", urlPatterns = {"/admin/*"})
public class AdminFilter implements Filter {
    private static final Logger logger = LoggerFactory.getLogger(AdminFilter.class);

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            logger.warn("Unauthorized anonymous attempt to access admin page: {}", httpRequest.getRequestURI());
            session = httpRequest.getSession(true);
            session.setAttribute("flashError", "Administrative privileges required. Please sign in as Admin.");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        if (!user.isAdmin()) {
            logger.warn("Forbidden attempt to access admin area by non-admin user: {}", user.getEmail());
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Administrator role required.");
            return;
        }

        chain.doFilter(request, response);
    }
}

