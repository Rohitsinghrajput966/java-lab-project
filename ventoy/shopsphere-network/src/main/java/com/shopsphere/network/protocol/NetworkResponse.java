package com.shopsphere.network.protocol;

import java.io.Serializable;

/**
 * Serializable response envelope transferred over java.net.Socket streams.
 */
public class NetworkResponse implements Serializable {
    private static final long serialVersionUID = 1L;

    private boolean success;
    private String message;
    private Object payload; // Can be Product, List<Product>, Integer, etc.

    public NetworkResponse() {}

    public NetworkResponse(boolean success, String message, Object payload) {
        this.success = success;
        this.message = message;
        this.payload = payload;
    }

    public static NetworkResponse success(String message, Object payload) {
        return new NetworkResponse(true, message, payload);
    }

    public static NetworkResponse error(String message) {
        return new NetworkResponse(false, message, null);
    }

    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Object getPayload() { return payload; }
    public void setPayload(Object payload) { this.payload = payload; }

    @Override
    public String toString() {
        return "NetworkResponse{" +
                "success=" + success +
                ", message='" + message + '\'' +
                ", payload=" + payload +
                '}';
    }
}

