<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<c:set var="pageTitle" value="${product.name}" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/navbar.jsp"/>

<div class="container my-5">
    <!-- Breadcrumbs -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products" class="text-decoration-none">Catalog</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products?category=${product.categoryId}" class="text-decoration-none">${product.categoryName}</a></li>
            <li class="breadcrumb-item active text-truncate" style="max-width: 250px;" aria-current="page">${product.name}</li>
        </ol>
    </nav>

    <!-- Product Showcase -->
    <div class="row g-5 mb-5 align-items-center">
        <!-- Product Image -->
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white p-4 text-center position-relative">
                <c:if test="${product.discount > 0}">
                    <span class="badge-discount fs-6 px-3 py-1.5">
                        -<fmt:formatNumber value="${product.discount}" maxFractionDigits="0"/>% OFF
                    </span>
                </c:if>
                <img src="${product.imageUrl != null ? product.imageUrl : pageContext.request.contextPath.concat('/assets/img/product-placeholder.svg')}"
                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/product-placeholder.svg';"
                     alt="${product.name}" class="img-fluid rounded-4" style="max-height: 480px; width: 100%; object-fit: cover;">
            </div>
        </div>

        <!-- Product Details & Purchase Form -->
        <div class="col-lg-6">
            <div class="ps-lg-3">
                <div class="d-flex align-items-center gap-2 mb-2">
                    <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-1.5 rounded-pill fw-bold">
                        ${product.categoryName != null ? product.categoryName : 'Curated SKU'}
                    </span>
                    <span class="text-muted fw-bold text-uppercase small" style="font-size: 0.75rem; letter-spacing: 0.5px;">${product.brand}</span>
                </div>

                <h1 class="fw-extrabold mb-3 text-dark leading-tight">${product.name}</h1>

                <div class="d-flex align-items-center gap-3 mb-4">
                    <tags:rating score="${product.rating}" />
                    <span class="text-muted small">(${reviews.size()} verified reviews)</span>
                    <span class="text-muted small">&bull;</span>
                    <c:choose>
                        <c:when test="${product.stock > 10}">
                            <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3 py-1 fw-bold">
                                <i class="bi bi-check-circle-fill me-1"></i> In Stock (${product.stock} units)
                            </span>
                        </c:when>
                        <c:when test="${product.stock > 0}">
                            <span class="badge bg-warning bg-opacity-25 text-dark rounded-pill px-3 py-1 fw-bold">
                                <i class="bi bi-clock me-1"></i> Only ${product.stock} left in warehouse!
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-danger bg-opacity-10 text-danger rounded-pill px-3 py-1 fw-bold">Out of Stock</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Price Card -->
                <div class="p-3.5 bg-light rounded-4 mb-4 d-flex align-items-baseline gap-3 border">
                    <span class="display-6 fw-extrabold text-primary">₹<fmt:formatNumber value="${product.discountedPrice}" minFractionDigits="2" maxFractionDigits="2"/></span>
                    <c:if test="${product.discount > 0}">
                        <span class="fs-4 text-muted text-decoration-line-through">₹<fmt:formatNumber value="${product.price}" minFractionDigits="2" maxFractionDigits="2"/></span>
                        <span class="badge bg-danger rounded-pill px-3 py-1.5 fw-bold">Save ${product.discount}%</span>
                    </c:if>
                </div>

                <p class="text-secondary mb-4 leading-relaxed">${product.description}</p>

                <!-- Purchase / Cart Actions -->
                <c:choose>
                    <c:when test="${product.stock > 0}">
                        <form action="${pageContext.request.contextPath}/cart" method="post" class="mb-4">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${product.productId}">

                            <div class="row g-3 align-items-center mb-3.5">
                                <div class="col-auto">
                                    <label class="fw-semibold small">Quantity:</label>
                                </div>
                                <div class="col-auto">
                                    <input type="number" name="quantity" value="1" min="1" max="${product.stock}" class="form-control rounded-pill text-center shadow-none fw-bold" style="width: 85px;">
                                </div>
                                <div class="col-auto text-muted small">
                                    Max ${product.stock} per customer
                                </div>
                            </div>

                            <div class="d-flex flex-wrap gap-3">
                                <button type="submit" class="btn btn-primary btn-lg rounded-pill px-5 fw-bold shadow">
                                    <i class="bi bi-cart-plus me-2"></i> Add to Cart
                                </button>
                                <button type="submit" formaction="${pageContext.request.contextPath}/wishlist" class="btn btn-outline-danger btn-lg rounded-pill px-4" title="Save to Wishlist">
                                    <i class="bi bi-heart me-1"></i> Wishlist
                                </button>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-warning rounded-4 mb-4 border-0 shadow-xs">
                            <i class="bi bi-info-circle me-2"></i> This product is currently sold out. Add it to your wishlist to receive a notification once restocked.
                        </div>
                        <form action="${pageContext.request.contextPath}/wishlist" method="post">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${product.productId}">
                            <button type="submit" class="btn btn-outline-danger rounded-pill px-4 py-2">
                                <i class="bi bi-heart me-1"></i> Save to Wishlist
                            </button>
                        </form>
                    </c:otherwise>
                </c:choose>

                <!-- Value Props -->
                <div class="pt-4 border-top d-flex flex-wrap gap-4 text-muted small">
                    <div><i class="bi bi-truck text-primary me-1.5"></i> Express 2-Day Delivery</div>
                    <div><i class="bi bi-arrow-counterclockwise text-info me-1.5"></i> 30-Day Easy Returns</div>
                    <div><i class="bi bi-shield-lock text-success me-1.5"></i> 256-Bit SSL Encrypted</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Customer Reviews Section -->
    <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h4 class="fw-bold mb-1">Customer Reviews</h4>
                <p class="text-muted small mb-0">${reviews.size()} verified buyers shared their experience</p>
            </div>
            <button class="btn btn-outline-primary btn-sm rounded-pill px-4 fw-semibold" type="button" data-bs-toggle="collapse" data-bs-target="#reviewFormCollapse">
                <i class="bi bi-pencil-square me-1"></i> Write Review
            </button>
        </div>

        <!-- Write Review Form (Collapsible) -->
        <div class="collapse mb-4" id="reviewFormCollapse">
            <div class="p-4 bg-light rounded-4 border mb-4">
                <h6 class="fw-bold mb-3">Share Your Experience with ${product.name}</h6>
                <form action="${pageContext.request.contextPath}/review" method="post">
                    <input type="hidden" name="productId" value="${product.productId}">
                    <div class="row g-3 mb-3">
                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">Rating</label>
                            <select name="rating" class="form-select rounded-3 shadow-none" required>
                                <option value="5">★★★★★ (5 - Excellent)</option>
                                <option value="4">★★★★☆ (4 - Very Good)</option>
                                <option value="3">★★★☆☆ (3 - Average)</option>
                                <option value="2">★★☆☆☆ (2 - Poor)</option>
                                <option value="1">★☆☆☆☆ (1 - Terrible)</option>
                            </select>
                        </div>
                        <div class="col-md-9">
                            <label class="form-label small fw-semibold">Review Text</label>
                            <textarea name="reviewText" rows="3" class="form-control rounded-3 shadow-none" placeholder="What did you love or dislike about this product?..." required></textarea>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary rounded-pill px-4 fw-semibold">Submit Review</button>
                </form>
            </div>
        </div>

        <!-- Reviews List -->
        <c:choose>
            <c:when test="${not empty reviews}">
                <div class="d-flex flex-column gap-3">
                    <c:forEach var="rev" items="${reviews}">
                        <div class="p-3.5 border rounded-4 bg-white">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-flex align-items-center justify-content-center fw-bold" style="width: 32px; height: 32px; font-size: 0.8rem;">
                                        ${rev.userName != null ? rev.userName.substring(0, 1).toUpperCase() : 'U'}
                                    </div>
                                    <span class="fw-bold text-dark small">${rev.userName}</span>
                                    <span class="badge bg-success bg-opacity-10 text-success rounded-pill small" style="font-size: 0.65rem;">Verified</span>
                                </div>
                                <span class="small text-muted"><fmt:formatDate value="${rev.createdAt}" pattern="dd MMM yyyy"/></span>
                            </div>
                            <div class="mb-2">
                                <tags:rating score="${rev.rating * 1.0}" />
                            </div>
                            <p class="text-secondary small mb-0">${rev.reviewText}</p>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-4 text-muted">
                    <p class="mb-0">No reviews yet for this product. Be the first to share your thoughts!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/fragments/footer.jsp"/>
