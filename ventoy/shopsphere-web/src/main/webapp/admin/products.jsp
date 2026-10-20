<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Product Catalog Management" scope="request"/>
<c:set var="activeTab" value="products" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/admin-navbar.jsp"/>

<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-2 pb-3 mb-4 border-bottom">
    <div>
        <h1 class="h2 fw-extrabold text-dark mb-1">Product Catalog Management</h1>
        <p class="text-muted small mb-0">${products.size()} active SKUs matched in database</p>
    </div>
    <div class="d-flex gap-2">
        <button type="button" class="btn btn-primary rounded-pill px-4 shadow-xs" data-bs-toggle="modal" data-bs-target="#addProductModal">
            <i class="bi bi-plus-lg me-1"></i> Add New Product
        </button>
    </div>
</div>

<!-- Search & Filtering Toolbar -->
<div class="card border-0 shadow-sm rounded-4 p-3 bg-white mb-4">
    <form action="${pageContext.request.contextPath}/admin/products" method="get" class="row g-2 align-items-center">
        <div class="col-md-5">
            <div class="input-group">
                <span class="input-group-text bg-light border-end-0 rounded-start-pill text-muted"><i class="bi bi-search"></i></span>
                <input type="text" name="q" value="${searchQuery}" class="form-control bg-light border-start-0 rounded-end-pill shadow-none" placeholder="Search by product name or brand...">
            </div>
        </div>

        <div class="col-md-3">
            <select name="category" class="form-select rounded-pill shadow-none" onchange="this.form.submit()">
                <option value="">All Categories</option>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat.categoryId}" ${selectedCategory == cat.categoryId ? 'selected' : ''}>${cat.name}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-2">
            <select name="stock" class="form-select rounded-pill shadow-none" onchange="this.form.submit()">
                <option value="">All Stock Levels</option>
                <option value="in" ${selectedStock == 'in' ? 'selected' : ''}>In Stock (>10)</option>
                <option value="low" ${selectedStock == 'low' ? 'selected' : ''}>Low Stock (1-10)</option>
                <option value="out" ${selectedStock == 'out' ? 'selected' : ''}>Out of Stock</option>
            </select>
        </div>

        <div class="col-md-2 d-flex gap-2">
            <button type="submit" class="btn btn-dark rounded-pill w-100 fw-semibold">Filter</button>
            <c:if test="${not empty searchQuery or not empty selectedCategory or not empty selectedStock}">
                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-secondary rounded-pill" title="Reset Filters"><i class="bi bi-x-lg"></i></a>
            </c:if>
        </div>
    </form>
</div>

