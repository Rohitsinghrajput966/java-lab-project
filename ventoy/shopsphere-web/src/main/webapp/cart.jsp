<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Shopping Cart" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/navbar.jsp"/>

<div class="container my-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-3 border-bottom gap-3">
        <div>
            <div class="d-flex align-items-center gap-2">
                <span class="badge bg-primary bg-opacity-10 text-primary rounded-pill px-3 py-2 fw-semibold">
                    <i class="bi bi-cart3 me-1"></i> Checkout Bag
                </span>
                <span class="text-muted small">|</span>
                <span class="text-muted small">${cartItems != null ? cartItems.size() : 0} unique line item(s)</span>
            </div>
            <h2 class="fw-black tracking-tight mb-0 mt-2 display-6 fw-bold">Your Shopping Cart</h2>
        </div>
        <c:if test="${not empty cartItems}">
            <form action="${pageContext.request.contextPath}/cart" method="post" onsubmit="return confirm('Clear all items from your shopping bag?');" class="m-0">
                <input type="hidden" name="action" value="clear">
                <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill px-3 py-2 fw-semibold d-inline-flex align-items-center gap-1 shadow-sm">
                    <i class="bi bi-trash3"></i> Empty Cart
                </button>
            </form>
        </c:if>
    </div>

    <c:choose>
        <c:when test="${not empty cartItems}">
            <div class="row g-4">
                <!-- Cart Items List -->
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white mb-4">
                        <div class="table-responsive">
                            <table class="table align-middle mb-0">
                                <thead class="table-light">
                                    <tr class="small text-uppercase text-muted fw-bold">
                                        <th class="ps-4 py-3 border-0">Product Details</th>
                                        <th class="py-3 border-0">Unit Price</th>
                                        <th class="py-3 text-center border-0">Quantity</th>
                                        <th class="py-3 border-0">Subtotal</th>
                                        <th class="py-3 pe-4 text-end border-0">Remove</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${cartItems}">
                                        <tr class="border-top">
                                            <td class="ps-4 py-3">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="rounded-3 overflow-hidden shadow-xs border bg-light d-flex align-items-center justify-content-center flex-shrink-0" style="width: 72px; height: 72px;">
                                                        <img src="${item.product.imageUrl != null ? item.product.imageUrl : pageContext.request.contextPath.concat('/assets/img/product-placeholder.svg')}"
                                                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/product-placeholder.svg';"
                                                             alt="${item.product.name}" class="img-fluid" style="width: 100%; height: 100%; object-fit: cover;">
                                                    </div>
                                                    <div>
                                                        <span class="badge bg-light text-muted border rounded-pill px-2 py-0 mb-1" style="font-size: 0.7rem;">${item.product.brand}</span>
                                                        <h6 class="mb-1 fw-bold">
                                                            <a href="${pageContext.request.contextPath}/product-details?id=${item.productId}" class="text-decoration-none text-dark hover-primary">
                                                                ${item.product.name}
                                                            </a>
                                                        </h6>
                                                        <span class="small text-muted font-monospace">SKU: VNT-${item.productId}</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="py-3 fw-bold text-dark">
                                                ₹<fmt:formatNumber value="${item.product.discountedPrice}" minFractionDigits="2" maxFractionDigits="2"/>
                                                <c:if test="${item.product.discount > 0}">
                                                    <div class="small text-muted text-decoration-line-through fw-normal">₹<fmt:formatNumber value="${item.product.price}" minFractionDigits="2" maxFractionDigits="2"/></div>
                                                </c:if>
                                            </td>
                                            <td class="py-3 text-center">
                                                <div class="d-inline-flex align-items-center border rounded-pill p-1 bg-light shadow-2xs">
                                                    <form action="${pageContext.request.contextPath}/cart" method="post" class="d-inline m-0">
                                                        <input type="hidden" name="action" value="update">
                                                        <input type="hidden" name="productId" value="${item.productId}">
                                                        <input type="hidden" name="quantity" value="${item.quantity - 1}">
                                                        <button type="submit" class="btn btn-sm btn-link text-dark p-0 px-2 text-decoration-none" title="Decrease Quantity">
                                                            <i class="bi bi-dash fw-bold"></i>
                                                        </button>
                                                    </form>
                                                    <span class="px-2 fw-bold small text-dark">${item.quantity}</span>
                                                    <form action="${pageContext.request.contextPath}/cart" method="post" class="d-inline m-0">
                                                        <input type="hidden" name="action" value="update">
                                                        <input type="hidden" name="productId" value="${item.productId}">
                                                        <input type="hidden" name="quantity" value="${item.quantity + 1}">
                                                        <button type="submit" class="btn btn-sm btn-link text-dark p-0 px-2 text-decoration-none" title="Increase Quantity">
                                                            <i class="bi bi-plus fw-bold"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                            <td class="py-3 fw-bold text-primary fs-6">
                                                ₹<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                            <td class="pe-4 py-3 text-end">
                                                <form action="${pageContext.request.contextPath}/cart" method="post" class="d-inline m-0">
                                                    <input type="hidden" name="action" value="remove">
                                                    <input type="hidden" name="productId" value="${item.productId}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-circle p-2 shadow-2xs" title="Remove item">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-dark rounded-pill px-4 py-2 fw-semibold d-inline-flex align-items-center gap-2">
                            <i class="bi bi-arrow-left"></i> Continue Shopping
                        </a>
                        <div class="text-muted small">
                            <i class="bi bi-check-circle-fill text-success me-1"></i> Prices include all applicable GST and duties
                        </div>
                    </div>

                    <!-- Trust Signals Bar -->
                    <div class="row g-3 mt-4">
                        <div class="col-md-4">
                            <div class="p-3 bg-white border rounded-4 shadow-sm text-center">
                                <i class="bi bi-shield-check text-primary fs-3 mb-2 d-block"></i>
                                <h6 class="fw-bold mb-1 small">256-Bit SSL Security</h6>
                                <p class="text-muted mb-0" style="font-size: 0.75rem;">End-to-end encrypted transactions</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="p-3 bg-white border rounded-4 shadow-sm text-center">
                                <i class="bi bi-box-seam text-primary fs-3 mb-2 d-block"></i>
                                <h6 class="fw-bold mb-1 small">Instant Dispatch</h6>
                                <p class="text-muted mb-0" style="font-size: 0.75rem;">Orders packed within 24 business hours</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="p-3 bg-white border rounded-4 shadow-sm text-center">
                                <i class="bi bi-arrow-counterclockwise text-primary fs-3 mb-2 d-block"></i>
                                <h6 class="fw-bold mb-1 small">30-Day Returns</h6>
                                <p class="text-muted mb-0" style="font-size: 0.75rem;">Hassle-free money-back guarantee</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Order Summary & Coupon Box -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                        <h5 class="fw-bold mb-3 d-flex align-items-center justify-content-between">
                            <span>Order Summary</span>
                            <span class="badge bg-light text-dark border rounded-pill small">${cartItems.size()} Item(s)</span>
                        </h5>

                        <div class="d-flex justify-content-between mb-2 small text-secondary">
                            <span>Bag Subtotal</span>
                            <span class="fw-bold text-dark">₹<fmt:formatNumber value="${pricing.subtotal}" minFractionDigits="2" maxFractionDigits="2"/></span>
                        </div>

                        <c:if test="${pricing.discount > 0}">
                            <div class="d-flex justify-content-between mb-2 small text-success">
                                <span>Coupon Applied (${sessionScope.appliedCouponCode})</span>
                                <span class="fw-bold">-₹<fmt:formatNumber value="${pricing.discount}" minFractionDigits="2" maxFractionDigits="2"/></span>
                            </div>
                        </c:if>

                        <div class="d-flex justify-content-between mb-3 small text-secondary">
                            <span>Estimated Shipping</span>
                            <span>
                                <c:choose>
                                    <c:when test="${pricing.shippingFee == 0}">
                                        <span class="badge bg-success bg-opacity-25 text-success fw-bold">FREE</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="fw-bold text-dark">₹<fmt:formatNumber value="${pricing.shippingFee}" minFractionDigits="2" maxFractionDigits="2"/></span>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <hr class="my-3 border-secondary-subtle">

                        <div class="d-flex justify-content-between mb-4 align-items-baseline">
                            <div>
                                <span class="fw-bold fs-5 text-dark d-block">Total Payable</span>
                                <span class="text-muted small">Inclusive of all taxes</span>
                            </div>
                            <span class="fs-2 fw-black text-primary font-monospace">₹<fmt:formatNumber value="${pricing.finalAmount}" minFractionDigits="2" maxFractionDigits="2"/></span>
                        </div>

                        <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary btn-lg rounded-pill w-100 fw-bold shadow py-3 d-flex align-items-center justify-content-center gap-2">
                            <span>Proceed to Checkout</span> <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>

                    <!-- Coupon Code Input Box -->
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                        <h6 class="fw-bold mb-2 d-flex align-items-center gap-2">
                            <i class="bi bi-ticket-perforated-fill text-primary"></i> Promotional Coupon
                        </h6>
                        <p class="small text-muted mb-3">Apply voucher codes for instant checkout discounts:</p>

                        <c:choose>
                            <c:when test="${not empty sessionScope.appliedCouponCode}">
                                <div class="d-flex justify-content-between align-items-center p-3 bg-success bg-opacity-10 text-success rounded-3 mb-2 border border-success-subtle">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="bi bi-check-circle-fill"></i>
                                        <span class="fw-bold font-monospace">${sessionScope.appliedCouponCode}</span>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post" class="m-0">
                                        <input type="hidden" name="action" value="removeCoupon">
                                        <button type="submit" class="btn btn-link btn-sm text-danger p-0 text-decoration-none fw-bold">
                                            <i class="bi bi-x-circle me-1"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/cart" method="post" class="mb-3">
                                    <input type="hidden" name="action" value="applyCoupon">
                                    <div class="input-group">
                                        <input type="text" name="couponCode" class="form-control rounded-start-pill text-uppercase shadow-none font-monospace fw-bold" placeholder="e.g. WELCOME10" required>
                                        <button class="btn btn-dark rounded-end-pill px-4 fw-semibold" type="submit">Apply</button>
                                    </div>
                                </form>
                                <div class="d-flex gap-2 flex-wrap">
                                    <span class="badge bg-light text-secondary border rounded-pill px-2 py-1 small">WELCOME10 (10% off)</span>
                                    <span class="badge bg-light text-secondary border rounded-pill px-2 py-1 small">FLAT20 (20% off)</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center py-5 bg-white rounded-4 border shadow-sm my-5 p-5">
                <div class="d-inline-flex p-4 rounded-circle bg-primary bg-opacity-10 text-primary mb-3">
                    <i class="bi bi-cart-x display-4"></i>
                </div>
                <h3 class="fw-bold text-dark">Your Cart is Currently Empty</h3>
                <p class="text-muted mb-4 mx-auto" style="max-width: 460px;">
                    Looks like you haven't added any products yet. Browse through our premium categories to find something you'll love!
                </p>
                <div class="d-flex justify-content-center gap-3">
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill px-5 py-3 fw-bold shadow">
                        <i class="bi bi-bag-plus me-1"></i> Explore Catalog
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/fragments/footer.jsp"/>
