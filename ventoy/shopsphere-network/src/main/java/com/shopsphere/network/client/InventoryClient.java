package com.shopsphere.network.client;

import com.shopsphere.common.config.AppConfig;
import com.shopsphere.common.model.Product;
import com.shopsphere.network.protocol.NetworkCommand;
import com.shopsphere.network.protocol.NetworkResponse;

import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.util.List;

/**
 * RTU Syllabus Demonstration: java.net Socket client.
 * Connects to InventoryServer, serializes commands, and receives serialized objects.
 */
public class InventoryClient {
    private final String host;
    private final int port;

    public InventoryClient(String host, int port) {
        this.host = host;
        this.port = port;
    }

    public NetworkResponse sendCommand(NetworkCommand command) {
        try (Socket socket = new Socket(host, port);
             ObjectOutputStream out = new ObjectOutputStream(socket.getOutputStream());
             ObjectInputStream in = new ObjectInputStream(socket.getInputStream())) {

            out.writeObject(command);
            out.flush();

            return (NetworkResponse) in.readObject();
        } catch (Exception e) {
            return NetworkResponse.error("Socket communication error: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        String host = "localhost";
        int port = AppConfig.getNetworkPort();
        System.out.println("Connecting to shopsphere Inventory Server at " + host + ":" + port + "...");

        InventoryClient client = new InventoryClient(host, port);

        // 1. Test GET_PRODUCT
        System.out.println("\n--- Testing GET_PRODUCT (ID: 1) ---");
        NetworkResponse r1 = client.sendCommand(NetworkCommand.getProduct(1));
        System.out.println("Response Status: " + r1.isSuccess() + " | Message: " + r1.getMessage());
        if (r1.getPayload() instanceof Product) {
            Product p = (Product) r1.getPayload();
            System.out.println("Deserialized Product: " + p.getName() + " | Price: ₹" + p.getPrice() + " | Stock: " + p.getStock());
        }

        // 2. Test GET_STOCK
        System.out.println("\n--- Testing GET_STOCK (ID: 1) ---");
        NetworkResponse r2 = client.sendCommand(NetworkCommand.getStock(1));
        System.out.println("Response Status: " + r2.isSuccess() + " | Current Stock: " + r2.getPayload());

        // 3. Test SEARCH
        System.out.println("\n--- Testing SEARCH (Query: 'Kurta') ---");
        NetworkResponse r3 = client.sendCommand(NetworkCommand.search("Kurta"));
        System.out.println("Response Status: " + r3.isSuccess());
        if (r3.getPayload() instanceof List) {
            List<?> list = (List<?>) r3.getPayload();
            System.out.println("Found " + list.size() + " matching products.");
        }
    }
}

