<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-dark bg-dark sticky-top py-2.5 px-3 border-bottom border-secondary border-opacity-25 shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand d-flex align-items-center gap-2.5 fw-bold" href="${pageContext.request.contextPath}/admin/dashboard">
            <img src="${pageContext.request.contextPath}/assets/img/shopsphere-logo-light.svg"
                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/shopsphere-logo-light.svg';"
                 alt="ShopSphere" style="height: 32px; width: auto; object-fit: contain;">
            <span class="badge bg-warning text-dark font-monospace px-2 py-0.5 rounded-pill" style="font-size: 0.72rem; letter-spacing: 0.5px;">ADMIN CENTER</span>
        </a>

        <div class="d-flex align-items-center gap-3">
            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-light btn-sm rounded-pill px-3 shadow-xs" target="_blank">
                <i class="bi bi-box-arrow-up-right me-1"></i> Storefront
            </a>

            <div class="dropdown">
                <button class="btn btn-dark btn-sm dropdown-toggle rounded-pill px-3 py-1.5 border border-secondary border-opacity-50 d-flex align-items-center gap-2" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <div class="bg-warning text-dark rounded-circle d-flex align-items-center justify-content-center fw-bold" style="width: 24px; height: 24px; font-size: 0.75rem;">
                        <i class="bi bi-shield-fill-check"></i>
                    </div>
                    <span class="small fw-semibold">${sessionScope.user.name}</span>
                </button>
                <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-4 p-2 mt-2" style="min-width: 180px;">
                    <li class="px-3 py-1 text-muted small"><i class="bi bi-person me-1"></i> ${sessionScope.user.email}</li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item py-2 rounded-3 text-danger fw-semibold" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Sign Out</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<div class="container-fluid">
    <div class="row">
        <!-- Admin Sidebar Nav -->
        <div class="col-md-3 col-lg-2 d-md-block bg-dark admin-sidebar collapse p-3">
            <div class="position-sticky pt-2">
                <h6 class="sidebar-heading px-3 mt-2 mb-3 text-secondary text-uppercase small fw-bold" style="letter-spacing: 1.5px; font-size: 0.72rem;">Operations</h6>
                <ul class="nav flex-column gap-1">
                    <li class="nav-item">
                        <a class="admin-nav-link ${activeTab == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="bi bi-speedometer2"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="admin-nav-link ${activeTab == 'products' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/products">
                            <i class="bi bi-box-seam"></i> Products Catalog
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="admin-nav-link ${activeTab == 'categories' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/categories">
                            <i class="bi bi-tags"></i> Categories
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="admin-nav-link ${activeTab == 'orders' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/orders">
                            <i class="bi bi-receipt"></i> Orders &amp; Invoices
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="admin-nav-link ${activeTab == 'customers' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/customers">
                            <i class="bi bi-people"></i> Customers
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="admin-nav-link ${activeTab == 'coupons' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/coupons">
                            <i class="bi bi-percent"></i> Discounts &amp; Coupons
                        </a>
                    </li>
                </ul>

                <h6 class="sidebar-heading px-3 mt-4 mb-3 text-secondary text-uppercase small fw-bold" style="letter-spacing: 1.5px; font-size: 0.72rem;">Engine Status</h6>
                <div class="p-3 bg-secondary bg-opacity-10 rounded-4 border border-secondary border-opacity-25 small">
                    <div class="d-flex justify-content-between mb-1.5">
                        <span class="text-secondary">Release:</span>
                        <span class="text-white fw-bold">1.0.0 LTS</span>
                    </div>
                    <div class="d-flex justify-content-between mb-1.5">
                        <span class="text-secondary">DB Pool:</span>
                        <span class="text-success fw-bold"><i class="bi bi-circle-fill" style="font-size: 0.5rem;"></i> HikariCP</span>
                    </div>
                    <div class="d-flex justify-content-between">
                        <span class="text-secondary">Active Sessions:</span>
                        <span class="text-info fw-bold">${applicationScope.activeUserCount != null ? applicationScope.activeUserCount : 1}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content Area Starts -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
            <jsp:include page="/fragments/messages.jsp"/>

