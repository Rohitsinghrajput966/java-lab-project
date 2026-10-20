<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="My Wishlist" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/navbar.jsp"/>

<div class="container my-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-3 border-bottom gap-3">
        <div>
            <div class="d-flex align-items-center gap-2">
                <span class="badge bg-danger bg-opacity-10 text-danger rounded-pill px-3 py-2 fw-semibold">
                    <i class="bi bi-heart-fill me-1"></i> Saved Items
                </span>
                <span class="text-muted small">|</span>
                <span class="text-muted small">${wishlist != null ? wishlist.size() : 0} item(s) in wishlist</span>
            </div>
            <h2 class="fw-black tracking-tight mb-0 mt-2 display-6 fw-bold">My Saved Wishlist</h2>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-dark rounded-pill px-4 py-2 fw-semibold d-inline-flex align-items-center gap-2">
                <i class="bi bi-compass"></i> Discover More Products
            </a>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty wishlist}">
            <div class="row g-4">
                <c:forEach var="item" items="${wishlist}">
                    <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                        <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden bg-white product-card hover-lift transition">
                            <div class="position-relative overflow-hidden bg-light" style="height: 220px;">
                                <img src="${item.product.imageUrl != null ? item.product.imageUrl : pageContext.request.contextPath.concat('/assets/img/product-placeholder.svg')}"
                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/product-placeholder.svg';"
                                     alt="${item.product.name}" class="img-fluid w-100 h-100 object-fit-cover">
                                
                                <c:if test="${item.product.discount > 0}">
                                    <span class="position-absolute top-0 start-0 m-2 badge bg-danger rounded-pill px-2 py-1 shadow-xs fw-bold">
                                        -${item.product.discount}% OFF
                                    </span>
                                </c:if>

                                <form action="${pageContext.request.contextPath}/wishlist" method="post" class="position-absolute top-0 end-0 m-2 m-0">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="productId" value="${item.productId}">
                                    <button type="submit" class="btn btn-white btn-sm rounded-circle shadow-sm border p-2" title="Remove from wishlist">
                                        <i class="bi bi-x-lg text-danger"></i>
                                    </button>
                                </form>
                            </div>

                            <div class="card-body d-flex flex-column p-4">
                                <span class="badge bg-light text-muted border rounded-pill px-2 py-1 mb-2 align-self-start small">${item.product.brand}</span>
                                <h6 class="fw-bold mb-2 line-clamp-2">
                                    <a href="${pageContext.request.contextPath}/product-details?id=${item.productId}" class="text-decoration-none text-dark hover-primary">
                                        ${item.product.name}
                                    </a>
                                </h6>

                                <div class="mt-auto pt-3 border-top border-light-subtle">
                                    <div class="d-flex align-items-baseline gap-2 mb-3">
                                        <span class="fs-5 fw-black text-primary font-monospace">₹<fmt:formatNumber value="${item.product.discountedPrice}" minFractionDigits="2" maxFractionDigits="2"/></span>
                                        <c:if test="${item.product.discount > 0}">
                                            <span class="text-muted text-decoration-line-through small font-monospace">₹<fmt:formatNumber value="${item.product.price}" minFractionDigits="2" maxFractionDigits="2"/></span>
                                        </c:if>
                                    </div>

                                    <form action="${pageContext.request.contextPath}/wishlist" method="post" class="d-grid m-0">
                                        <input type="hidden" name="action" value="moveToCart">
                                        <input type="hidden" name="productId" value="${item.productId}">
                                        <button type="submit" class="btn btn-primary btn-sm rounded-pill py-2 fw-bold shadow-2xs d-flex align-items-center justify-content-center gap-1">
                                            <i class="bi bi-bag-plus"></i> Move to Cart
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center py-5 bg-white rounded-4 border shadow-sm my-5 p-5">
                <div class="d-inline-flex p-4 rounded-circle bg-danger bg-opacity-10 text-danger mb-3">
                    <i class="bi bi-heartbreak display-4"></i>
                </div>
                <h4 class="fw-bold text-dark">Your Wishlist is Empty</h4>
                <p class="text-muted mb-4 mx-auto" style="max-width: 440px;">
                    Explore our curated catalog and tap the heart icon on any product to save it here for later purchases.
                </p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill px-5 py-3 fw-bold shadow">
                    Discover Products Now
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/fragments/footer.jsp"/>
