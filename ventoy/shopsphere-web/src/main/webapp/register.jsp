<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Create Account" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/navbar.jsp"/>

<div class="container my-5 py-3">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card border-0 shadow-lg rounded-4 p-4 p-md-5 bg-white">
                <div class="text-center mb-4">
                    <div class="d-inline-flex p-3 rounded-circle bg-primary bg-opacity-10 text-primary mb-2.5">
                        <i class="bi bi-person-plus-fill fs-2"></i>
                    </div>
                    <h3 class="fw-extrabold text-dark mb-1">Create Account</h3>
                    <p class="text-muted small">Join ShopSphere to unlock exclusive member pricing &amp; tracking</p>
                </div>

                <form action="${pageContext.request.contextPath}/register" method="post">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Full Name</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 rounded-start-pill ps-3 text-muted"><i class="bi bi-person"></i></span>
                            <input type="text" name="name" value="${name}" class="form-control rounded-end-pill shadow-none border-start-0 bg-light" placeholder="e.g. Alex Hunter" required autofocus>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 rounded-start-pill ps-3 text-muted"><i class="bi bi-envelope"></i></span>
                            <input type="email" name="email" value="${email}" class="form-control rounded-end-pill shadow-none border-start-0 bg-light" placeholder="name@domain.com" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Mobile Number</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 rounded-start-pill ps-3 text-muted"><i class="bi bi-telephone"></i></span>
                            <input type="tel" name="mobile" value="${mobile}" class="form-control rounded-end-pill shadow-none border-start-0 bg-light" placeholder="9876543210">
                        </div>
                    </div>

                    <div class="row g-2 mb-4">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Password</label>
                            <input type="password" name="password" class="form-control rounded-pill shadow-none bg-light px-3" placeholder="••••••••" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Confirm Password</label>
                            <input type="password" name="confirmPassword" class="form-control rounded-pill shadow-none bg-light px-3" placeholder="••••••••" required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary btn-lg rounded-pill w-100 fw-bold shadow py-2.5 mb-3">
                        Complete Registration &rarr;
                    </button>
                </form>

                <div class="text-center small text-muted">
                    Already have an account?
                    <a href="${pageContext.request.contextPath}/login" class="text-decoration-none fw-bold text-primary ms-1">Sign in here</a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/fragments/footer.jsp"/>
