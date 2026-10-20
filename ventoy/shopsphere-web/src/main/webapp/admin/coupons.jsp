<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Promotional Coupons" scope="request"/>
<c:set var="activeTab" value="coupons" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/admin-navbar.jsp"/>

<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-2 pb-3 mb-4 border-bottom">
    <div>
        <h1 class="h2 fw-extrabold text-dark mb-1">Promotional Coupons &amp; Discount Engine</h1>
        <p class="text-muted small mb-0">${coupons.size()} promotional discount codes configured</p>
    </div>
</div>

<!-- Search Bar -->
<div class="card border-0 shadow-sm rounded-4 p-3 bg-white mb-4">
    <form action="${pageContext.request.contextPath}/admin/coupons" method="get" class="row g-2 align-items-center">
        <div class="col-md-9">
            <div class="input-group">
                <span class="input-group-text bg-light border-end-0 rounded-start-pill text-muted"><i class="bi bi-search"></i></span>
                <input type="text" name="q" value="${searchQuery}" class="form-control bg-light border-start-0 rounded-end-pill shadow-none" placeholder="Search by coupon code (e.g. WELCOME10, FLAT20)...">
            </div>
        </div>
        <div class="col-md-3 d-flex gap-2">
            <button type="submit" class="btn btn-dark rounded-pill w-100 fw-semibold">Search</button>
            <c:if test="${not empty searchQuery}">
                <a href="${pageContext.request.contextPath}/admin/coupons" class="btn btn-outline-secondary rounded-pill"><i class="bi bi-x-lg"></i></a>
            </c:if>
        </div>
    </form>
</div>

