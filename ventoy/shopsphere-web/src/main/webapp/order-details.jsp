<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Order #VNT-${order.orderId}" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/navbar.jsp"/>

<div class="container my-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-3 border-bottom gap-3">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/orders" class="text-decoration-none">My Orders</a></li>
                    <li class="breadcrumb-item active font-monospace" aria-current="page">#VNT-${order.orderId}</li>
                </ol>
            </nav>
            <h2 class="fw-black mb-0 display-6 fw-bold">Order Details &amp; Tax Invoice</h2>
        </div>
        <div class="d-flex gap-2">
            <button onclick="window.print()" class="btn btn-outline-dark rounded-pill px-3 py-2 btn-sm fw-semibold d-inline-flex align-items-center gap-1 shadow-2xs">
                <i class="bi bi-printer"></i> Print Invoice
            </button>
            <a href="${pageContext.request.contextPath}/orders" class="btn btn-primary rounded-pill px-3 py-2 btn-sm fw-semibold d-inline-flex align-items-center gap-1 shadow-2xs">
                <i class="bi bi-arrow-left"></i> Back to Orders
            </a>
        </div>
    </div>

    <div class="row g-4">
        <!-- Main Line Items -->
        <div class="col-lg-8">
            <!-- Tracking Card -->
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0">Fulfillment Progress</h5>
                    <span class="badge bg-primary bg-opacity-10 text-primary rounded-pill px-3 py-1 fw-bold font-monospace">Status: ${order.orderStatus}</span>
                </div>
                <div class="p-4 bg-light rounded-4 mb-2">
                    <div class="row text-center g-2 position-relative">
                        <div class="col-3">
                            <div class="d-inline-flex p-2 rounded-circle bg-success text-white mb-1 shadow-xs">
                                <i class="bi bi-check-lg fs-5"></i>
                            </div>
                            <div class="small fw-bold text-dark mt-1">Confirmed</div>
                            <div class="text-muted" style="font-size: 0.72rem;">Order Logged</div>
                        </div>
                        <div class="col-3">
                            <div class="d-inline-flex p-2 rounded-circle ${order.orderStatus == 'SHIPPED' or order.orderStatus == 'DELIVERED' ? 'bg-success text-white' : 'bg-secondary bg-opacity-25 text-muted'} mb-1 shadow-xs">
                                <i class="bi bi-box-seam-fill fs-5"></i>
                            </div>
                            <div class="small fw-bold ${order.orderStatus == 'SHIPPED' or order.orderStatus == 'DELIVERED' ? 'text-dark' : 'text-muted'} mt-1">Packed</div>
                            <div class="text-muted" style="font-size: 0.72rem;">Warehouse Ready</div>
                        </div>
                        <div class="col-3">
                            <div class="d-inline-flex p-2 rounded-circle ${order.orderStatus == 'SHIPPED' or order.orderStatus == 'DELIVERED' ? 'bg-success text-white' : 'bg-secondary bg-opacity-25 text-muted'} mb-1 shadow-xs">
                                <i class="bi bi-truck fs-5"></i>
                            </div>
                            <div class="small fw-bold ${order.orderStatus == 'SHIPPED' or order.orderStatus == 'DELIVERED' ? 'text-dark' : 'text-muted'} mt-1">In Transit</div>
                            <div class="text-muted" style="font-size: 0.72rem;">Courier Dispatched</div>
                        </div>
                        <div class="col-3">
                            <div class="d-inline-flex p-2 rounded-circle ${order.orderStatus == 'DELIVERED' ? 'bg-success text-white' : 'bg-secondary bg-opacity-25 text-muted'} mb-1 shadow-xs">
                                <i class="bi bi-house-check-fill fs-5"></i>
                            </div>
                            <div class="small fw-bold ${order.orderStatus == 'DELIVERED' ? 'text-dark' : 'text-muted'} mt-1">Delivered</div>
                            <div class="text-muted" style="font-size: 0.72rem;">Delivered to Door</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Items List -->
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                <h5 class="fw-bold mb-3">Line Items</h5>
                <div class="table-responsive">
                    <table class="table align-middle mb-0">
                        <thead class="table-light small text-uppercase text-muted fw-bold">
                            <tr>
                                <th class="border-0">Product</th>
                                <th class="border-0">Unit Price</th>
                                <th class="border-0 text-center">Qty</th>
                                <th class="border-0 text-end">Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${order.items}">
                                <tr class="border-top">
                                    <td class="py-3">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="rounded-3 overflow-hidden border bg-light d-flex align-items-center justify-content-center flex-shrink-0" style="width: 58px; height: 58px;">
                                                <img src="${item.product.imageUrl != null ? item.product.imageUrl : pageContext.request.contextPath.concat('/assets/img/product-placeholder.svg')}"
                                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/product-placeholder.svg';"
                                                     alt="${item.product.name}" class="img-fluid" style="width: 100%; height: 100%; object-fit: cover;">
                                            </div>
                                            <div>
                                                <h6 class="mb-0 fw-bold">
                                                    <a href="${pageContext.request.contextPath}/product-details?id=${item.productId}" class="text-decoration-none text-dark hover-primary">
                                                        ${item.product.name}
                                                    </a>
                                                </h6>
                                                <span class="text-muted small">${item.product.brand}</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="py-3 font-monospace fw-semibold">₹<fmt:formatNumber value="${item.price}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    <td class="py-3 text-center fw-bold">${item.quantity}</td>
                                    <td class="py-3 text-end fw-black text-dark font-monospace">₹<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Sidebar Info -->
        <div class="col-lg-4">
            <!-- Payment & Summary -->
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                <h5 class="fw-bold mb-3">Settlement Summary</h5>
                <div class="d-flex justify-content-between mb-2 small text-secondary">
                    <span>Subtotal</span>
                    <span class="fw-bold text-dark font-monospace">₹<fmt:formatNumber value="${order.totalAmount}" minFractionDigits="2" maxFractionDigits="2"/></span>
                </div>
                <c:if test="${order.discount > 0}">
                    <div class="d-flex justify-content-between mb-2 small text-success">
                        <span>Coupon Discount</span>
                        <span class="fw-bold font-monospace">-₹<fmt:formatNumber value="${order.discount}" minFractionDigits="2" maxFractionDigits="2"/></span>
                    </div>
                </c:if>
                <div class="d-flex justify-content-between mb-3 small text-secondary">
                    <span>Shipping Charges</span>
                    <span class="fw-bold">
                        <c:choose>
                            <c:when test="${order.shippingFee == 0}">
                                <span class="badge bg-success bg-opacity-25 text-success fw-bold">FREE</span>
                            </c:when>
                            <c:otherwise>
                                <span class="font-monospace">₹<fmt:formatNumber value="${order.shippingFee}" minFractionDigits="2" maxFractionDigits="2"/></span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <hr class="my-3 border-secondary-subtle">
                <div class="d-flex justify-content-between align-items-baseline mb-4">
                    <span class="fw-bold fs-5">Total Paid</span>
                    <span class="fs-2 fw-black text-primary font-monospace">₹<fmt:formatNumber value="${order.finalAmount}" minFractionDigits="2" maxFractionDigits="2"/></span>
                </div>

                <div class="p-3 bg-light rounded-3 small">
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Payment Channel:</span>
                        <span class="badge bg-secondary text-uppercase">${order.paymentMethod}</span>
                    </div>
                    <div class="d-flex justify-content-between">
                        <span class="text-muted">Payment Status:</span>
                        <span class="badge bg-success bg-opacity-25 text-success fw-bold">${order.paymentStatus}</span>
                    </div>
                </div>
            </div>

            <!-- Shipping Address -->
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                <h5 class="fw-bold mb-3 d-flex align-items-center gap-2">
                    <i class="bi bi-geo-alt-fill text-danger"></i> Shipping Destination
                </h5>
                <c:choose>
                    <c:when test="${not empty order.address}">
                        <span class="badge bg-secondary text-uppercase mb-2 small" style="width: fit-content;">${order.address.addressType}</span>
                        <div class="text-dark fw-bold mb-1">${order.address.addressLine}</div>
                        <div class="text-muted small">${order.address.city}, ${order.address.state} - <span class="font-monospace fw-semibold">${order.address.pincode}</span></div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted small mb-0">Standard fulfillment verified shipping destination.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/fragments/footer.jsp"/>
