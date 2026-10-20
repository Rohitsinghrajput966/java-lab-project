package com.shopsphere.network.server;

import com.shopsphere.common.config.AppConfig;
import com.shopsphere.common.model.Product;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.network.protocol.NetworkCommand;
import com.shopsphere.network.protocol.NetworkResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * RTU Syllabus Demonstration: java.net ServerSocket multi-threaded server.
 * Handles remote inventory requests using Java Object Serialization.
 */
public class InventoryServer {
    private static final Logger logger = LoggerFactory.getLogger(InventoryServer.class);
    private final int port;
    private final ProductDAO productDAO = new ProductDAO();
    private final ExecutorService threadPool = Executors.newCachedThreadPool();
    private volatile boolean running = true;

    public InventoryServer(int port) {
        this.port = port;
    }

    public void start() {
        try (ServerSocket serverSocket = new ServerSocket(port)) {
            logger.info("shopsphere java.net Inventory Server listening on port {}", port);
            System.out.println(">>> shopsphere Inventory Server is running on port " + port);

            while (running) {
                Socket clientSocket = serverSocket.accept();
                threadPool.submit(() -> handleClient(clientSocket));
            }
        } catch (Exception e) {
            if (running) {
                logger.error("Inventory Server error: {}", e.getMessage(), e);
            }
        } finally {
            threadPool.shutdown();
        }
    }

    private void handleClient(Socket socket) {
        logger.debug("Accepted connection from {}", socket.getRemoteSocketAddress());
        try (ObjectInputStream in = new ObjectInputStream(socket.getInputStream());
             ObjectOutputStream out = new ObjectOutputStream(socket.getOutputStream())) {

            Object received = in.readObject();
            if (received instanceof NetworkCommand) {
                NetworkCommand cmd = (NetworkCommand) received;
                NetworkResponse response = processCommand(cmd);
                out.writeObject(response);
                out.flush();
            } else {
                out.writeObject(NetworkResponse.error("Unrecognized command protocol."));
            }
        } catch (Exception e) {
            logger.warn("Error processing socket client {}: {}", socket.getRemoteSocketAddress(), e.getMessage());
        } finally {
            try { socket.close(); } catch (Exception ignored) {}
        }
    }

    private NetworkResponse processCommand(NetworkCommand cmd) {
        String action = cmd.getAction();
        if ("GET_PRODUCT".equalsIgnoreCase(action)) {
            Product p = productDAO.findById(cmd.getProductId());
            if (p != null) {
                return NetworkResponse.success("Product found", p);
            } else {
                return NetworkResponse.error("Product not found with id " + cmd.getProductId());
            }
        } else if ("GET_STOCK".equalsIgnoreCase(action)) {
            Product p = productDAO.findById(cmd.getProductId());
            if (p != null) {
                return NetworkResponse.success("Stock count", p.getStock());
            } else {
                return NetworkResponse.error("Product not found");
            }
        } else if ("SEARCH".equalsIgnoreCase(action)) {
            List<Product> results = productDAO.searchAndFilter(cmd.getSearchQuery(), null, null, null, "newest");
            return NetworkResponse.success("Search completed", results);
        } else if ("UPDATE_STOCK".equalsIgnoreCase(action)) {
            boolean ok = productDAO.updateStock(cmd.getProductId(), cmd.getQuantityDelta());
            return ok ? NetworkResponse.success("Stock updated", true)
                      : NetworkResponse.error("Failed to update stock or insufficient stock");
        }
        return NetworkResponse.error("Unsupported action: " + action);
    }

    public void stop() {
        this.running = false;
    }

    public static void main(String[] args) {
        int port = AppConfig.getNetworkPort();
        InventoryServer server = new InventoryServer(port);
        server.start();
    }
}

