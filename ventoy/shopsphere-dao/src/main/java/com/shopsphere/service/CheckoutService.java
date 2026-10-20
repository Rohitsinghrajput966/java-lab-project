package com.shopsphere.service;

import com.shopsphere.common.model.*;
import com.shopsphere.dao.CouponDAO;
import com.shopsphere.dao.OrderDAO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.UUID;

public class CheckoutService {
    private static final Logger logger = LoggerFactory.getLogger(CheckoutService.class);

    private final CartService cartService = new CartService();
    private final CouponDAO couponDAO = new CouponDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    public static class OrderPricing {
        public double subtotal;
        public double discount;
        public double shippingFee;
        public double finalAmount;
        public Coupon appliedCoupon;

        public double getSubtotal() { return subtotal; }
        public double getDiscount() { return discount; }
        public double getShippingFee() { return shippingFee; }
        public double getFinalAmount() { return finalAmount; }
        public Coupon getAppliedCoupon() { return appliedCoupon; }
    }

    public OrderPricing calculatePricing(List<CartItem> items, String couponCode) {
        OrderPricing pricing = new OrderPricing();
        pricing.subtotal = cartService.calculateSubtotal(items);

        // Calculate coupon discount
        if (couponCode != null && !couponCode.trim().isEmpty()) {
            Coupon coupon = couponDAO.findByCode(couponCode.trim());
            if (coupon != null && coupon.isValidForAmount(pricing.subtotal)) {
                pricing.appliedCoupon = coupon;
                pricing.discount = coupon.calculateDiscount(pricing.subtotal);
            }
        }

        // Standard shipping rules: Free shipping over $50, otherwise $10.00
        pricing.shippingFee = (pricing.subtotal >= 50.0 || pricing.subtotal == 0) ? 0.0 : 10.0;
        pricing.finalAmount = Math.max(0.0, Math.round((pricing.subtotal - pricing.discount + pricing.shippingFee) * 100.0) / 100.0);
        return pricing;
    }

    public Order processCheckout(int userId, int addressId, String couponCode, String paymentMethod) {
        List<CartItem> cartItems = cartService.getCartItems(userId);
        if (cartItems == null || cartItems.isEmpty()) {
            logger.warn("Cannot checkout empty cart for user {}", userId);
            return null;
        }

        // Recalculate everything strictly on the server
        OrderPricing pricing = calculatePricing(cartItems, couponCode);

        Order order = new Order();
        order.setUserId(userId);
        order.setAddressId(addressId);
        order.setTotalAmount(pricing.subtotal);
        order.setDiscount(pricing.discount);
        order.setShippingFee(pricing.shippingFee);
        order.setFinalAmount(pricing.finalAmount);
        order.setPaymentMethod(paymentMethod != null ? paymentMethod : "COD");
        order.setPaymentStatus("COD".equalsIgnoreCase(paymentMethod) ? "PENDING" : "PAID");
        order.setOrderStatus("CONFIRMED");

        // Mock payment record
        Payment payment = new Payment();
        payment.setPaymentMethod(order.getPaymentMethod());
        payment.setTransactionReference("TXN_" + UUID.randomUUID().toString().substring(0, 12).toUpperCase());
        payment.setAmount(order.getFinalAmount());
        payment.setPaymentStatus("COD".equalsIgnoreCase(paymentMethod) ? "PENDING" : "SUCCESS");

        Integer couponId = pricing.appliedCoupon != null ? pricing.appliedCoupon.getCouponId() : null;

        boolean success = orderDAO.placeOrderTransaction(order, cartItems, payment, couponId);
        if (success) {
            logger.info("Order successfully created with order_id: {}", order.getOrderId());
            return order;
        } else {
            logger.error("Order transaction failed for user: {}", userId);
            return null;
        }
    }
}

