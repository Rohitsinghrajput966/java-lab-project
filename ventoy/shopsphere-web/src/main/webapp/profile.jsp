<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="My Profile" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/navbar.jsp"/>

<div class="container my-5">
    <!-- Header Banner -->
    <div class="card border-0 rounded-4 p-4 mb-4 text-white shadow-sm" style="background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 60%, #312e81 100%);">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
            <div class="d-flex align-items-center gap-3">
                <div class="rounded-circle bg-white text-dark d-flex align-items-center justify-content-center fw-bold fs-3 shadow" style="width: 68px; height: 68px;">
                    ${profileUser.name.substring(0, 1).toUpperCase()}
                </div>
                <div>
                    <div class="d-flex align-items-center gap-2">
                        <h3 class="fw-black mb-0">${profileUser.name}</h3>
                        <span class="badge bg-primary rounded-pill px-3 py-1 font-monospace" style="font-size: 0.75rem;">${profileUser.role}</span>
                    </div>
                    <p class="text-white-50 small mb-0 mt-1">
                        <i class="bi bi-envelope me-1"></i> ${profileUser.email}
                        <c:if test="${not empty profileUser.mobile}"> | <i class="bi bi-telephone ms-1 me-1"></i> ${profileUser.mobile}</c:if>
                    </p>
                </div>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-light rounded-pill px-3 py-2 btn-sm fw-semibold">
                    <i class="bi bi-box-seam me-1"></i> View Orders
                </a>
                <a href="${pageContext.request.contextPath}/wishlist" class="btn btn-light rounded-pill px-3 py-2 btn-sm fw-semibold text-dark">
                    <i class="bi bi-heart me-1"></i> Wishlist
                </a>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- Personal Information -->
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4 h-100">
                <h5 class="fw-bold mb-3 d-flex align-items-center gap-2">
                    <i class="bi bi-person-gear text-primary"></i> Personal Details &amp; Password
                </h5>

                <form action="${pageContext.request.contextPath}/profile" method="post">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">Account Email (Immutable)</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-envelope"></i></span>
                            <input type="email" class="form-control rounded-end-3 bg-light" value="${profileUser.email}" readonly>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">Full Display Name</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-person"></i></span>
                            <input type="text" name="name" class="form-control rounded-end-3" value="${profileUser.name}" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">Mobile Contact</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-phone"></i></span>
                            <input type="text" name="mobile" class="form-control rounded-end-3" value="${profileUser.mobile}" placeholder="+91 98765 43210">
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label small fw-semibold text-secondary">Change Password <span class="text-muted fw-normal">(Leave empty to retain existing)</span></label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-key"></i></span>
                            <input type="password" name="newPassword" class="form-control rounded-end-3" placeholder="Enter new strong password">
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold shadow-sm">
                        <i class="bi bi-check2 me-1"></i> Update Profile Information
                    </button>
                </form>
            </div>
        </div>

        <!-- Address Book -->
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                <h5 class="fw-bold mb-3 d-flex align-items-center gap-2">
                    <i class="bi bi-geo-alt-fill text-danger"></i> Saved Shipping Addresses
                </h5>

                <c:choose>
                    <c:when test="${not empty addresses}">
                        <div class="d-flex flex-column gap-3 mb-4">
                            <c:forEach var="addr" items="${addresses}">
                                <div class="p-3 border rounded-3 bg-light d-flex justify-content-between align-items-center shadow-2xs hover-border-primary">
                                    <div>
                                        <div class="d-flex align-items-center gap-2 mb-1">
                                            <span class="badge bg-secondary text-uppercase" style="font-size: 0.7rem;">${addr.addressType}</span>
                                            <c:if test="${addr['default']}"><span class="badge bg-success bg-opacity-25 text-success small">Default</span></c:if>
                                        </div>
                                        <div class="fw-bold text-dark">${addr.addressLine}</div>
                                        <div class="text-muted small">${addr.city}, ${addr.state} - <span class="font-monospace fw-semibold">${addr.pincode}</span></div>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/address/delete" method="post" onsubmit="return confirm('Delete this saved address?');" class="m-0">
                                        <input type="hidden" name="addressId" value="${addr.addressId}">
                                        <button type="submit" class="btn btn-outline-danger btn-sm rounded-circle p-2 shadow-2xs" title="Remove address">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-light border rounded-3 p-3 text-muted small mb-4">
                            <i class="bi bi-info-circle me-1"></i> No delivery destinations saved. Create one below for 1-click checkout!
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- Add New Address Form -->
                <div class="p-4 bg-light rounded-4 border">
                    <h6 class="fw-bold mb-3 text-dark d-flex align-items-center gap-2">
                        <i class="bi bi-plus-circle text-primary"></i> Add New Delivery Destination
                    </h6>
                    <form action="${pageContext.request.contextPath}/address/add" method="post">
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-secondary">Address Line</label>
                            <input type="text" name="addressLine" class="form-control rounded-3 form-control-sm" placeholder="Street, Flat, Building name" required>
                        </div>
                        <div class="row g-2 mb-3">
                            <div class="col-md-5">
                                <label class="form-label small fw-semibold text-secondary">City</label>
                                <input type="text" name="city" class="form-control rounded-3 form-control-sm" placeholder="City" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold text-secondary">State</label>
                                <input type="text" name="state" class="form-control rounded-3 form-control-sm" placeholder="State" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label small fw-semibold text-secondary">Pincode</label>
                                <input type="text" name="pincode" class="form-control rounded-3 form-control-sm" placeholder="Pincode" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-secondary">Address Type</label>
                            <select name="addressType" class="form-select rounded-3 form-select-sm">
                                <option value="HOME">Home</option>
                                <option value="WORK">Office / Commercial</option>
                                <option value="BILLING">Billing Only</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-outline-primary btn-sm rounded-pill px-4 py-2 fw-semibold shadow-2xs">
                            <i class="bi bi-save me-1"></i> Save Address
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/fragments/footer.jsp"/>
