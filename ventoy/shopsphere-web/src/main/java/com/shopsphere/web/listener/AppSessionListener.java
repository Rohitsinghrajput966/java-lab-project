package com.shopsphere.web.listener;

import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.concurrent.atomic.AtomicInteger;

/**
 * HttpSessionListener demonstrating session lifecycle events and active session metrics.
 */
@WebListener
public class AppSessionListener implements HttpSessionListener {
    private static final Logger logger = LoggerFactory.getLogger(AppSessionListener.class);
    private static final AtomicInteger activeSessions = new AtomicInteger(0);

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        int count = activeSessions.incrementAndGet();
        logger.debug("New HTTP session created: {}. Active count: {}", se.getSession().getId(), count);
        se.getSession().getServletContext().setAttribute("activeUserCount", count);
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        int count = activeSessions.decrementAndGet();
        logger.debug("HTTP session destroyed: {}. Active count: {}", se.getSession().getId(), count);
        se.getSession().getServletContext().setAttribute("activeUserCount", Math.max(0, count));
    }

    public static int getActiveSessions() {
        return activeSessions.get();
    }
}

