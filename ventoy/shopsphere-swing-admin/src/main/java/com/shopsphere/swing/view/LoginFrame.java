package com.shopsphere.swing.view;

import com.shopsphere.common.model.User;
import com.shopsphere.service.AuthService;

import javax.swing.*;
import java.awt.*;

/**
 * Swing View: Desktop Administrator Authentication Window.
 */
public class LoginFrame extends JFrame {
    private final JTextField emailField = new JTextField("admin@shopsphere.com", 20);
    private final JPasswordField passwordField = new JPasswordField("Admin@123", 20);
    private final JLabel statusLabel = new JLabel(" ", SwingConstants.CENTER);
    private final AuthService authService = new AuthService();

    public LoginFrame() {
        initUI();
    }

    private void initUI() {
        setTitle("shopsphere Desktop Admin - Login");
        setSize(420, 320);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setResizable(false);

        JPanel mainPanel = new JPanel(new BorderLayout(10, 10));
        mainPanel.setBorder(BorderFactory.createEmptyBorder(25, 25, 25, 25));
        mainPanel.setBackground(Color.WHITE);

        // Header
        JPanel headerPanel = new JPanel(new GridLayout(2, 1));
        headerPanel.setBackground(Color.WHITE);
        JLabel titleLabel = new JLabel("shopsphere Admin", SwingConstants.CENTER);
        titleLabel.setFont(new Font("SansSerif", Font.BOLD, 20));
        titleLabel.setForeground(new Color(79, 70, 229));

        JLabel subtitleLabel = new JLabel("Swing MVC Desktop Client", SwingConstants.CENTER);
        subtitleLabel.setFont(new Font("SansSerif", Font.PLAIN, 12));
        subtitleLabel.setForeground(Color.GRAY);

        headerPanel.add(titleLabel);
        headerPanel.add(subtitleLabel);
        mainPanel.add(headerPanel, BorderLayout.NORTH);

        // Fields
        JPanel fieldsPanel = new JPanel(new GridLayout(4, 1, 5, 5));
        fieldsPanel.setBackground(Color.WHITE);

        fieldsPanel.add(new JLabel("Administrator Email:"));
        fieldsPanel.add(emailField);
        fieldsPanel.add(new JLabel("Password:"));
        fieldsPanel.add(passwordField);

        mainPanel.add(fieldsPanel, BorderLayout.CENTER);

        // Footer Actions
        JPanel footerPanel = new JPanel(new BorderLayout(5, 5));
        footerPanel.setBackground(Color.WHITE);

        statusLabel.setForeground(Color.RED);
        statusLabel.setFont(new Font("SansSerif", Font.PLAIN, 11));
        footerPanel.add(statusLabel, BorderLayout.NORTH);

        JButton loginBtn = new JButton("Sign In to Desktop Admin");
        loginBtn.setBackground(new Color(79, 70, 229));
        loginBtn.setForeground(Color.WHITE);
        loginBtn.setFocusPainted(false);
        loginBtn.addActionListener(e -> onLogin());

        footerPanel.add(loginBtn, BorderLayout.CENTER);
        mainPanel.add(footerPanel, BorderLayout.SOUTH);

        add(mainPanel);
    }

    private void onLogin() {
        String email = emailField.getText().trim();
        String password = new String(passwordField.getPassword()).trim();

        statusLabel.setText("Authenticating credentials...");
        User user = authService.authenticate(email, password);

        if (user != null) {
            if (user.isAdmin()) {
                dispose();
                SwingUtilities.invokeLater(() -> new AdminDashboardFrame(user).setVisible(true));
            } else {
                statusLabel.setText("Access Denied: Admin role required.");
            }
        } else {
            statusLabel.setText("Invalid email or password.");
        }
    }
}

