package com.shopsphere.network.protocol;

import java.io.Serializable;

/**
 * Serializable command object transferred over java.net.Socket streams.
 */
public class NetworkCommand implements Serializable {
    private static final long serialVersionUID = 1L;

    private String action; // "GET_PRODUCT", "GET_STOCK", "SEARCH", "UPDATE_STOCK"
    private int productId;
    private int quantityDelta;
    private String searchQuery;

    public NetworkCommand() {}

    public NetworkCommand(String action) {
        this.action = action;
    }

    public static NetworkCommand getProduct(int productId) {
        NetworkCommand cmd = new NetworkCommand("GET_PRODUCT");
        cmd.productId = productId;
        return cmd;
    }

    public static NetworkCommand getStock(int productId) {
        NetworkCommand cmd = new NetworkCommand("GET_STOCK");
        cmd.productId = productId;
        return cmd;
    }

    public static NetworkCommand search(String query) {
        NetworkCommand cmd = new NetworkCommand("SEARCH");
        cmd.searchQuery = query;
        return cmd;
    }

    public static NetworkCommand updateStock(int productId, int quantityDelta) {
        NetworkCommand cmd = new NetworkCommand("UPDATE_STOCK");
        cmd.productId = productId;
        cmd.quantityDelta = quantityDelta;
        return cmd;
    }

    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getQuantityDelta() { return quantityDelta; }
    public void setQuantityDelta(int quantityDelta) { this.quantityDelta = quantityDelta; }

    public String getSearchQuery() { return searchQuery; }
    public void setSearchQuery(String searchQuery) { this.searchQuery = searchQuery; }
}

