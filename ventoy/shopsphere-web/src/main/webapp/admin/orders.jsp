<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Order Fulfillment Management" scope="request"/>
<c:set var="activeTab" value="orders" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/admin-navbar.jsp"/>

<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-2 pb-3 mb-4 border-bottom">
    <div>
        <h1 class="h2 fw-extrabold text-dark mb-1">Order Fulfillment &amp; Invoices</h1>
        <p class="text-muted small mb-0">${orders.size()} customer orders in database</p>
    </div>
</div>

<!-- Search & Filtering Toolbar -->
<div class="card border-0 shadow-sm rounded-4 p-3 bg-white mb-4">
    <form action="${pageContext.request.contextPath}/admin/orders" method="get" class="row g-2 align-items-center">
        <div class="col-md-5">
            <div class="input-group">
                <span class="input-group-text bg-light border-end-0 rounded-start-pill text-muted"><i class="bi bi-search"></i></span>
                <input type="text" name="q" value="${searchQuery}" class="form-control bg-light border-start-0 rounded-end-pill shadow-none" placeholder="Search by Order # or customer name/email...">
            </div>
        </div>

        <div class="col-md-3">
            <select name="status" class="form-select rounded-pill shadow-none" onchange="this.form.submit()">
                <option value="ALL">All Order Statuses</option>
                <option value="PENDING" ${selectedStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                <option value="CONFIRMED" ${selectedStatus == 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
                <option value="SHIPPED" ${selectedStatus == 'SHIPPED' ? 'selected' : ''}>Shipped</option>
                <option value="DELIVERED" ${selectedStatus == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                <option value="CANCELLED" ${selectedStatus == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
            </select>
        </div>

        <div class="col-md-2">
            <select name="payment" class="form-select rounded-pill shadow-none" onchange="this.form.submit()">
                <option value="ALL">All Payments</option>
                <option value="PAID" ${selectedPayment == 'PAID' ? 'selected' : ''}>Paid</option>
                <option value="PENDING" ${selectedPayment == 'PENDING' ? 'selected' : ''}>Pending</option>
                <option value="REFUNDED" ${selectedPayment == 'REFUNDED' ? 'selected' : ''}>Refunded</option>
            </select>
        </div>

        <div class="col-md-2 d-flex gap-2">
            <button type="submit" class="btn btn-dark rounded-pill w-100 fw-semibold">Filter</button>
            <c:if test="${not empty searchQuery or (not empty selectedStatus and selectedStatus != 'ALL') or (not empty selectedPayment and selectedPayment != 'ALL')}">
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary rounded-pill" title="Reset Filters"><i class="bi bi-x-lg"></i></a>
            </c:if>
        </div>
    </form>
</div>

<!-- Orders Table -->
<div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white mb-4">
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light small text-uppercase text-muted">
                <tr>
                    <th class="ps-4">Order ID</th>
                    <th>Customer</th>
                    <th>Amount (₹)</th>
                    <th>Payment</th>
                    <th>Fulfillment Status</th>
                    <th>Date Placed</th>
                    <th class="pe-4 text-end">Update Order</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="ord" items="${orders}">
                    <tr>
                        <td class="ps-4 font-monospace fw-bold text-primary">
                            #SPH-${ord.orderId}
                        </td>
                        <td>
                            <div class="fw-bold text-dark">${ord.userName}</div>
                            <span class="text-muted small">${ord.userEmail}</span>
                        </td>
                        <td class="fw-extrabold text-dark">
                            ₹<fmt:formatNumber value="${ord.finalAmount}" minFractionDigits="2" maxFractionDigits="2"/>
                            <c:if test="${ord.discount > 0}">
                                <span class="badge bg-success bg-opacity-10 text-success rounded-pill d-block small mt-1">Saved ₹<fmt:formatNumber value="${ord.discount}" minFractionDigits="2" maxFractionDigits="2"/></span>
                            </c:if>
                        </td>
                        <td>
                            <span class="badge ${ord.paymentStatus == 'PAID' ? 'bg-success bg-opacity-10 text-success border border-success border-opacity-25' : (ord.paymentStatus == 'REFUNDED' ? 'bg-danger bg-opacity-10 text-danger border' : 'bg-warning bg-opacity-10 text-dark border')} fw-bold">
                                ${ord.paymentStatus}
                            </span>
                            <span class="text-muted small d-block mt-0.5">${ord.paymentMethod}</span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${ord.orderStatus == 'DELIVERED'}">
                                    <span class="badge bg-success bg-opacity-15 text-success rounded-pill px-2.5 py-1 fw-bold">Delivered</span>
                                </c:when>
                                <c:when test="${ord.orderStatus == 'SHIPPED'}">
                                    <span class="badge bg-info bg-opacity-15 text-info rounded-pill px-2.5 py-1 fw-bold">In Transit</span>
                                </c:when>
                                <c:when test="${ord.orderStatus == 'CONFIRMED'}">
                                    <span class="badge bg-primary bg-opacity-15 text-primary rounded-pill px-2.5 py-1 fw-bold">Confirmed</span>
                                </c:when>
                                <c:when test="${ord.orderStatus == 'CANCELLED'}">
                                    <span class="badge bg-danger bg-opacity-15 text-danger rounded-pill px-2.5 py-1 fw-bold">Cancelled</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-warning bg-opacity-15 text-dark rounded-pill px-2.5 py-1 fw-bold">Pending</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="small text-muted">
                            <fmt:formatDate value="${ord.createdAt}" pattern="dd MMM yyyy, hh:mm a"/>
                        </td>
                        <td class="pe-4 text-end">
                            <form action="${pageContext.request.contextPath}/admin/orders/update-status" method="post" class="d-inline-flex gap-1.5 align-items-center justify-content-end">
                                <input type="hidden" name="orderId" value="${ord.orderId}">
                                <select name="orderStatus" class="form-select form-select-sm rounded-pill shadow-none" style="width: 125px;">
                                    <option value="PENDING" ${ord.orderStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                                    <option value="CONFIRMED" ${ord.orderStatus == 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
                                    <option value="SHIPPED" ${ord.orderStatus == 'SHIPPED' ? 'selected' : ''}>Shipped</option>
                                    <option value="DELIVERED" ${ord.orderStatus == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                                    <option value="CANCELLED" ${ord.orderStatus == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                </select>
                                <select name="paymentStatus" class="form-select form-select-sm rounded-pill shadow-none" style="width: 110px;">
                                    <option value="PAID" ${ord.paymentStatus == 'PAID' ? 'selected' : ''}>Paid</option>
                                    <option value="PENDING" ${ord.paymentStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                                    <option value="REFUNDED" ${ord.paymentStatus == 'REFUNDED' ? 'selected' : ''}>Refunded</option>
                                </select>
                                <button type="submit" class="btn btn-sm btn-dark rounded-pill px-3 fw-semibold">Save</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/fragments/admin-footer.jsp"/>
