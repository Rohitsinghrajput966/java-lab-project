<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Secure Checkout" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/navbar.jsp"/>

<div class="container my-5">
    <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 pb-3 border-bottom gap-3">
        <div class="d-flex align-items-center gap-3">
            <div class="d-inline-flex p-3 rounded-circle bg-success bg-opacity-10 text-success">
                <i class="bi bi-shield-lock-fill fs-3"></i>
            </div>
            <div>
                <h2 class="fw-black mb-0 display-6 fw-bold">Secure Checkout</h2>
                <p class="text-muted small mb-0">256-bit encrypted bank-grade SSL transaction portal</p>
            </div>
        </div>
        <div class="d-flex align-items-center gap-2">
            <span class="badge bg-light text-muted border rounded-pill px-3 py-2 small">
                <i class="bi bi-lock-fill text-success me-1"></i> PCI-DSS Compliant
            </span>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/checkout" method="post">
        <div class="row g-4">
            <!-- Left Column: Address & Payment Method -->
            <div class="col-lg-8">
                <!-- Step 1: Delivery Address -->
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <h5 class="fw-bold mb-0 d-flex align-items-center gap-2">
                            <span class="badge bg-primary rounded-circle" style="width: 28px; height: 28px; display: inline-flex; align-items: center; justify-content: center;">1</span>
                            Delivery Address
                        </h5>
                        <span class="badge bg-light text-secondary border small">Step 1 of 2</span>
                    </div>

                    <c:choose>
                        <c:when test="${not empty addresses}">
                            <div class="d-flex flex-column gap-3 mb-3">
                                <c:forEach var="addr" items="${addresses}" varStatus="status">
                                    <label class="form-check p-3 border rounded-3 bg-light d-flex align-items-start gap-3 cursor-pointer position-relative shadow-2xs hover-border-primary" for="addr_${addr.addressId}">
                                        <input class="form-check-input mt-1 flex-shrink-0" type="radio" name="addressId" id="addr_${addr.addressId}" value="${addr.addressId}" ${status.first ? 'checked' : ''}>
                                        <div class="flex-grow-1">
                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                <span class="badge bg-secondary text-uppercase" style="font-size: 0.7rem;">${addr.addressType}</span>
                                                <c:if test="${addr['default']}"><span class="badge bg-success bg-opacity-25 text-success small">Default Shipping Address</span></c:if>
                                            </div>
                                            <div class="text-dark fw-bold mb-1">${addr.addressLine}</div>
                                            <div class="text-muted small">${addr.city}, ${addr.state} - <span class="font-monospace fw-semibold">${addr.pincode}</span></div>
                                        </div>
                                    </label>
                                </c:forEach>
                            </div>

                            <!-- Option to add new address -->
                            <div class="form-check mb-3">
                                <input class="form-check-input" type="radio" name="addressId" id="addr_new" value="new" data-bs-toggle="collapse" data-bs-target="#newAddressFields">
                                <label class="form-check-label fw-bold text-primary cursor-pointer" for="addr_new">
                                    <i class="bi bi-plus-circle-fill me-1"></i> Deliver to a New or Different Address
                                </label>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="addressId" value="new">
                            <div class="alert alert-info border-0 rounded-3 mb-3 small d-flex align-items-center gap-2">
                                <i class="bi bi-info-circle-fill fs-5"></i>
                                <span>No saved addresses found. Please enter your shipping destination below:</span>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- New Address Form Fields -->
                    <div class="collapse ${empty addresses ? 'show' : ''}" id="newAddressFields">
                        <div class="p-3 bg-light rounded-3 border">
                            <h6 class="fw-bold mb-3 text-dark">Enter New Destination Details</h6>
                            <div class="mb-3">
                                <label class="form-label small fw-semibold">Street / Flat / Landmark Address</label>
                                <input type="text" name="newAddressLine" class="form-control rounded-3" placeholder="e.g. Penthouse 402, Skyline Towers">
                            </div>
                            <div class="row g-2 mb-3">
                                <div class="col-md-5">
                                    <label class="form-label small fw-semibold">City</label>
                                    <input type="text" name="newCity" class="form-control rounded-3" placeholder="City">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label small fw-semibold">State</label>
                                    <input type="text" name="newState" class="form-control rounded-3" placeholder="State">
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label small fw-semibold">Pincode / ZIP</label>
                                    <input type="text" name="newPincode" class="form-control rounded-3" placeholder="6-digit ZIP">
                                </div>
                            </div>
                            <div>
                                <label class="form-label small fw-semibold">Destination Tag</label>
                                <select name="newAddressType" class="form-select rounded-3">
                                    <option value="HOME">Residential / Home</option>
                                    <option value="WORK">Corporate / Office</option>
                                    <option value="BILLING">Billing Only</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Step 2: Payment Method -->
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <h5 class="fw-bold mb-0 d-flex align-items-center gap-2">
                            <span class="badge bg-primary rounded-circle" style="width: 28px; height: 28px; display: inline-flex; align-items: center; justify-content: center;">2</span>
                            Select Payment Method
                        </h5>
                        <span class="badge bg-light text-secondary border small">Step 2 of 2</span>
                    </div>

                    <div class="d-flex flex-column gap-3">
                        <!-- UPI -->
                        <label class="form-check p-3 border rounded-3 bg-light d-flex align-items-center gap-3 cursor-pointer shadow-2xs hover-border-primary" for="pay_upi">
                            <input class="form-check-input mt-0 flex-shrink-0" type="radio" name="paymentMethod" id="pay_upi" value="UPI" checked>
                            <div class="flex-grow-1 d-flex align-items-center justify-content-between">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="p-2 bg-primary bg-opacity-10 rounded-3 text-primary">
                                        <i class="bi bi-qr-code-scan fs-4"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-dark">UPI Instant Payment (Zero Surcharge)</div>
                                        <div class="text-muted small">Google Pay, PhonePe, Paytm, BHIM, CRED</div>
                                    </div>
                                </div>
                                <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3 py-1 fw-bold small">Instant</span>
                            </div>
                        </label>

                        <!-- Card -->
                        <label class="form-check p-3 border rounded-3 bg-light d-flex align-items-center gap-3 cursor-pointer shadow-2xs hover-border-primary" for="pay_card">
                            <input class="form-check-input mt-0 flex-shrink-0" type="radio" name="paymentMethod" id="pay_card" value="CARD">
                            <div class="flex-grow-1 d-flex align-items-center justify-content-between">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="p-2 bg-success bg-opacity-10 rounded-3 text-success">
                                        <i class="bi bi-credit-card-2-front fs-4"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-dark">Credit &amp; Debit Cards</div>
                                        <div class="text-muted small">Visa, Mastercard, RuPay, American Express</div>
                                    </div>
                                </div>
                                <span class="badge bg-light text-muted border rounded-pill px-2 py-1 small">Cards</span>
                            </div>
                        </label>

                        <!-- COD -->
                        <label class="form-check p-3 border rounded-3 bg-light d-flex align-items-center gap-3 cursor-pointer shadow-2xs hover-border-primary" for="pay_cod">
                            <input class="form-check-input mt-0 flex-shrink-0" type="radio" name="paymentMethod" id="pay_cod" value="COD">
                            <div class="flex-grow-1 d-flex align-items-center justify-content-between">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="p-2 bg-warning bg-opacity-10 rounded-3 text-warning">
                                        <i class="bi bi-cash-stack fs-4 text-dark"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-dark">Cash on Delivery (COD)</div>
                                        <div class="text-muted small">Pay cash or UPI upon delivery at your doorstep</div>
                                    </div>
                                </div>
                                <span class="badge bg-light text-dark border rounded-pill px-2 py-1 small">COD</span>
                            </div>
                        </label>
                    </div>
                </div>
            </div>

            <!-- Right Column: Final Summary & CTA -->
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white sticky-top" style="top: 100px;">
                    <h5 class="fw-bold mb-3 d-flex align-items-center justify-content-between">
                        <span>Order Summary</span>
                        <span class="badge bg-light text-dark border rounded-pill small">${cartItems != null ? cartItems.size() : 0} items</span>
                    </h5>

                    <div class="d-flex flex-column gap-2 mb-3 overflow-auto" style="max-height: 220px;">
                        <c:forEach var="item" items="${cartItems}">
                            <div class="d-flex justify-content-between align-items-center small py-1 border-bottom-subtle">
                                <div class="text-truncate me-2" style="max-width: 180px;">
                                    <span class="fw-bold text-primary font-monospace">${item.quantity}x</span>
                                    <span class="text-dark">${item.product.name}</span>
                                </div>
                                <span class="fw-bold text-dark font-monospace">₹<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" maxFractionDigits="2"/></span>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="d-flex justify-content-between mb-2 small text-secondary">
                        <span>Items Subtotal</span>
                        <span class="fw-bold text-dark font-monospace">₹<fmt:formatNumber value="${pricing.subtotal}" minFractionDigits="2" maxFractionDigits="2"/></span>
                    </div>

                    <c:if test="${pricing.discount > 0}">
                        <div class="d-flex justify-content-between mb-2 small text-success">
                            <span>Voucher Discount</span>
                            <span class="fw-bold font-monospace">-₹<fmt:formatNumber value="${pricing.discount}" minFractionDigits="2" maxFractionDigits="2"/></span>
                        </div>
                    </c:if>

                    <div class="d-flex justify-content-between mb-3 small text-secondary">
                        <span>Express Delivery</span>
                        <span>
                            <c:choose>
                                <c:when test="${pricing.shippingFee == 0}">
                                    <span class="badge bg-success bg-opacity-25 text-success fw-bold">FREE</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="fw-bold text-dark font-monospace">₹<fmt:formatNumber value="${pricing.shippingFee}" minFractionDigits="2" maxFractionDigits="2"/></span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <hr class="my-3 border-secondary-subtle">

                    <div class="d-flex justify-content-between mb-4 align-items-baseline">
                        <div>
                            <span class="fw-bold fs-5 text-dark d-block">Grand Total</span>
                            <span class="text-muted small">All taxes included</span>
                        </div>
                        <span class="fs-2 fw-black text-primary font-monospace">₹<fmt:formatNumber value="${pricing.finalAmount}" minFractionDigits="2" maxFractionDigits="2"/></span>
                    </div>

                    <button type="submit" class="btn btn-primary btn-lg rounded-pill w-100 fw-bold shadow py-3 d-flex align-items-center justify-content-center gap-2">
                        <i class="bi bi-shield-check"></i> Place &amp; Confirm Order
                    </button>

                    <div class="mt-3 text-center text-muted small">
                        <i class="bi bi-patch-check-fill text-success me-1"></i> Authorized ShopSphere Purchase Guarantee
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<jsp:include page="/fragments/footer.jsp"/>
