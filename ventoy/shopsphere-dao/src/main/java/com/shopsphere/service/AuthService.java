package com.shopsphere.service;

import com.shopsphere.common.model.User;
import com.shopsphere.common.util.PasswordHashUtil;
import com.shopsphere.dao.UserDAO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AuthService {
    private static final Logger logger = LoggerFactory.getLogger(AuthService.class);
    private final UserDAO userDAO = new UserDAO();

    public User authenticate(String email, String rawPassword) {
        if (email == null || rawPassword == null) {
            return null;
        }

        User user = userDAO.findByEmail(email);
        if (user == null) {
            logger.warn("Authentication failed: user not found with email {}", email);
            return null;
        }

        if (!"ACTIVE".equalsIgnoreCase(user.getStatus())) {
            logger.warn("Authentication failed: user account {} is {}", email, user.getStatus());
            return null;
        }

        if (PasswordHashUtil.verify(rawPassword, user.getPassword())) {
            logger.info("User {} successfully authenticated", email);
            return user;
        } else {
            logger.warn("Authentication failed: invalid password for user {}", email);
            return null;
        }
    }

    public boolean register(String name, String email, String rawPassword, String mobile) {
        if (email == null || rawPassword == null || name == null) {
            return false;
        }

        // Check if email already exists
        if (userDAO.findByEmail(email) != null) {
            logger.warn("Registration rejected: email {} already registered", email);
            return false;
        }

        String hashedPassword = PasswordHashUtil.hash(rawPassword);
        User user = new User();
        user.setName(name.trim());
        user.setEmail(email.trim().toLowerCase());
        user.setPassword(hashedPassword);
        user.setMobile(mobile != null ? mobile.trim() : "");
        user.setRole("CUSTOMER");
        user.setStatus("ACTIVE");

        return userDAO.create(user);
    }
}