<div class="row g-4 mb-4">
    <!-- Coupons List Table -->
    <div class="col-lg-8">
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light small text-uppercase text-muted">
                        <tr>
                            <th class="ps-4">Code</th>
                            <th>Discount</th>
                            <th>Min Order (₹)</th>
                            <th>Status</th>
                            <th class="pe-4 text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${coupons}">
                            <tr>
                                <td class="ps-4 py-3">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="badge bg-light text-primary border font-monospace fs-6 px-3 py-1.5">${c.code}</span>
                                        <button type="button" class="btn btn-sm btn-light border rounded-circle p-1 text-muted" title="Copy Code" onclick="navigator.clipboard.writeText('${c.code}'); alert('Copied ${c.code} to clipboard!');">
                                            <i class="bi bi-copy"></i>
                                        </button>
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${c.discountType == 'PERCENTAGE'}">
                                            <span class="fw-extrabold text-success fs-6">${c.discountValue}% OFF</span>
                                            <c:if test="${not empty c.maximumDiscount}">
                                                <span class="text-muted small d-block">Max ₹${c.maximumDiscount}</span>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="fw-extrabold text-success fs-6">Flat ₹${c.discountValue} OFF</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="fw-semibold">₹<fmt:formatNumber value="${c.minimumOrder}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin/coupons/toggle" method="post" class="d-inline">
                                        <input type="hidden" name="couponId" value="${c.couponId}">
                                        <input type="hidden" name="status" value="${c.status}">
                                        <button type="submit" class="btn btn-sm rounded-pill px-3 py-1 fw-semibold ${c.status ? 'btn-success bg-opacity-10 text-success border border-success border-opacity-25' : 'btn-secondary bg-opacity-25 text-secondary border'}" title="Toggle status">
                                            <i class="bi bi-circle-fill me-1" style="font-size: 0.5rem;"></i>
                                            ${c.status ? 'Active' : 'Disabled'}
                                        </button>
                                    </form>
                                </td>
                                <td class="pe-4 text-end">
                                    <div class="d-inline-flex gap-1.5">
                                        <button type="button" class="btn btn-sm btn-outline-secondary rounded-circle" data-bs-toggle="modal" data-bs-target="#editCouponModal_${c.couponId}" title="Edit Coupon">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <form action="${pageContext.request.contextPath}/admin/coupons/delete" method="post" class="d-inline" onsubmit="return confirm('Delete coupon ${c.code}?');">
                                            <input type="hidden" name="couponId" value="${c.couponId}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger rounded-circle" title="Delete Coupon">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </div>

                                    <!-- Edit Coupon Modal -->
                                    <div class="modal fade text-start" id="editCouponModal_${c.couponId}" tabindex="-1" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content rounded-4 border-0 shadow-lg">
                                                <div class="modal-header border-bottom">
                                                    <h5 class="modal-title fw-bold">Edit Coupon: ${c.code}</h5>
                                                    <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <form action="${pageContext.request.contextPath}/admin/coupons/edit" method="post">
                                                    <input type="hidden" name="couponId" value="${c.couponId}">
                                                    <div class="modal-body p-4">
                                                        <div class="mb-3">
                                                            <label class="form-label small fw-semibold">Coupon Code</label>
                                                            <input type="text" name="code" class="form-control rounded-3 text-uppercase font-monospace" value="${c.code}" required>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label small fw-semibold">Discount Type</label>
                                                            <select name="discountType" class="form-select rounded-3">
                                                                <option value="PERCENTAGE" ${c.discountType == 'PERCENTAGE' ? 'selected' : ''}>Percentage (%)</option>
                                                                <option value="FIXED" ${c.discountType == 'FIXED' ? 'selected' : ''}>Flat Fixed Amount (₹)</option>
                                                            </select>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label small fw-semibold">Discount Value</label>
                                                            <input type="number" step="0.01" name="discountValue" class="form-control rounded-3" value="${c.discountValue}" required>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label small fw-semibold">Minimum Order Requirement (₹)</label>
                                                            <input type="number" step="0.01" name="minimumOrder" class="form-control rounded-3" value="${c.minimumOrder}" required>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label small fw-semibold">Maximum Discount Cap (₹ optional)</label>
                                                            <input type="number" step="0.01" name="maximumDiscount" class="form-control rounded-3" value="${c.maximumDiscount}">
                                                        </div>
                                                        <div class="form-check form-switch">
                                                            <input class="form-check-input" type="checkbox" name="status" id="couponStatus_${c.couponId}" ${c.status ? 'checked' : ''}>
                                                            <label class="form-check-label fw-semibold" for="couponStatus_${c.couponId}">Coupon Active</label>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer border-top bg-light rounded-bottom-4">
                                                        <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                                                        <button type="submit" class="btn btn-primary rounded-pill px-4 fw-semibold shadow-xs">Save Changes</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Create Coupon Card -->
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
            <h5 class="fw-bold mb-3 d-flex align-items-center gap-2">
                <i class="bi bi-tag-fill text-primary"></i> Create Coupon
            </h5>
            <form action="${pageContext.request.contextPath}/admin/coupons/add" method="post">
                <div class="mb-3">
                    <label class="form-label small fw-semibold">Coupon Code</label>
                    <input type="text" name="code" class="form-control rounded-3 text-uppercase font-monospace" placeholder="e.g. VIP25" required>
                </div>
                <div class="mb-3">
                    <label class="form-label small fw-semibold">Discount Type</label>
                    <select name="discountType" class="form-select rounded-3">
                        <option value="PERCENTAGE">Percentage (%)</option>
                        <option value="FIXED">Flat Fixed Amount (₹)</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label small fw-semibold">Discount Value</label>
                    <input type="number" step="0.01" name="discountValue" class="form-control rounded-3" placeholder="e.g. 15 or 50.00" required>
                </div>
                <div class="mb-3">
                    <label class="form-label small fw-semibold">Minimum Order Requirement (₹)</label>
                    <input type="number" step="0.01" name="minimumOrder" class="form-control rounded-3" placeholder="e.g. 50.00" required>
                </div>
                <div class="mb-3">
                    <label class="form-label small fw-semibold">Maximum Discount Cap (optional)</label>
                    <input type="number" step="0.01" name="maximumDiscount" class="form-control rounded-3" placeholder="e.g. 100.00">
                </div>
                <button type="submit" class="btn btn-primary rounded-pill w-100 fw-bold shadow-xs py-2">
                    Activate Coupon
                </button>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/fragments/admin-footer.jsp"/>
