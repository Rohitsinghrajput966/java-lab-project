package com.shopsphere.common.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Coupon implements Serializable {
    private static final long serialVersionUID = 1L;

    private int couponId;
    private String code;
    private String discountType; // "PERCENTAGE", "FIXED"
    private double discountValue;
    private double minimumOrder;
    private Double maximumDiscount;
    private Timestamp expiryDate;
    private boolean status;
    private Timestamp createdAt;

    public Coupon() {}

    public Coupon(int couponId, String code, String discountType, double discountValue,
                  double minimumOrder, Double maximumDiscount, Timestamp expiryDate, boolean status) {
        this.couponId = couponId;
        this.code = code;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.minimumOrder = minimumOrder;
        this.maximumDiscount = maximumDiscount;
        this.expiryDate = expiryDate;
        this.status = status;
    }

    public int getCouponId() { return couponId; }
    public void setCouponId(int couponId) { this.couponId = couponId; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }

    public double getDiscountValue() { return discountValue; }
    public void setDiscountValue(double discountValue) { this.discountValue = discountValue; }

    public double getMinimumOrder() { return minimumOrder; }
    public void setMinimumOrder(double minimumOrder) { this.minimumOrder = minimumOrder; }

    public Double getMaximumDiscount() { return maximumDiscount; }
    public void setMaximumDiscount(Double maximumDiscount) { this.maximumDiscount = maximumDiscount; }

    public Timestamp getExpiryDate() { return expiryDate; }
    public void setExpiryDate(Timestamp expiryDate) { this.expiryDate = expiryDate; }

    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public boolean isValidForAmount(double amount) {
        if (!status) return false;
        if (expiryDate != null && expiryDate.before(new java.util.Date())) return false;
        return amount >= minimumOrder;
    }

    public double calculateDiscount(double subtotal) {
        if (!isValidForAmount(subtotal)) return 0.0;
        double discount = 0.0;
        if ("PERCENTAGE".equalsIgnoreCase(discountType)) {
            discount = subtotal * (discountValue / 100.0);
            if (maximumDiscount != null && maximumDiscount > 0 && discount > maximumDiscount) {
                discount = maximumDiscount;
            }
        } else if ("FIXED".equalsIgnoreCase(discountType)) {
            discount = Math.min(discountValue, subtotal);
        }
        return Math.round(discount * 100.0) / 100.0;
    }
}

