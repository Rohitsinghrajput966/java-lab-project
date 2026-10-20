<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- ShopSphere Mega E-Commerce Navbar -->
<nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top py-2.5 shadow-sm border-bottom">
    <div class="container">
        <!-- Brand Logo on Left -->
        <a class="navbar-brand brand-logo d-flex align-items-center me-3" href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/assets/img/shopsphere-logo.svg"
                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/shopsphere-logo.svg';"
                 alt="ShopSphere" style="height: 42px; width: auto; object-fit: contain;">
        </a>

        <!-- Mobile Toggler -->
        <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain" aria-controls="navbarMain" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarMain">
            <!-- Global Search Bar in Center -->
            <form class="d-flex mx-lg-auto my-2 my-lg-0 col-12 col-lg-6" action="${pageContext.request.contextPath}/products" method="get">
                <div class="input-group shadow-xs rounded-pill overflow-hidden border">
                    <span class="input-group-text bg-light border-0 ps-3 text-muted">
                        <i class="bi bi-search text-primary"></i>
                    </span>
                    <input class="form-control border-0 bg-light shadow-none py-2" type="search" name="q" value="${searchQuery}" placeholder="Search smartphones, laptops, headphones, sneakers, fashion, appliances..." aria-label="Search">
                    <button class="btn btn-primary px-4 fw-bold" type="submit" style="letter-spacing: 0.5px;">Search</button>
                </div>
            </form>

            <!-- Right-Hand Action Icons & Navigation Group -->
            <ul class="navbar-nav ms-auto align-items-lg-center gap-2">
                <!-- Catalog Collection Link -->
                <li class="nav-item">
                    <a class="nav-link fw-bold px-3 d-flex align-items-center gap-1.5 text-dark hover-primary" href="${pageContext.request.contextPath}/products">
                        <i class="bi bi-grid-fill text-primary fs-6"></i> All Products
                    </a>
                </li>

                <!-- User Account / Login Button -->
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle btn btn-light rounded-pill px-3 py-1.5 border d-flex align-items-center gap-2 shadow-2xs" href="#" id="userMenu" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center fw-bold" style="width: 26px; height: 26px; font-size: 0.8rem;">
                                    ${sessionScope.user.name.substring(0, 1).toUpperCase()}
                                </div>
                                <span class="fw-bold small text-dark">${sessionScope.user.name}</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-4 p-2 mt-2" aria-labelledby="userMenu" style="min-width: 210px;">
                                <c:if test="${sessionScope.user.admin}">
                                    <li><a class="dropdown-item py-2 rounded-3 text-primary fw-bold" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i>Admin Dashboard</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                </c:if>
                                <li><a class="dropdown-item py-2 rounded-3" href="${pageContext.request.contextPath}/orders"><i class="bi bi-box2-heart me-2 text-primary"></i>My Orders</a></li>
                                <li><a class="dropdown-item py-2 rounded-3" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person-gear me-2 text-muted"></i>Account Profile</a></li>
                                <li><a class="dropdown-item py-2 rounded-3" href="${pageContext.request.contextPath}/wishlist"><i class="bi bi-heart me-2 text-danger"></i>Saved Wishlist</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item py-2 rounded-3 text-danger fw-semibold" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Sign Out</a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="btn btn-outline-primary rounded-pill px-3.5 py-1.5 fw-bold d-flex align-items-center gap-1 shadow-2xs" href="${pageContext.request.contextPath}/login">
                                <i class="bi bi-person-circle"></i> Login
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>

                <!-- Wishlist Icon -->
                <li class="nav-item">
                    <a class="nav-link px-2.5 text-secondary hover-primary position-relative d-flex align-items-center gap-1" href="${pageContext.request.contextPath}/wishlist" title="My Wishlist">
                        <i class="bi bi-heart fs-5 text-danger"></i>
                        <span class="d-none d-lg-inline small fw-semibold text-muted">Wishlist</span>
                    </a>
                </li>

                <!-- Shopping Cart with Logo & Counter Badge -->
                <li class="nav-item">
                    <a class="nav-link px-2.5 position-relative text-dark d-flex align-items-center gap-1.5 hover-primary" href="${pageContext.request.contextPath}/cart" title="Shopping Cart">
                        <img src="${pageContext.request.contextPath}/assets/img/cart-logo.svg" alt="Cart" style="width: 24px; height: 24px;">
                        <span class="d-none d-lg-inline small fw-bold text-dark">Cart</span>
                        <c:if test="${not empty sessionScope.cartCount && sessionScope.cartCount > 0}">
                            <span class="badge bg-primary rounded-pill px-2 py-0.5 text-white fw-bold shadow-2xs" style="font-size: 0.72rem;">
                                ${sessionScope.cartCount}
                            </span>
                        </c:if>
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<jsp:include page="/fragments/messages.jsp"/>

