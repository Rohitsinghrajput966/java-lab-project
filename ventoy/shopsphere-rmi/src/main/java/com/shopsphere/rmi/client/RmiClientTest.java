package com.shopsphere.rmi.client;

import com.shopsphere.common.config.AppConfig;
import com.shopsphere.common.model.Product;
import com.shopsphere.rmi.server.RmiServerLauncher;
import com.shopsphere.rmi.service.InventoryRemoteService;

import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

/**
 * RTU Syllabus Requirement: RMI Registry Lookup & Remote Method Call Demonstration.
 */
public class RmiClientTest {

    public static void main(String[] args) {
        String host = AppConfig.getRmiHost();
        int port = AppConfig.getRmiPort();

        System.out.println("Looking up RMI Registry at " + host + ":" + port + "...");
        try {
            Registry registry = LocateRegistry.getRegistry(host, port);
            InventoryRemoteService service = (InventoryRemoteService) registry.lookup(RmiServerLauncher.BINDING_NAME);

            System.out.println(">>> Successfully resolved remote service stub: " + service);

            // 1. Remote call: getProduct(1)
            System.out.println("\n[RMI Call 1] Invoking remote getProduct(1)...");
            Product p = service.getProduct(1);
            if (p != null) {
                System.out.println("Returned Product: " + p.getName() + " | Price: ₹" + p.getPrice() + " | Stock: " + p.getStock());
            }

            // 2. Remote call: getStock(1)
            System.out.println("\n[RMI Call 2] Invoking remote getStock(1)...");
            int stock = service.getStock(1);
            System.out.println("Returned Stock Units: " + stock);

            // 3. Remote call: updateStock(1, 0) (verification call)
            System.out.println("\n[RMI Call 3] Invoking remote updateStock(1, 0)...");
            boolean status = service.updateStock(1, 0);
            System.out.println("Remote Execution Status: " + status);

        } catch (Exception e) {
            System.err.println("RMI Remote invocation failed: " + e.getMessage());
            System.err.println("(Ensure RmiServerLauncher is running prior to executing RmiClientTest)");
        }
    }
}

