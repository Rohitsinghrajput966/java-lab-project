<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="java.net URLConnection Demo" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/navbar.jsp"/>

<div class="container my-5">
    <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-4">
        <span class="badge bg-secondary bg-opacity-10 text-secondary px-3 py-2 rounded-pill fw-bold mb-3" style="width: fit-content;">
            RTU Advanced Java Syllabus Topic: Content and Protocol Handlers
        </span>
        <h2 class="fw-bold text-dark mb-2"><code>java.net.URL</code> &amp; <code>URLConnection</code> Protocol Demonstration</h2>
        <p class="text-muted mb-4">
            Demonstrating network stream I/O, HTTP response code evaluation, and protocol handler interaction in Java.
        </p>

        <form action="${pageContext.request.contextPath}/syllabus/url-connection" method="get" class="mb-4">
            <div class="row g-2 align-items-center">
                <div class="col-md-9">
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="bi bi-globe"></i></span>
                        <input type="url" name="targetUrl" value="${testedUrl}" class="form-control rounded-end-3 shadow-none" placeholder="https://api.github.com/zen">
                    </div>
                </div>
                <div class="col-md-3">
                    <button type="submit" class="btn btn-primary rounded-pill w-100 fw-bold">Fetch via java.net</button>
                </div>
            </div>
        </form>

        <div class="row g-4">
            <div class="col-lg-6">
                <div class="card border rounded-4 p-4 bg-light h-100">
                    <h5 class="fw-bold mb-3 text-dark"><i class="bi bi-arrow-down-left-circle me-2"></i>Network Response Content</h5>
                    <div class="d-flex justify-content-between align-items-center mb-2 small">
                        <span class="text-muted">Target Endpoint: <code>${testedUrl}</code></span>
                        <span class="badge ${httpStatusCode >= 200 && httpStatusCode < 300 ? 'bg-success' : 'bg-warning text-dark'}">HTTP Status: ${httpStatusCode}</span>
                    </div>
                    <pre class="bg-white p-3 rounded-3 border small overflow-auto text-dark" style="max-height: 220px;"><code><c:out value="${urlResponseContent}"/></code></pre>
                </div>
            </div>

            <div class="col-lg-6">
                <div class="card border rounded-4 p-4 bg-dark text-white h-100">
                    <h5 class="fw-bold mb-3 text-warning"><i class="bi bi-code-square me-2"></i>Java Network Protocol Handler Implementation</h5>
                    <pre class="bg-black p-3 rounded-3 text-light small overflow-auto" style="max-height: 220px;"><code>URL url = new URL(targetUrl);
HttpURLConnection conn = (HttpURLConnection) url.openConnection();
conn.setRequestMethod("GET");
conn.setRequestProperty("User-Agent", "shopsphere-Demo/1.0");

int responseCode = conn.getResponseCode();
try (BufferedReader reader = new BufferedReader(
        new InputStreamReader(conn.getInputStream()))) {
    String line;
    while ((line = reader.readLine()) != null) {
        content.append(line).append("\n");
    }
}</code></pre>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/fragments/footer.jsp"/>

