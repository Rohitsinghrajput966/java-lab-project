<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Sign In" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/navbar.jsp"/>

<div class="container my-5 py-3">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-5">
            <div class="card border-0 shadow-lg rounded-4 p-4 p-md-5 bg-white position-relative overflow-hidden">
                <div class="text-center mb-4">
                    <div class="d-inline-flex p-3 rounded-circle bg-primary bg-opacity-10 text-primary mb-2.5">
                        <i class="bi bi-shield-lock-fill fs-2"></i>
                    </div>
                    <h3 class="fw-extrabold text-dark mb-1">Welcome Back</h3>
                    <p class="text-muted small">Access your ShopSphere orders, wishlist &amp; settings</p>
                </div>

                <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 rounded-start-pill ps-3 text-muted"><i class="bi bi-envelope"></i></span>
                            <input type="email" id="loginEmail" name="email" value="${email}" class="form-control rounded-end-pill shadow-none border-start-0 bg-light" placeholder="name@example.com" required autofocus>
                        </div>
                    </div>

                    <div class="mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <label class="form-label small fw-semibold mb-0">Password</label>
                            <a href="#" class="small text-decoration-none text-muted" onclick="alert('Password reset instructions have been dispatched to your email.'); return false;">Forgot?</a>
                        </div>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 rounded-start-pill ps-3 text-muted"><i class="bi bi-key"></i></span>
                            <input type="password" id="loginPassword" name="password" class="form-control rounded-end-pill shadow-none border-start-0 bg-light" placeholder="••••••••" required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary btn-lg rounded-pill w-100 fw-bold shadow py-2.5 mb-3">
                        Sign In &rarr;
                    </button>
                </form>

                <!-- Quick 1-Click Demo Login Box -->
                <div class="p-3 bg-light rounded-4 border mb-3 small">
                    <div class="fw-bold mb-2 text-dark d-flex align-items-center gap-1.5">
                        <i class="bi bi-magic text-primary"></i> 1-Click Demo Fill:
                    </div>
                    <div class="d-grid gap-2">
                        <button type="button" class="btn btn-sm btn-outline-primary rounded-pill text-start px-3 py-1.5 d-flex justify-content-between align-items-center" onclick="fillCreds('pooja@shopsphere.com', 'Pooja@123')">
                            <span><i class="bi bi-shield-shaded me-1.5"></i> Admin (Pooja): <strong>pooja@shopsphere.com</strong></span>
                            <span class="badge bg-primary text-white">Fill</span>
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-success rounded-pill text-start px-3 py-1.5 d-flex justify-content-between align-items-center" onclick="fillCreds('priya@shopsphere.com', 'Priya@123')">
                            <span><i class="bi bi-person me-1.5"></i> Customer (Priya): <strong>priya@shopsphere.com</strong></span>
                            <span class="badge bg-success text-white">Fill</span>
                        </button>
                    </div>
                </div>

                <div class="text-center small text-muted">
                    Don't have an account yet?
                    <a href="${pageContext.request.contextPath}/register" class="text-decoration-none fw-bold text-primary ms-1">Create one here</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function fillCreds(email, pass) {
    document.getElementById('loginEmail').value = email;
    document.getElementById('loginPassword').value = pass;
}
</script>

<jsp:include page="/fragments/footer.jsp"/>

