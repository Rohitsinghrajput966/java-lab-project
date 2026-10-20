package com.shopsphere.web.listener;

import com.shopsphere.dao.db.DBConnectionPool;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * ServletContextListener demonstrating web-container lifecycle management.
 * Initializes database pooling and application attributes on startup,
 * and ensures orderly resource teardown on shutdown.
 */
@WebListener
public class AppContextListener implements ServletContextListener {
    private static final Logger logger = LoggerFactory.getLogger(AppContextListener.class);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        logger.info("Initializing shopsphere Enterprise Application Context...");

        // Set global context variables
        context.setAttribute("appName", "shopsphere");
        context.setAttribute("appTagline", "Modern Enterprise Java E-Commerce Platform");
        context.setAttribute("appVersion", "1.0.0");

        // Warm up connection pool
        try {
            DBConnectionPool.getDataSource();
            logger.info("Database connection pool initialized successfully.");
        } catch (Exception e) {
            logger.error("Database connection pool initialization warning: {}", e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("Destroying shopsphere Application Context and releasing connection pool...");
        DBConnectionPool.shutdown();
    }
}

