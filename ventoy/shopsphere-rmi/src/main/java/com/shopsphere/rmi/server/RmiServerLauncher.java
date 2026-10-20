package com.shopsphere.rmi.server;

import com.shopsphere.common.config.AppConfig;
import com.shopsphere.rmi.service.InventoryRemoteService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

/**
 * RTU Syllabus Requirement: RMI Registry and Remote Object Binding Launcher.
 */
public class RmiServerLauncher {
    private static final Logger logger = LoggerFactory.getLogger(RmiServerLauncher.class);
    public static final String BINDING_NAME = "shopsphereInventoryService";

    public static void main(String[] args) {
        int port = AppConfig.getRmiPort();
        try {
            // 1. Create or obtain RMI Registry on designated port
            Registry registry;
            try {
                registry = LocateRegistry.createRegistry(port);
                logger.info("Created new embedded RMI Registry on port {}", port);
            } catch (Exception e) {
                registry = LocateRegistry.getRegistry(port);
                logger.info("Using existing RMI Registry on port {}", port);
            }

            // 2. Instantiate and rebind remote implementation
            InventoryRemoteService service = new InventoryRemoteServiceImpl();
            registry.rebind(BINDING_NAME, service);

            logger.info("Successfully bound '{}' to RMI Registry on port {}", BINDING_NAME, port);
            System.out.println(">>> shopsphere RMI Registry & Inventory Service is online on port " + port);
            System.out.println(">>> Registered binding: " + BINDING_NAME);

            // Keep alive
            Thread.currentThread().join();
        } catch (Exception e) {
            logger.error("Failed to start RMI Server Launcher: {}", e.getMessage(), e);
        }
    }
}

