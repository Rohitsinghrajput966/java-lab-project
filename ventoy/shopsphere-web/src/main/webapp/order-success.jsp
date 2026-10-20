<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Order Confirmed" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/navbar.jsp"/>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white text-center mb-4">
                <div class="mb-3">
                    <div class="d-inline-flex p-3 rounded-circle bg-success bg-opacity-10 text-success mb-2">
                        <i class="bi bi-check-circle-fill display-4"></i>
                    </div>
                </div>
                <h2 class="fw-black text-dark mb-1 display-6 fw-bold">Thank You! Order Confirmed</h2>
                <p class="text-muted mb-4">We've received your order and our fulfillment team is preparing your package.</p>

                <div class="p-3 bg-light rounded-4 d-inline-block mx-auto mb-4 px-4 text-start w-100" style="max-width: 520px;">
                    <div class="d-flex justify-content-between gap-5 mb-2">
                        <span class="text-muted small">Order Number:</span>
                        <span class="fw-bold font-monospace text-primary">#VNT-${order.orderId}</span>
                    </div>
                    <div class="d-flex justify-content-between gap-5 mb-2">
                        <span class="text-muted small">Placed On:</span>
                        <span class="fw-semibold small"><fmt:formatDate value="${order.createdAt}" pattern="dd MMM yyyy, hh:mm a"/></span>
                    </div>
                    <div class="d-flex justify-content-between gap-5 mb-2">
                        <span class="text-muted small">Payment Channel:</span>
                        <span class="badge bg-secondary text-uppercase">${order.paymentMethod}</span>
                    </div>
                    <div class="d-flex justify-content-between gap-5">
                        <span class="text-muted small">Total Paid:</span>
                        <span class="fw-black text-dark font-monospace fs-6">₹<fmt:formatNumber value="${order.finalAmount}" minFractionDigits="2" maxFractionDigits="2"/></span>
                    </div>
                </div>

                <!-- Order Status Tracker -->
                <div class="card border rounded-4 p-4 text-start mb-4 bg-white shadow-2xs">
                    <h6 class="fw-bold mb-3 d-flex align-items-center gap-2">
                        <i class="bi bi-geo-alt-fill text-primary"></i> Live Order Tracking
                    </h6>
                    <div class="row text-center position-relative g-2">
                        <div class="col-3">
                            <i class="bi bi-check2-circle fs-3 text-success"></i>
                            <div class="small fw-bold text-dark mt-1">Confirmed</div>
                            <div class="text-muted" style="font-size: 0.72rem;">Just now</div>
                        </div>
                        <div class="col-3">
                            <i class="bi bi-box-seam fs-3 ${order.orderStatus == 'SHIPPED' or order.orderStatus == 'DELIVERED' ? 'text-success' : 'text-muted'}"></i>
                            <div class="small fw-bold ${order.orderStatus == 'SHIPPED' or order.orderStatus == 'DELIVERED' ? 'text-dark' : 'text-muted'} mt-1">Packed</div>
                            <div class="text-muted" style="font-size: 0.72rem;">In Progress</div>
                        </div>
                        <div class="col-3">
                            <i class="bi bi-truck fs-3 ${order.orderStatus == 'SHIPPED' or order.orderStatus == 'DELIVERED' ? 'text-success' : 'text-muted'}"></i>
                            <div class="small fw-bold ${order.orderStatus == 'SHIPPED' or order.orderStatus == 'DELIVERED' ? 'text-dark' : 'text-muted'} mt-1">Shipped</div>
                            <div class="text-muted" style="font-size: 0.72rem;">Pending</div>
                        </div>
                        <div class="col-3">
                            <i class="bi bi-house-door fs-3 ${order.orderStatus == 'DELIVERED' ? 'text-success' : 'text-muted'}"></i>
                            <div class="small fw-bold ${order.orderStatus == 'DELIVERED' ? 'text-dark' : 'text-muted'} mt-1">Delivered</div>
                            <div class="text-muted" style="font-size: 0.72rem;">Est. 2-3 Days</div>
                        </div>
                    </div>
                </div>

                <div class="d-flex flex-wrap justify-content-center gap-3">
                    <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-dark rounded-pill px-4 py-2 fw-semibold">
                        <i class="bi bi-card-list me-1"></i> View Order History
                    </a>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill px-5 py-2 fw-bold shadow">
                        Continue Shopping <i class="bi bi-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/fragments/footer.jsp"/>
