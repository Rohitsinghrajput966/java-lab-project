<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="JSTL SQL Tag Demo" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/navbar.jsp"/>

<div class="container my-5">
    <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-4">
        <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill fw-bold mb-3" style="width: fit-content;">
            RTU Advanced Java Syllabus Topic: JSTL SQL
        </span>
        <h2 class="fw-bold text-dark mb-2">JSTL SQL Tag Library &amp; Architectural Contrast</h2>
        <p class="text-muted mb-4">
            Analysis of JSTL SQL tags (&lt;sql:setDataSource&gt;, &lt;sql:query&gt;, &lt;sql:update&gt;) and why production enterprise applications replace them with DAO/Service layers.
        </p>

        <div class="row g-4 mb-4">
            <!-- JSTL SQL Direct Approach -->
            <div class="col-lg-6">
                <div class="card border rounded-4 p-4 bg-light h-100">
                    <h5 class="fw-bold mb-3 text-danger"><i class="bi bi-x-circle-fill me-2"></i>Legacy Approach: JSTL &lt;sql:query&gt;</h5>
                    <p class="small text-muted mb-3">Embedding SQL statements directly inside presentation JSP files:</p>

                    <pre class="bg-dark p-3 rounded-3 text-light small overflow-auto"><code>&lt;%-- 1. Establish DataSource in JSP --%&gt;
&lt;sql:setDataSource var="db"
    driver="com.mysql.cj.jdbc.Driver"
    url="jdbc:mysql://localhost:3306/shopsphere"
    user="root" password="secret"/&gt;

&lt;%-- 2. Execute Query inside View --%&gt;
&lt;sql:query dataSource="\${db}" var="result"&gt;
    SELECT * FROM products WHERE stock &gt; 0
&lt;/sql:query&gt;

&lt;%-- 3. Render directly in HTML table --%&gt;
&lt;c:forEach var="row" items="\${result.rows}"&gt;
    &lt;tr&gt;&lt;td&gt;\${row.name}&lt;/td&gt;&lt;td&gt;\${row.price}&lt;/td&gt;&lt;/tr&gt;
&lt;/c:forEach&gt;</code></pre>

                    <div class="alert alert-warning small rounded-3 mt-3 mb-0">
                        <strong>Architectural Flaw:</strong> Violates MVC separation of concerns, exposes database credentials to the view, makes unit testing impossible, and creates security risks.
                    </div>
                </div>
            </div>

            <!-- Modern Production 3-Tier DAO Approach -->
            <div class="col-lg-6">
                <div class="card border rounded-4 p-4 bg-light h-100">
                    <h5 class="fw-bold mb-3 text-success"><i class="bi bi-check-circle-fill me-2"></i>shopsphere Production: N-Tier DAO</h5>
                    <p class="small text-muted mb-3">Enterprise decoupling: Controller &rarr; Service &rarr; DAO &rarr; Connection Pool:</p>

                    <div class="p-3 bg-white rounded-3 border mb-3 small">
                        <div class="fw-bold text-primary mb-1">1. Presentation Tier (JSP View)</div>
                        <p class="text-muted mb-0">Clean EL/JSTL iteration: <code>&lt;c:forEach items="\${products}" var="p"&gt;</code></p>
                    </div>

                    <div class="p-3 bg-white rounded-3 border mb-3 small">
                        <div class="fw-bold text-dark mb-1">2. Controller Tier (Jakarta Servlet)</div>
                        <p class="text-muted mb-0"><code>ProductServlet</code> intercepts requests, parses query parameters, and manages HTTP state.</p>
                    </div>

                    <div class="p-3 bg-white rounded-3 border mb-3 small">
                        <div class="fw-bold text-dark mb-1">3. Service &amp; DAO Layer (HikariCP)</div>
                        <p class="text-muted mb-0"><code>ProductService</code> &rarr; <code>ProductDAO</code> executes parameterized <code>PreparedStatement</code> on pooled connections.</p>
                    </div>

                    <div class="alert alert-success small rounded-3 mb-0">
                        <strong>Production Standard:</strong> 100% immune to SQL injection, enables ACID transaction rollbacks, connection reuse via HikariCP, and mockable unit tests.
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/fragments/footer.jsp"/>

