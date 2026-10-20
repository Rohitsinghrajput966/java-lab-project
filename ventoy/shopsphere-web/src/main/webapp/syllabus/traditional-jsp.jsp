<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- RTU Syllabus Demonstration: Traditional JSP Elements --%>
<%!
    // 1. JSP Declaration: Declares class-level member variables and methods in the generated servlet
    private int globalVisitorCount = 0;

    public synchronized int incrementVisitCounter() {
        return ++globalVisitorCount;
    }

    public String generateServerTimestamp() {
        return new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
    }
%>

<%
    // 2. JSP Scriptlet: Executes within the _jspService() method of the generated servlet
    int currentVisitor = incrementVisitCounter();
    String systemArchitecture = "Jakarta EE 10 / Apache Tomcat 10.1";
    String clientIp = request.getRemoteAddr();
%>

<c:set var="pageTitle" value="Traditional JSP Elements Demo" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/navbar.jsp"/>

<div class="container my-5">
    <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-4">
        <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill fw-bold mb-3" style="width: fit-content;">
            RTU Advanced Java Syllabus Topic #16 &amp; #17
        </span>
        <h2 class="fw-bold text-dark mb-2">Traditional JSP Syntax Elements Demonstration</h2>
        <p class="text-muted mb-4">
            Demonstrating JSP Declarations, Scriptlets, Expressions, Comments, and explaining how web containers compile JSP files into standard Java Servlets.
        </p>

        <div class="row g-4">
            <!-- Demonstration Results -->
            <div class="col-lg-6">
                <div class="card border rounded-4 p-4 bg-light h-100">
                    <h5 class="fw-bold mb-3 text-dark"><i class="bi bi-play-circle-fill text-success me-2"></i>Live Executed Results</h5>

                    <div class="mb-3 p-3 bg-white rounded-3 border">
                        <span class="text-muted small d-block">1. JSP Declaration Output:</span>
                        <span class="fw-bold fs-5 text-primary">Global Page Visits: <%= currentVisitor %></span>
                        <div class="small text-muted mt-1">Generated via <code>&lt;%! ... %&gt;</code> class-level method.</div>
                    </div>

                    <div class="mb-3 p-3 bg-white rounded-3 border">
                        <span class="text-muted small d-block">2. JSP Expression Output:</span>
                        <span class="fw-bold text-dark"><%= "Server Time: " + generateServerTimestamp() %></span>
                        <div class="small text-muted mt-1">Generated via <code>&lt;%= ... %&gt;</code> evaluated expression.</div>
                    </div>

                    <div class="mb-3 p-3 bg-white rounded-3 border">
                        <span class="text-muted small d-block">3. Scriptlet Local Variables:</span>
                        <div class="fw-semibold">Architecture: <%= systemArchitecture %></div>
                        <div class="text-muted small">Client Address: <%= clientIp %></div>
                    </div>

                    <div class="p-3 bg-white rounded-3 border">
                        <span class="text-muted small d-block">4. Expression Language Equivalent:</span>
                        <div class="fw-bold text-success">${demoStudentName} (${demoUniversity})</div>
                        <div class="small text-muted mt-1">Modern standard EL: <code>\${demoStudentName}</code></div>
                    </div>
                </div>
            </div>

            <!-- Code Comparison Explanation -->
            <div class="col-lg-6">
                <div class="card border rounded-4 p-4 bg-dark text-white h-100">
                    <h5 class="fw-bold mb-3 text-warning"><i class="bi bi-code-square me-2"></i>Underlying JSP Source Code</h5>
                    <pre class="bg-black p-3 rounded-3 text-light small overflow-auto" style="max-height: 380px;"><code>&lt;%-- 1. Declaration (Field &amp; Method) --%&gt;
&lt;%!
    private int globalVisitorCount = 0;
    public synchronized int incrementVisitCounter() {
        return ++globalVisitorCount;
    }
%&gt;

&lt;%-- 2. Scriptlet (Inside _jspService) --%&gt;
&lt;%
    int currentVisitor = incrementVisitCounter();
    String systemArchitecture = "Jakarta EE";
%&gt;

&lt;%-- 3. Expression (Auto-printed to out) --%&gt;
&lt;h3&gt;Visit Count: &lt;%= currentVisitor %&gt;&lt;/h3&gt;

&lt;%-- 4. Modern Expression Language --%&gt;
&lt;p&gt;Student: \${demoStudentName}&lt;/p&gt;</code></pre>
                    <div class="small text-light text-opacity-75 mt-2">
                        <strong>Viva Concept:</strong> During first request, Tomcat compiles this page into a Java servlet (<code>traditional_002djsp_jsp.class</code>) that extends <code>HttpJspBase</code>.
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/fragments/footer.jsp"/>
