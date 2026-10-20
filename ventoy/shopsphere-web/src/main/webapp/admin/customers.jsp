<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Customer Directory" scope="request"/>
<c:set var="activeTab" value="customers" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/admin-navbar.jsp"/>

<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-2 pb-3 mb-4 border-bottom">
    <div>
        <h1 class="h2 fw-extrabold text-dark mb-1">Customer &amp; Access Directory</h1>
        <p class="text-muted small mb-0">${customers.size()} registered user accounts in system</p>
    </div>
</div>

<!-- Search & Filtering Toolbar -->
<div class="card border-0 shadow-sm rounded-4 p-3 bg-white mb-4">
    <form action="${pageContext.request.contextPath}/admin/customers" method="get" class="row g-2 align-items-center">
        <div class="col-md-5">
            <div class="input-group">
                <span class="input-group-text bg-light border-end-0 rounded-start-pill text-muted"><i class="bi bi-search"></i></span>
                <input type="text" name="q" value="${searchQuery}" class="form-control bg-light border-start-0 rounded-end-pill shadow-none" placeholder="Search by name, email, or mobile...">
            </div>
        </div>

        <div class="col-md-3">
            <select name="role" class="form-select rounded-pill shadow-none" onchange="this.form.submit()">
                <option value="ALL">All Roles</option>
                <option value="CUSTOMER" ${selectedRole == 'CUSTOMER' ? 'selected' : ''}>Customers</option>
                <option value="ADMIN" ${selectedRole == 'ADMIN' ? 'selected' : ''}>Administrators</option>
            </select>
        </div>

        <div class="col-md-2">
            <select name="status" class="form-select rounded-pill shadow-none" onchange="this.form.submit()">
                <option value="ALL">All Account Statuses</option>
                <option value="ACTIVE" ${selectedStatus == 'ACTIVE' ? 'selected' : ''}>Active</option>
                <option value="SUSPENDED" ${selectedStatus == 'SUSPENDED' ? 'selected' : ''}>Suspended</option>
            </select>
        </div>

        <div class="col-md-2 d-flex gap-2">
            <button type="submit" class="btn btn-dark rounded-pill w-100 fw-semibold">Filter</button>
            <c:if test="${not empty searchQuery or (not empty selectedRole and selectedRole != 'ALL') or (not empty selectedStatus and selectedStatus != 'ALL')}">
                <a href="${pageContext.request.contextPath}/admin/customers" class="btn btn-outline-secondary rounded-pill" title="Reset Filters"><i class="bi bi-x-lg"></i></a>
            </c:if>
        </div>
    </form>
</div>

<!-- Customers Table -->
<div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white mb-4">
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light small text-uppercase text-muted">
                <tr>
                    <th class="ps-4">User Details</th>
                    <th>Email Address</th>
                    <th>Mobile</th>
                    <th>Role Permission</th>
                    <th>Account Status</th>
                    <th>Registered On</th>
                    <th class="pe-4 text-end">Access Control</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="u" items="${customers}">
                    <tr>
                        <td class="ps-4 py-3">
                            <div class="d-flex align-items-center gap-2.5">
                                <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold ${u.admin ? 'bg-warning bg-opacity-25 text-dark' : 'bg-primary bg-opacity-10 text-primary'}" style="width: 40px; height: 40px; font-size: 0.85rem;">
                                    ${u.name.substring(0, 1).toUpperCase()}
                                </div>
                                <div>
                                    <div class="fw-bold text-dark">${u.name}</div>
                                    <span class="text-muted" style="font-size: 0.72rem;">User ID #${u.userId}</span>
                                </div>
                            </div>
                        </td>
                        <td><span class="text-dark fw-semibold">${u.email}</span></td>
                        <td class="text-muted">${not empty u.mobile ? u.mobile : '—'}</td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin/customers/role" method="post" class="d-inline" onsubmit="return confirm('Change permission role for ${u.name}?');">
                                <input type="hidden" name="userId" value="${u.userId}">
                                <input type="hidden" name="currentRole" value="${u.role}">
                                <button type="submit" class="btn btn-sm rounded-pill px-3 py-1 fw-bold ${u.admin ? 'btn-warning text-dark font-monospace' : 'btn-light border'}" title="Click to toggle role">
                                    <i class="bi ${u.admin ? 'bi-shield-shaded' : 'bi-person'} me-1"></i>
                                    ${u.role}
                                </button>
                            </form>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin/customers/status" method="post" class="d-inline" onsubmit="return confirm('Toggle account status for ${u.name}?');">
                                <input type="hidden" name="userId" value="${u.userId}">
                                <input type="hidden" name="currentStatus" value="${u.status}">
                                <button type="submit" class="btn btn-sm rounded-pill px-3 py-1 fw-semibold ${u.status == 'ACTIVE' ? 'btn-success bg-opacity-10 text-success border border-success border-opacity-25' : 'btn-danger bg-opacity-10 text-danger border'}" title="Click to toggle account status">
                                    <i class="bi bi-circle-fill me-1" style="font-size: 0.5rem;"></i>
                                    ${u.status}
                                </button>
                            </form>
                        </td>
                        <td class="small text-muted"><fmt:formatDate value="${u.createdAt}" pattern="dd MMM yyyy"/></td>
                        <td class="pe-4 text-end">
                            <c:choose>
                                <c:when test="${u.status == 'ACTIVE'}">
                                    <form action="${pageContext.request.contextPath}/admin/customers/status" method="post" class="d-inline">
                                        <input type="hidden" name="userId" value="${u.userId}">
                                        <input type="hidden" name="currentStatus" value="${u.status}">
                                        <button type="submit" class="btn btn-sm btn-outline-warning rounded-pill px-3" title="Suspend user">
                                            Suspend
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <form action="${pageContext.request.contextPath}/admin/customers/status" method="post" class="d-inline">
                                        <input type="hidden" name="userId" value="${u.userId}">
                                        <input type="hidden" name="currentStatus" value="${u.status}">
                                        <button type="submit" class="btn btn-sm btn-outline-success rounded-pill px-3" title="Reactivate user">
                                            Reactivate
                                        </button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/fragments/admin-footer.jsp"/>
