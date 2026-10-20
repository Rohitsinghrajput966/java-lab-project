<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Internationalization (i18n) Demo" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/navbar.jsp"/>

<div class="container my-5">
    <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-4">
        <span class="badge bg-info bg-opacity-10 text-info px-3 py-2 rounded-pill fw-bold mb-3" style="width: fit-content;">
            RTU Advanced Java Syllabus Topic: Internationalization (i18n)
        </span>
        <h2 class="fw-bold text-dark mb-2">Java Internationalization (i18n) &amp; Localization (L10n)</h2>
        <p class="text-muted mb-4">
            Demonstrating multi-lingual message bundle lookup, <code>Locale</code> switching, <code>NumberFormat</code> currency formatting, and localized <code>DateFormat</code>.
        </p>

        <!-- Language Selector -->
        <div class="d-flex align-items-center gap-3 p-3 bg-light rounded-4 mb-4">
            <span class="fw-bold small text-muted text-uppercase">Select Active Locale:</span>
            <div class="btn-group rounded-pill overflow-hidden shadow-sm">
                <a href="${pageContext.request.contextPath}/syllabus/i18n?lang=en" class="btn btn-sm ${currentLang == 'en' ? 'btn-primary' : 'btn-outline-primary'} px-3">
                    <i class="bi bi-flag-fill me-1"></i> English (US)
                </a>
                <a href="${pageContext.request.contextPath}/syllabus/i18n?lang=hi" class="btn btn-sm ${currentLang == 'hi' ? 'btn-primary' : 'btn-outline-primary'} px-3">
                    <i class="bi bi-translate me-1"></i> हिन्दी (Hindi - IN)
                </a>
            </div>
            <span class="badge bg-secondary text-uppercase">${currentLang}</span>
        </div>

        <div class="row g-4">
            <!-- Localized ResourceBundle Strings -->
            <div class="col-lg-6">
                <div class="card border rounded-4 p-4 bg-light h-100">
                    <h5 class="fw-bold mb-3 text-primary"><i class="bi bi-translate me-2"></i>ResourceBundle Output</h5>

                    <div class="mb-3 p-3 bg-white rounded-3 border">
                        <span class="text-muted small d-block">Key: <code>app.title</code></span>
                        <span class="fw-bold fs-5 text-dark">${bundle.getString("app.title")}</span>
                    </div>

                    <div class="mb-3 p-3 bg-white rounded-3 border">
                        <span class="text-muted small d-block">Key: <code>welcome.message</code></span>
                        <p class="mb-0 text-secondary">${bundle.getString("welcome.message")}</p>
                    </div>

                    <div class="p-3 bg-white rounded-3 border">
                        <span class="text-muted small d-block">Navigation Label Keys:</span>
                        <div class="d-flex gap-2 mt-2">
                            <span class="badge bg-light text-dark border p-2">${bundle.getString("nav.home")}</span>
                            <span class="badge bg-light text-dark border p-2">${bundle.getString("nav.products")}</span>
                            <span class="badge bg-light text-dark border p-2">${bundle.getString("nav.cart")}</span>
                            <span class="badge bg-light text-dark border p-2">${bundle.getString("nav.orders")}</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Number and Date Formatter -->
            <div class="col-lg-6">
                <div class="card border rounded-4 p-4 bg-light h-100">
                    <h5 class="fw-bold mb-3 text-success"><i class="bi bi-cash-coin me-2"></i>Localized Formatting</h5>

                    <div class="mb-3 p-3 bg-white rounded-3 border">
                        <span class="text-muted small d-block">Currency Formatter (<code>NumberFormat.getCurrencyInstance(locale)</code>):</span>
                        <span class="display-6 fw-bold text-success">${formattedPrice}</span>
                    </div>

                    <div class="mb-3 p-3 bg-white rounded-3 border">
                        <span class="text-muted small d-block">Date Formatter (<code>DateFormat.getDateInstance(FULL, locale)</code>):</span>
                        <span class="fw-semibold text-dark">${formattedDate}</span>
                    </div>

                    <div class="p-3 bg-dark text-light rounded-3 small">
                        <strong>Code Sample:</strong><br>
                        <code>Locale locale = new Locale("${currentLang}", "${currentLang == 'hi' ? 'IN' : 'US'}");</code><br>
                        <code>ResourceBundle bundle = ResourceBundle.getBundle("messages", locale);</code><br>
                        <code>String val = bundle.getString("catalog.addToCart");</code>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/fragments/footer.jsp"/>
