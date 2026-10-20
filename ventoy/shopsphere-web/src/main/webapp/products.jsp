<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<c:set var="pageTitle" value="All Products | ShopSphere Mega Store" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/navbar.jsp"/>

<div class="container my-4 py-2">
    <!-- Breadcrumb & Catalog Header -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-3 border-bottom gap-3">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb small mb-1">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none text-muted">Home</a></li>
                    <li class="breadcrumb-item active fw-bold text-primary" aria-current="page">Catalog</li>
                </ol>
            </nav>
            <h2 class="fw-black text-dark mb-1 display-6 fw-bold">Explore All Products</h2>
            <p class="text-muted small mb-0">
                <c:choose>
                    <c:when test="${not empty searchQuery}">
                        Showing results for &ldquo;<span class="fw-bold text-primary">${searchQuery}</span>&rdquo; &bull; <strong>${products.size()}</strong> items found
                    </c:when>
                    <c:otherwise>
                        Handpicked mega store deals &bull; <strong>${products.size()}</strong> items available
                    </c:otherwise>
                </c:choose>
            </p>
        </div>
        <c:if test="${not empty searchQuery or not empty selectedCategory or not empty minPrice or not empty maxPrice}">
            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-danger btn-sm rounded-pill px-3 shadow-2xs fw-semibold d-inline-flex align-items-center gap-1">
                <i class="bi bi-x-circle"></i> Clear All Filters
            </a>
        </c:if>
    </div>

    <div class="row g-4">
        <!-- Sidebar Filters -->
        <div class="col-lg-3">
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white sticky-top" style="top: 85px;">
                <h5 class="fw-bold mb-3 d-flex align-items-center justify-content-between">
                    <span class="d-flex align-items-center gap-2">
                        <i class="bi bi-sliders2 text-primary"></i> Filter Catalog
                    </span>
                    <span class="badge bg-light text-muted border small">Filter</span>
                </h5>

                <form action="${pageContext.request.contextPath}/products" method="get">
                    <c:if test="${not empty searchQuery}">
                        <input type="hidden" name="q" value="${searchQuery}">
                    </c:if>

                    <!-- Category Filter -->
                    <div class="mb-4">
                        <label class="form-label fw-bold small text-uppercase text-secondary" style="letter-spacing: 0.5px;">Categories</label>
                        <div class="d-flex flex-column gap-1 overflow-auto" style="max-height: 280px;">
                            <a href="${pageContext.request.contextPath}/products${not empty searchQuery ? '?q='.concat(searchQuery) : ''}"
                               class="text-decoration-none py-1.5 px-3 rounded-pill small fw-semibold ${empty selectedCategory ? 'bg-primary text-white shadow-2xs' : 'text-dark hover-light'}">
                                All Categories (${products.size()})
                            </a>
                            <c:forEach var="cat" items="${categories}">
                                <a href="${pageContext.request.contextPath}/products?category=${cat.categoryId}${not empty searchQuery ? '&q='.concat(searchQuery) : ''}"
                                   class="text-decoration-none py-1.5 px-3 rounded-pill small fw-semibold ${selectedCategory == cat.categoryId ? 'bg-primary text-white shadow-2xs' : 'text-secondary hover-light'}">
                                    ${cat.name}
                                </a>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Sort By -->
                    <div class="mb-4">
                        <label class="form-label fw-bold small text-uppercase text-secondary" style="letter-spacing: 0.5px;">Sort By</label>
                        <select name="sort" class="form-select rounded-pill shadow-none small" onchange="this.form.submit()">
                            <option value="newest" ${currentSort == 'newest' ? 'selected' : ''}>Newest Arrivals</option>
                            <option value="price_asc" ${currentSort == 'price_asc' ? 'selected' : ''}>Price: Low to High</option>
                            <option value="price_desc" ${currentSort == 'price_desc' ? 'selected' : ''}>Price: High to Low</option>
                            <option value="discount" ${currentSort == 'discount' ? 'selected' : ''}>Highest Discount</option>
                        </select>
                    </div>

                    <!-- Price Filter -->
                    <div class="mb-3">
                        <label class="form-label fw-bold small text-uppercase text-secondary" style="letter-spacing: 0.5px;">Price Range (₹)</label>
                        <div class="d-flex gap-2 align-items-center mb-2.5">
                            <input type="number" name="minPrice" value="${minPrice}" placeholder="Min" class="form-control form-control-sm rounded-pill text-center shadow-none">
                            <span class="text-muted">&ndash;</span>
                            <input type="number" name="maxPrice" value="${maxPrice}" placeholder="Max" class="form-control form-control-sm rounded-pill text-center shadow-none">
                        </div>
                        <c:if test="${not empty selectedCategory}">
                            <input type="hidden" name="category" value="${selectedCategory}">
                        </c:if>
                        <button type="submit" class="btn btn-outline-primary btn-sm w-100 rounded-pill fw-bold py-1.5 shadow-2xs">Apply Filter</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Products Grid -->
        <div class="col-lg-9">
            <c:choose>
                <c:when test="${not empty products}">
                    <div class="row">
                        <c:forEach var="prod" items="${products}">
                            <tags:productCard product="${prod}" />
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5 bg-white rounded-4 border shadow-sm p-5">
                        <div class="d-inline-flex p-4 rounded-circle bg-light text-muted mb-3">
                            <i class="bi bi-search fs-1"></i>
                        </div>
                        <h4 class="fw-bold text-dark">No Products Found</h4>
                        <p class="text-muted mb-4">We couldn't find any products matching your selected filters or search terms.</p>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill px-4 py-2 shadow-xs fw-semibold">
                            Reset &amp; View All Categories
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<jsp:include page="/fragments/footer.jsp"/>
