package com.shopsphere.service;

import com.shopsphere.common.model.CartItem;
import com.shopsphere.common.model.Product;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class CheckoutServiceTest {

    private CheckoutService checkoutService;

    @BeforeEach
    void setUp() {
        checkoutService = new CheckoutService();
    }

    @Test
    @DisplayName("Verify subtotal and free shipping calculation when cart exceeds $50 threshold")
    void testPricingWithFreeShipping() {
        List<CartItem> items = new ArrayList<>();
        Product p = new Product(1, 1, "Test Headphones", "Brand", "Desc", 100.0, 10.0, 10, null, true);
        items.add(new CartItem(1, 1, 1, 1, p)); // 1 x 90.0 = 90.0

        CheckoutService.OrderPricing pricing = checkoutService.calculatePricing(items, null);

        assertEquals(90.0, pricing.subtotal, 0.01);
        assertEquals(0.0, pricing.shippingFee, "Orders >= $50 must receive free shipping");
        assertEquals(90.0, pricing.finalAmount, 0.01);
    }

    @Test
    @DisplayName("Verify shipping fee applied when subtotal is below $50 threshold")
    void testPricingWithShippingFee() {
        List<CartItem> items = new ArrayList<>();
        Product p = new Product(2, 2, "Test Shirt", "Brand", "Desc", 30.0, 0.0, 10, null, true);
        items.add(new CartItem(1, 1, 2, 1, p)); // 1 x 30.0 = 30.0

        CheckoutService.OrderPricing pricing = checkoutService.calculatePricing(items, null);

        assertEquals(30.0, pricing.subtotal, 0.01);
        assertEquals(10.0, pricing.shippingFee, "Orders < $50 must incur $10 shipping fee");
        assertEquals(40.0, pricing.finalAmount, 0.01);
    }

    @Test
    @DisplayName("Verify empty cart yields zero totals")
    void testEmptyCartPricing() {
        List<CartItem> items = new ArrayList<>();
        CheckoutService.OrderPricing pricing = checkoutService.calculatePricing(items, null);

        assertEquals(0.0, pricing.subtotal, 0.01);
        assertEquals(0.0, pricing.shippingFee, 0.01);
        assertEquals(0.0, pricing.finalAmount, 0.01);
    }
}

