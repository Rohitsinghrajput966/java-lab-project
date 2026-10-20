<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="RTU Advanced Java Syllabus Showcase" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/navbar.jsp"/>

<div class="container my-5">
    <div class="p-5 hero-banner mb-5 text-white shadow-sm">
        <span class="badge bg-warning text-dark px-3 py-2 rounded-pill fw-bold mb-3">Academic Compliance Directory</span>
        <h1 class="display-5 fw-bold mb-3">RTU Advanced Java Syllabus Modules</h1>
        <p class="lead text-light text-opacity-75 mb-0">
            Interactive demonstrations for all theoretical and practical topics prescribed in the RTU Advanced Java / Java Enterprise curriculum.
        </p>
    </div>

    <div class="row g-4">
        <div class="col-md-6 col-lg-4">
            <div class="card h-100 border-0 shadow-sm rounded-4 p-4 bg-white">
                <div class="p-3 bg-primary bg-opacity-10 text-primary rounded-4 d-inline-block mb-3" style="width: fit-content;">
                    <i class="bi bi-code-slash fs-3"></i>
                </div>
                <h5 class="fw-bold mb-2">Traditional JSP Elements</h5>
                <p class="text-muted small mb-4">Declarations (<%!...%>), scriptlets (<%...%>), expressions (<%=...%>), and directive comments.</p>
                <a href="${pageContext.request.contextPath}/syllabus/traditional-jsp" class="btn btn-outline-primary btn-sm rounded-pill mt-auto">Run Demonstration</a>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card h-100 border-0 shadow-sm rounded-4 p-4 bg-white">
                <div class="p-3 bg-danger bg-opacity-10 text-danger rounded-4 d-inline-block mb-3" style="width: fit-content;">
                    <i class="bi bi-filetype-xml fs-3"></i>
                </div>
                <h5 class="fw-bold mb-2">JSTL XML Feed Parser</h5>
                <p class="text-muted small mb-4">Parsing product XML documents dynamically in JSP using &lt;x:parse&gt;, &lt;x:forEach&gt;, and &lt;x:out&gt;.</p>
                <a href="${pageContext.request.contextPath}/syllabus/jstl-xml" class="btn btn-outline-danger btn-sm rounded-pill mt-auto">Run Demonstration</a>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card h-100 border-0 shadow-sm rounded-4 p-4 bg-white">
                <div class="p-3 bg-success bg-opacity-10 text-success rounded-4 d-inline-block mb-3" style="width: fit-content;">
                    <i class="bi bi-database fs-3"></i>
                </div>
                <h5 class="fw-bold mb-2">JSTL SQL Tag Library</h5>
                <p class="text-muted small mb-4">Direct SQL queries via &lt;sql:query&gt; contrasting with the production 3-tier DAO architecture.</p>
                <a href="${pageContext.request.contextPath}/syllabus/jstl-sql" class="btn btn-outline-success btn-sm rounded-pill mt-auto">Run Demonstration</a>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card h-100 border-0 shadow-sm rounded-4 p-4 bg-white">
                <div class="p-3 bg-info bg-opacity-10 text-info rounded-4 d-inline-block mb-3" style="width: fit-content;">
                    <i class="bi bi-translate fs-3"></i>
                </div>
                <h5 class="fw-bold mb-2">Internationalization (i18n)</h5>
                <p class="text-muted small mb-4">Multi-lingual localization with Java ResourceBundle, Locale, and localized price/date formatters.</p>
                <a href="${pageContext.request.contextPath}/syllabus/i18n?lang=en" class="btn btn-outline-info btn-sm rounded-pill mt-auto">Run Demonstration</a>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card h-100 border-0 shadow-sm rounded-4 p-4 bg-white">
                <div class="p-3 bg-warning bg-opacity-10 text-warning rounded-4 d-inline-block mb-3" style="width: fit-content;">
                    <i class="bi bi-diagram-3 fs-3"></i>
                </div>
                <h5 class="fw-bold mb-2">JNDI Resource Lookup</h5>
                <p class="text-muted small mb-4">Java Naming and Directory Interface demonstration resolving DataSource bindings in Tomcat.</p>
                <a href="${pageContext.request.contextPath}/syllabus/jndi" class="btn btn-outline-warning btn-sm rounded-pill mt-auto">Run Demonstration</a>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card h-100 border-0 shadow-sm rounded-4 p-4 bg-white">
                <div class="p-3 bg-secondary bg-opacity-10 text-secondary rounded-4 d-inline-block mb-3" style="width: fit-content;">
                    <i class="bi bi-hdd-network fs-3"></i>
                </div>
                <h5 class="fw-bold mb-2">java.net URLConnection</h5>
                <p class="text-muted small mb-4">Content extraction and protocol handling using java.net.URL and HttpURLConnection.</p>
                <a href="${pageContext.request.contextPath}/syllabus/url-connection" class="btn btn-outline-secondary btn-sm rounded-pill mt-auto">Run Demonstration</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/fragments/footer.jsp"/>
