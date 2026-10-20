<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="My Orders" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/navbar.jsp"/>

<div class="container my-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-3 border-bottom gap-3">
        <div>
            <div class="d-flex align-items-center gap-2">
                <span class="badge bg-primary bg-opacity-10 text-primary rounded-pill px-3 py-2 fw-semibold">
                    <i class="bi bi-box2-heart me-1"></i> Purchase History
                </span>
                <span class="text-muted small">|</span>
                <span class="text-muted small">${orders != null ? orders.size() : 0} recorded order(s)</span>
            </div>
            <h2 class="fw-black tracking-tight mb-0 mt-2 display-6 fw-bold">My Orders</h2>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-dark rounded-pill px-4 py-2 fw-semibold d-inline-flex align-items-center gap-2">
                <i class="bi bi-cart-plus"></i> Shop More Items
            </a>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty orders}">
            <div class="d-flex flex-column gap-4">
                <c:forEach var="ord" items="${orders}">
                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
                        <div class="card-header bg-light py-3 px-4 border-bottom border-light-subtle">
                            <div class="row align-items-center g-3">
                                <div class="col-6 col-md-3">
                                    <span class="text-muted small d-block">Order Reference</span>
                                    <span class="fw-bold text-dark font-monospace">#VNT-${ord.orderId}</span>
                                </div>
                                <div class="col-6 col-md-3">
                                    <span class="text-muted small d-block">Date Placed</span>
                                    <span class="fw-semibold text-dark small"><fmt:formatDate value="${ord.createdAt}" pattern="dd MMM yyyy, hh:mm a"/></span>
                                </div>
                                <div class="col-6 col-md-3">
                                    <span class="text-muted small d-block">Total Paid</span>
                                    <span class="fw-black text-primary font-monospace fs-6">₹<fmt:formatNumber value="${ord.finalAmount}" minFractionDigits="2" maxFractionDigits="2"/></span>
                                </div>
                                <div class="col-6 col-md-3 text-end d-flex align-items-center justify-content-end gap-2">
                                    <c:choose>
                                        <c:when test="${ord.orderStatus == 'DELIVERED'}">
                                            <span class="badge bg-success bg-opacity-25 text-success rounded-pill px-3 py-2 fw-bold">
                                                <i class="bi bi-check2-circle me-1"></i> Delivered
                                            </span>
                                        </c:when>
                                        <c:when test="${ord.orderStatus == 'CANCELLED'}">
                                            <span class="badge bg-danger bg-opacity-25 text-danger rounded-pill px-3 py-2 fw-bold">
                                                <i class="bi bi-x-circle me-1"></i> Cancelled
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-primary bg-opacity-25 text-primary rounded-pill px-3 py-2 fw-bold">
                                                <i class="bi bi-truck me-1"></i> ${ord.orderStatus}
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="${pageContext.request.contextPath}/order-details?id=${ord.orderId}" class="btn btn-primary btn-sm rounded-pill px-3 py-2 fw-semibold shadow-2xs">
                                        Details <i class="bi bi-arrow-right ms-1"></i>
                                    </a>
                                </div>
                            </div>
                        </div>

                        <div class="card-body p-4">
                            <div class="d-flex flex-column gap-3">
                                <c:forEach var="item" items="${ord.items}">
                                    <div class="d-flex align-items-center justify-content-between p-2 rounded-3 hover-bg-light transition">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="rounded-3 overflow-hidden border bg-light d-flex align-items-center justify-content-center flex-shrink-0" style="width: 58px; height: 58px;">
                                                <img src="${item.product.imageUrl != null ? item.product.imageUrl : pageContext.request.contextPath.concat('/assets/img/product-placeholder.svg')}"
                                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/product-placeholder.svg';"
                                                     alt="${item.product.name}" class="img-fluid" style="width: 100%; height: 100%; object-fit: cover;">
                                            </div>
                                            <div>
                                                <h6 class="mb-1 fw-bold">
                                                    <a href="${pageContext.request.contextPath}/product-details?id=${item.productId}" class="text-decoration-none text-dark hover-primary">
                                                        ${item.product.name}
                                                    </a>
                                                </h6>
                                                <span class="text-muted small">
                                                    <span class="badge bg-light text-muted border rounded-pill me-1">${item.product.brand}</span>
                                                    Qty: ${item.quantity} × ₹<fmt:formatNumber value="${item.price}" minFractionDigits="2" maxFractionDigits="2"/>
                                                </span>
                                            </div>
                                        </div>
                                        <span class="fw-bold text-dark font-monospace fs-6">₹<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" maxFractionDigits="2"/></span>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center py-5 bg-white rounded-4 border shadow-sm my-4 p-5">
                <div class="d-inline-flex p-4 rounded-circle bg-primary bg-opacity-10 text-primary mb-3">
                    <i class="bi bi-bag-x display-4"></i>
                </div>
                <h4 class="fw-bold text-dark">No Orders Found</h4>
                <p class="text-muted mb-4 mx-auto" style="max-width: 440px;">You haven't placed any orders yet. Discover high-quality tech gear, accessories, and audio products today!</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill px-5 py-3 fw-bold shadow">
                    Browse All Products
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/fragments/footer.jsp"/>