<!-- Products Table -->
<div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white mb-4">
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light small text-uppercase text-muted">
                <tr>
                    <th class="ps-4">Product Details</th>
                    <th>Category</th>
                    <th>Price (₹)</th>
                    <th>Discount</th>
                    <th>Stock Units</th>
                    <th>Status</th>
                    <th class="pe-4 text-end">Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${products}">
                    <tr>
                        <td class="ps-4 py-3">
                            <div class="d-flex align-items-center gap-3">
                                <img src="${p.imageUrl != null ? p.imageUrl : pageContext.request.contextPath.concat('/assets/img/product-placeholder.svg')}"
                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/product-placeholder.svg';"
                                     alt="${p.name}" class="rounded-3 shadow-xs border" style="width: 52px; height: 52px; object-fit: cover;">
                                <div>
                                    <div class="fw-bold text-dark">${p.name}</div>
                                    <span class="text-muted small">${p.brand} &bull; ID #${p.productId}</span>
                                </div>
                            </div>
                        </td>
                        <td><span class="badge bg-light text-dark border">${p.categoryName}</span></td>
                        <td class="fw-bold text-dark">₹<fmt:formatNumber value="${p.price}" minFractionDigits="2" maxFractionDigits="2"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${p.discount > 0}">
                                    <span class="badge bg-danger rounded-pill">-${p.discount}% OFF</span>
                                </c:when>
                                <c:otherwise><span class="text-muted small">None</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <!-- Inline Quick Stock Updater -->
                            <form action="${pageContext.request.contextPath}/admin/products/stock" method="post" class="d-inline-flex align-items-center gap-1.5">
                                <input type="hidden" name="productId" value="${p.productId}">
                                <input type="number" name="stock" value="${p.stock}" min="0" class="form-control form-control-sm rounded-3 text-center shadow-none fw-bold" style="width: 70px;">
                                <button type="submit" class="btn btn-sm btn-light border rounded-3 text-primary" title="Update Stock">
                                    <i class="bi bi-check-lg"></i>
                                </button>
                                <c:if test="${p.stock <= 5}">
                                    <span class="badge bg-danger rounded-pill ms-1" style="font-size: 0.65rem;">LOW</span>
                                </c:if>
                            </form>
                        </td>
                        <td>
                            <!-- Status Toggle Button -->
                            <form action="${pageContext.request.contextPath}/admin/products/toggle" method="post" class="d-inline">
                                <input type="hidden" name="productId" value="${p.productId}">
                                <button type="submit" class="btn btn-sm rounded-pill px-3 py-1 fw-semibold ${p.status ? 'btn-success bg-opacity-10 text-success border border-success border-opacity-25' : 'btn-secondary bg-opacity-25 text-secondary border'}" title="Click to toggle status">
                                    <i class="bi bi-circle-fill me-1" style="font-size: 0.5rem;"></i>
                                    ${p.status ? 'Published' : 'Draft'}
                                </button>
                            </form>
                        </td>
                        <td class="pe-4 text-end">
                            <div class="d-inline-flex gap-1.5">
                                <button type="button" class="btn btn-sm btn-outline-secondary rounded-circle" data-bs-toggle="modal" data-bs-target="#editModal_${p.productId}" title="Edit Product">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <form action="${pageContext.request.contextPath}/admin/products/delete" method="post" class="d-inline" onsubmit="return confirm('Permanently delete ${p.name}?');">
                                    <input type="hidden" name="productId" value="${p.productId}">
                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-circle" title="Delete Product">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>
                            </div>

                            <!-- Edit Modal for Product -->
                            <div class="modal fade text-start" id="editModal_${p.productId}" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog modal-lg modal-dialog-centered">
                                    <div class="modal-content rounded-4 border-0 shadow-lg">
                                        <div class="modal-header border-bottom">
                                            <h5 class="modal-title fw-bold">Edit Product: ${p.name}</h5>
                                            <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/admin/products/edit" method="post">
                                            <input type="hidden" name="productId" value="${p.productId}">
                                            <div class="modal-body p-4">
                                                <div class="row g-3">
                                                    <div class="col-md-8">
                                                        <label class="form-label small fw-semibold">Product Title</label>
                                                        <input type="text" name="name" class="form-control rounded-3" value="${p.name}" required>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <label class="form-label small fw-semibold">Brand / Manufacturer</label>
                                                        <input type="text" name="brand" class="form-control rounded-3" value="${p.brand}" required>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label class="form-label small fw-semibold">Department Category</label>
                                                        <select name="categoryId" class="form-select rounded-3">
                                                            <c:forEach var="cat" items="${categories}">
                                                                <option value="${cat.categoryId}" ${cat.categoryId == p.categoryId ? 'selected' : ''}>${cat.name}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label class="form-label small fw-semibold">Image URL</label>
                                                        <input type="url" name="imageUrl" class="form-control rounded-3" value="${p.imageUrl}">
                                                    </div>
                                                    <div class="col-md-4">
                                                        <label class="form-label small fw-semibold">List Price (₹)</label>
                                                        <input type="number" step="0.01" name="price" class="form-control rounded-3" value="${p.price}" required>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <label class="form-label small fw-semibold">Discount (%)</label>
                                                        <input type="number" step="0.01" name="discount" class="form-control rounded-3" value="${p.discount}">
                                                    </div>
                                                    <div class="col-md-4">
                                                        <label class="form-label small fw-semibold">Inventory Stock</label>
                                                        <input type="number" name="stock" class="form-control rounded-3" value="${p.stock}" required>
                                                    </div>
                                                    <div class="col-12">
                                                        <label class="form-label small fw-semibold">Specifications / Description</label>
                                                        <textarea name="description" rows="3" class="form-control rounded-3">${p.description}</textarea>
                                                    </div>
                                                    <div class="col-12">
                                                        <div class="form-check form-switch">
                                                            <input class="form-check-input" type="checkbox" name="status" id="status_${p.productId}" ${p.status ? 'checked' : ''}>
                                                            <label class="form-check-label fw-semibold" for="status_${p.productId}">Publish Product in Catalog</label>
                                                        </div>
                                                    </div>
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

<!-- Add Product Modal -->
<div class="modal fade" id="addProductModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow-lg">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-bold"><i class="bi bi-plus-circle text-primary me-2"></i>Create New Product</h5>
                <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/products/add" method="post">
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label small fw-semibold">Product Title</label>
                            <input type="text" name="name" class="form-control rounded-3" placeholder="e.g. AuraAudio ANC Studio Monitors" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Brand / Manufacturer</label>
                            <input type="text" name="brand" class="form-control rounded-3" placeholder="e.g. AuraAudio" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Department Category</label>
                            <select name="categoryId" class="form-select rounded-3" required>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.categoryId}">${cat.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Image URL</label>
                            <input type="url" name="imageUrl" class="form-control rounded-3" placeholder="https://images.unsplash.com/...">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">List Price (₹)</label>
                            <input type="number" step="0.01" name="price" class="form-control rounded-3" placeholder="e.g. 149.99" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Promotional Discount (%)</label>
                            <input type="number" step="0.01" name="discount" class="form-control rounded-3" placeholder="e.g. 15.00" value="0.00">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Initial Stock Units</label>
                            <input type="number" name="stock" class="form-control rounded-3" placeholder="e.g. 50" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Product Description &amp; Specifications</label>
                            <textarea name="description" rows="3" class="form-control rounded-3" placeholder="Detailed product specifications, materials, and features..."></textarea>
                        </div>
                        <div class="col-12">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="status" id="addStatus" checked>
                                <label class="form-check-label fw-semibold" for="addStatus">Immediately publish on storefront catalog</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-top bg-light rounded-bottom-4">
                    <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-4 fw-semibold shadow-xs">Publish SKU</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/fragments/admin-footer.jsp"/>
