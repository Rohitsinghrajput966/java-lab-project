<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="JNDI Resource Lookup Demo" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/navbar.jsp"/>

<div class="container my-5">
    <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-4">
        <span class="badge bg-warning text-dark px-3 py-2 rounded-pill fw-bold mb-3" style="width: fit-content;">
            RTU Advanced Java Syllabus Topic: Naming and JNDI
        </span>
        <h2 class="fw-bold text-dark mb-2">Java Naming &amp; Directory Interface (JNDI) Demonstration</h2>
        <p class="text-muted mb-4">
            Demonstrating how J2EE web containers bind enterprise managed resources (DataSource pools, JMS connection factories, EJB components) into the <code>java:comp/env</code> namespace.
        </p>

        <div class="row g-4">
            <div class="col-lg-6">
                <div class="card border rounded-4 p-4 bg-light h-100">
                    <h5 class="fw-bold mb-3 text-dark"><i class="bi bi-diagram-3-fill text-warning me-2"></i>JNDI Environment Context</h5>

                    <div class="mb-3 p-3 bg-white rounded-3 border">
                        <span class="text-muted small d-block">Configured JNDI J2EE JNDI Name:</span>
                        <code class="fs-6 text-primary">${jndiResourceName}</code>
                    </div>

                    <div class="mb-3 p-3 bg-white rounded-3 border">
                        <span class="text-muted small d-block">Container Resolution Status:</span>
                        <span class="fw-semibold text-success"><i class="bi bi-check-circle me-1"></i> ${jndiLookupStatus}</span>
                    </div>

                    <div class="p-3 bg-white rounded-3 border small">
                        <span class="fw-bold text-dark d-block mb-1">Standard JNDI Java Lookup Syntax:</span>
                        <pre class="bg-dark text-white p-2 rounded-2 mb-0"><code>Context initCtx = new InitialContext();
Context envCtx = (Context) initCtx.lookup("java:comp/env");
DataSource ds = (DataSource) envCtx.lookup("jdbc/shopsphereDS");
Connection conn = ds.getConnection();</code></pre>
                    </div>
                </div>
            </div>

            <div class="col-lg-6">
                <div class="card border rounded-4 p-4 bg-dark text-white h-100">
                    <h5 class="fw-bold mb-3 text-warning"><i class="bi bi-gear-wide-connected me-2"></i>Tomcat <code>context.xml</code> Configuration</h5>
                    <pre class="bg-black p-3 rounded-3 text-light small overflow-auto"><code>&lt;Context&gt;
    &lt;Resource name="jdbc/shopsphereDS"
              auth="Container"
              type="javax.sql.DataSource"
              maxTotal="20"
              maxIdle="10"
              maxWaitMillis="-1"
              username="shopsphere_user"
              password="shopsphere_pass"
              driverClassName="com.mysql.cj.jdbc.Driver"
              url="jdbc:mysql://localhost:3306/shopsphere"/&gt;
&lt;/Context&gt;</code></pre>
                    <div class="small text-light text-opacity-75 mt-2">
                        <strong>Viva Concept:</strong> JNDI abstracts physical database configurations away from the application binary. The database credentials remain in the servlet container configuration.
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/fragments/footer.jsp"/>

