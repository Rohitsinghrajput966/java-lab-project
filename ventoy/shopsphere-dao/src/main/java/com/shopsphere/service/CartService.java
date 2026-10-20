package com.shopsphere.service;

import com.shopsphere.common.model.CartItem;
import com.shopsphere.dao.CartDAO;

import java.util.List;

public class CartService {
    private final CartDAO cartDAO = new CartDAO();

    public List<CartItem> getCartItems(int userId) {
        return cartDAO.getItemsByUserId(userId);
    }

    public boolean addToCart(int userId, int productId, int quantity) {
        return cartDAO.addItem(userId, productId, quantity);
    }

    public boolean updateCartQuantity(int userId, int productId, int quantity) {
        return cartDAO.updateQuantity(userId, productId, quantity);
    }

    public boolean removeFromCart(int userId, int productId) {
        return cartDAO.removeItem(userId, productId);
    }

    public boolean clearCart(int userId) {
        return cartDAO.clearCart(userId);
    }

    public int getCartItemCount(int userId) {
        return cartDAO.getCartItemCount(userId);
    }

    public double calculateSubtotal(List<CartItem> items) {
        double subtotal = 0.0;
        if (items != null) {
            for (CartItem item : items) {
                subtotal += item.getSubtotal();
            }
        }
        return Math.round(subtotal * 100.0) / 100.0;
    }
}

