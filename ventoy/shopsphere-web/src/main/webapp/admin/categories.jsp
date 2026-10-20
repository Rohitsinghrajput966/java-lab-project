<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Category Management" scope="request"/>
<c:set var="activeTab" value="categories" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/admin-navbar.jsp"/>

<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-2 pb-3 mb-4 border-bottom">
    <div>
        <h1 class="h2 fw-extrabold text-dark mb-1">Catalog Department Categories</h1>
        <p class="text-muted small mb-0">Manage customer browsing hierarchies and collection banners</p>
    </div>
</div>

<div class="row g-4 mb-4">
    <!-- Categories List Table -->
    <div class="col-lg-8">
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light small text-uppercase text-muted">
                        <tr>
                            <th class="ps-4">Category</th>
                            <th>Slug</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th class="pe-4 text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="cat" items="${categories}">
                            <tr>
                                <td class="ps-4 py-3">
                                    <div class="d-flex align-items-center gap-3">
                                        <img src="${cat.imageUrl != null ? cat.imageUrl : pageContext.request.contextPath.concat('/assets/img/product-placeholder.svg')}"
                                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/product-placeholder.svg';"
                                             alt="${cat.name}" class="rounded-3 shadow-xs border" style="width: 44px; height: 44px; object-fit: cover;">
                                        <div>
                                            <div class="fw-bold text-dark">${cat.name}</div>
                                            <span class="text-muted" style="font-size: 0.72rem;">ID #${cat.categoryId}</span>
                                        </div>
                                    </div>
                                </td>
                                <td><code class="text-primary font-monospace small">${cat.slug}</code></td>
                                <td class="text-muted small text-truncate" style="max-width: 180px;" title="${cat.description}">${cat.description}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin/categories/toggle" method="post" class="d-inline">
                                        <input type="hidden" name="categoryId" value="${cat.categoryId}">
                                        <button type="submit" class="btn btn-sm rounded-pill px-3 py-1 fw-semibold ${cat.status ? 'btn-success bg-opacity-10 text-success border border-success border-opacity-25' : 'btn-secondary bg-opacity-25 text-secondary border'}" title="Click to toggle status">
                                            <i class="bi bi-circle-fill me-1" style="font-size: 0.5rem;"></i>
                                            ${cat.status ? 'Active' : 'Disabled'}
                                        </button>
                                    </form>
                                </td>
                                <td class="pe-4 text-end">
                                    <div class="d-inline-flex gap-1.5">
                                        <button type="button" class="btn btn-sm btn-outline-secondary rounded-circle" data-bs-toggle="modal" data-bs-target="#editCatModal_${cat.categoryId}" title="Edit Category">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <form action="${pageContext.request.contextPath}/admin/categories/delete" method="post" class="d-inline" onsubmit="return confirm('Delete this category?');">
                                            <input type="hidden" name="categoryId" value="${cat.categoryId}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger rounded-circle" title="Delete Category">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </div>

                                    <!-- Edit Category Modal -->
                                    <div class="modal fade text-start" id="editCatModal_${cat.categoryId}" tabindex="-1" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content rounded-4 border-0 shadow-lg">
                                                <div class="modal-header border-bottom">
                                                    <h5 class="modal-title fw-bold">Edit Category: ${cat.name}</h5>
                                                    <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <form action="${pageContext.request.contextPath}/admin/categories/edit" method="post">
                                                    <input type="hidden" name="categoryId" value="${cat.categoryId}">
                                                    <div class="modal-body p-4">
                                                        <div class="mb-3">
                                                            <label class="form-label small fw-semibold">Category Title</label>
                                                            <input type="text" name="name" class="form-control rounded-3" value="${cat.name}" required>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label small fw-semibold">URL Slug</label>
                                                            <input type="text" name="slug" class="form-control rounded-3" value="${cat.slug}">
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label small fw-semibold">Banner Image URL</label>
                                                            <input type="url" name="imageUrl" class="form-control rounded-3" value="${cat.imageUrl}">
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label small fw-semibold">Description</label>
                                                            <textarea name="description" rows="3" class="form-control rounded-3">${cat.description}</textarea>
                                                        </div>
                                                        <div class="form-check form-switch">
                                                            <input class="form-check-input" type="checkbox" name="status" id="catStatus_${cat.categoryId}" ${cat.status ? 'checked' : ''}>
                                                            <label class="form-check-label fw-semibold" for="catStatus_${cat.categoryId}">Active in Storefront</label>
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

    <!-- Create Category Card -->
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
            <h5 class="fw-bold mb-3 d-flex align-items-center gap-2">
                <i class="bi bi-folder-plus text-primary"></i> Create Category
            </h5>
            <form action="${pageContext.request.contextPath}/admin/categories/add" method="post">
                <div class="mb-3">
                    <label class="form-label small fw-semibold">Category Title</label>
                    <input type="text" name="name" class="form-control rounded-3" placeholder="e.g. Smart Workspace" required>
                </div>
                <div class="mb-3">
                    <label class="form-label small fw-semibold">URL Slug (Auto-generated if empty)</label>
                    <input type="text" name="slug" class="form-control rounded-3" placeholder="e.g. smart-workspace">
                </div>
                <div class="mb-3">
                    <label class="form-label small fw-semibold">Banner Image URL</label>
                    <input type="url" name="imageUrl" class="form-control rounded-3" placeholder="https://images.unsplash.com/...">
                </div>
                <div class="mb-3">
                    <label class="form-label small fw-semibold">Description</label>
                    <textarea name="description" rows="3" class="form-control rounded-3" placeholder="Brief department description..."></textarea>
                </div>
                <button type="submit" class="btn btn-primary rounded-pill w-100 fw-bold shadow-xs py-2">
                    Create Department
                </button>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/fragments/admin-footer.jsp"/>
