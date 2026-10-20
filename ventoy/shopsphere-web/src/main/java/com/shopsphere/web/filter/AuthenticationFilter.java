package com.shopsphere.web.filter;

import com.shopsphere.common.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Authentication filter protecting customer-specific endpoints (cart, checkout, orders, profile, wishlist).
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {
        "/cart/*", "/checkout/*", "/orders/*", "/order-details/*", "/profile/*", "/wishlist/*", "/review/add/*"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            String requestURI = httpRequest.getRequestURI();
            String queryString = httpRequest.getQueryString();
            String redirectUrl = (queryString == null) ? requestURI : requestURI + "?" + queryString;

            session = httpRequest.getSession(true);
            session.setAttribute("redirectUrl", redirectUrl);
            session.setAttribute("flashError", "Please sign in to access this page.");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        chain.doFilter(request, response);
    }
}

