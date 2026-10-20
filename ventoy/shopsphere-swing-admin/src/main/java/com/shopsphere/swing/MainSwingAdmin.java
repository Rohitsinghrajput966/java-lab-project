package com.shopsphere.swing;

import com.shopsphere.swing.view.LoginFrame;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.swing.*;

/**
 * Entry point for the shopsphere Swing Desktop Administration module.
 * Sets the Pluggable Look and Feel and initiates the Swing event dispatch thread.
 */
public class MainSwingAdmin {
    private static final Logger logger = LoggerFactory.getLogger(MainSwingAdmin.class);

    public static void main(String[] args) {
        try {
            // Apply native System Look and Feel (RTU syllabus requirement: Pluggable Look and Feel)
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception e) {
            logger.warn("Could not set system look and feel: {}", e.getMessage());
        }

        SwingUtilities.invokeLater(() -> {
            LoginFrame frame = new LoginFrame();
            frame.setVisible(true);
        });
    }
}

