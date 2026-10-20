<%@ tag description="Reusable ShopSphere Product Card" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<%@ attribute name="product" type="com.ventoy.common.model.Product" required="true" %>

<div class="col-12 col-sm-6 col-md-4 col-lg-3 mb-4">
    <div class="card product-card h-100 position-relative border-0 shadow-sm rounded-4 overflow-hidden bg-white hover-lift transition">
        <!-- Discount Badge on Top-Left -->
        <c:if test="${product.discount > 0}">
            <span class="position-absolute top-0 start-0 m-2.5 badge bg-danger rounded-pill px-2.5 py-1.5 shadow-xs fw-bold" style="font-size: 0.72rem; z-index: 2;">
                -<fmt:formatNumber value="${product.discount}" maxFractionDigits="0"/>% OFF
            </span>
        </c:if>

        <!-- Save to Wishlist Button on Top-Right -->
        <form action="${pageContext.request.contextPath}/wishlist" method="post" class="position-absolute top-0 end-0 m-2.5 m-0" style="z-index: 2;">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="productId" value="${product.productId}">
            <button type="submit" class="btn btn-white btn-sm rounded-circle p-2 shadow-sm border text-danger d-flex align-items-center justify-content-center" title="Save to Wishlist" style="width: 34px; height: 34px; background: rgba(255,255,255,0.95); backdrop-filter: blur(4px);">
                <i class="bi bi-heart fs-6"></i>
            </button>
        </form>

        <!-- Product Image -->
        <a href="${pageContext.request.contextPath}/product-details?id=${product.productId}" class="text-decoration-none text-dark d-block overflow-hidden bg-light" style="height: 250px;">
            <img src="${product.imageUrl != null ? product.imageUrl : pageContext.request.contextPath.concat('/assets/img/product-placeholder.svg')}"
                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/product-placeholder.svg';"
                 alt="${product.name}" class="w-100 h-100 object-fit-cover transition-transform" loading="lazy">
        </a>

        <!-- Card Body -->
        <div class="card-body d-flex flex-column p-3.5">
            <div class="d-flex justify-content-between align-items-center mb-1.5">
                <span class="badge bg-light text-primary border rounded-pill px-2 py-0.5 fw-bold" style="letter-spacing: 0.5px; font-size: 0.7rem;">${product.brand}</span>
                <tags:rating score="${product.rating}" />
            </div>

            <h6 class="card-title mb-2 fw-bold text-truncate" title="${product.name}">
                <a href="${pageContext.request.contextPath}/product-details?id=${product.productId}" class="text-decoration-none text-dark hover-primary">
                    ${product.name}
                </a>
            </h6>

            <div class="mt-auto pt-2 border-top border-light-subtle">
                <div class="d-flex align-items-baseline gap-2 mb-3">
                    <span class="fs-5 fw-black text-primary font-monospace">₹<fmt:formatNumber value="${product.discountedPrice}" minFractionDigits="2" maxFractionDigits="2"/></span>
                    <c:if test="${product.discount > 0}">
                        <span class="text-muted text-decoration-line-through small font-monospace">₹<fmt:formatNumber value="${product.price}" minFractionDigits="2" maxFractionDigits="2"/></span>
                    </c:if>
                </div>

                <div>
                    <c:choose>
                        <c:when test="${product.stock > 0}">
                            <form action="${pageContext.request.contextPath}/cart" method="post" class="m-0">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="${product.productId}">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="btn btn-primary btn-sm rounded-pill w-100 py-2 fw-bold d-flex align-items-center justify-content-center gap-2 shadow-2xs">
                                    <i class="bi bi-cart-plus fs-6"></i>
                                    <span>Add to Cart</span>
                                </button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-light text-muted btn-sm rounded-pill w-100 py-2 disabled border">Out of Stock</button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>
