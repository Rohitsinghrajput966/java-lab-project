package com.shopsphere.web.controller;

import com.shopsphere.common.model.Address;
import com.shopsphere.common.model.User;
import com.shopsphere.common.util.PasswordHashUtil;
import com.shopsphere.dao.AddressDAO;
import com.shopsphere.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile", "/address/add", "/address/delete"})
public class ProfileServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final AddressDAO addressDAO = new AddressDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User sessionUser = (User) session.getAttribute("user");

        User user = userDAO.findById(sessionUser.getUserId());
        List<Address> addresses = addressDAO.findByUserId(user.getUserId());

        request.setAttribute("profileUser", user);
        request.setAttribute("addresses", addresses);
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String servletPath = request.getServletPath();

        if ("/address/add".equals(servletPath)) {
            String line = request.getParameter("addressLine");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String pincode = request.getParameter("pincode");
            String type = request.getParameter("addressType");

            Address address = new Address();
            address.setUserId(user.getUserId());
            address.setAddressLine(line != null ? line.trim() : "");
            address.setCity(city != null ? city.trim() : "");
            address.setState(state != null ? state.trim() : "");
            address.setPincode(pincode != null ? pincode.trim() : "");
            address.setAddressType(type != null ? type : "HOME");

            addressDAO.create(address);
            session.setAttribute("flashSuccess", "New address added.");
        } else if ("/address/delete".equals(servletPath)) {
            String idStr = request.getParameter("addressId");
            if (idStr != null) {
                try {
                    int addrId = Integer.parseInt(idStr);
                    addressDAO.delete(addrId, user.getUserId());
                    session.setAttribute("flashSuccess", "Address removed.");
                } catch (NumberFormatException ignored) {}
            }
        } else {
            // Profile update
            String name = request.getParameter("name");
            String mobile = request.getParameter("mobile");
            String newPassword = request.getParameter("newPassword");

            if (name != null && !name.trim().isEmpty()) {
                user.setName(name.trim());
                user.setMobile(mobile != null ? mobile.trim() : "");
                userDAO.update(user);
                session.setAttribute("user", user);
                session.setAttribute("flashSuccess", "Profile updated successfully.");
            }

            if (newPassword != null && !newPassword.trim().isEmpty()) {
                userDAO.updatePassword(user.getUserId(), PasswordHashUtil.hash(newPassword.trim()));
                session.setAttribute("flashSuccess", "Password updated successfully.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/profile");
    }
}

