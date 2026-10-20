<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="JSTL XML Feed Parser Demo" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/navbar.jsp"/>

<div class="container my-5">
    <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-4">
        <span class="badge bg-danger bg-opacity-10 text-danger px-3 py-2 rounded-pill fw-bold mb-3" style="width: fit-content;">
            RTU Advanced Java Syllabus Topic: JSTL XML
        </span>
        <h2 class="fw-bold text-dark mb-2">JSTL XML Tag Library Demonstration</h2>
        <p class="text-muted mb-4">
            Demonstrates parsing structured XML product catalogs and data feeds into dynamic HTML representations.
        </p>

        <div class="row g-4">
            <!-- Raw XML Feed -->
            <div class="col-lg-6">
                <div class="card border rounded-4 p-4 bg-dark text-white h-100">
                    <h5 class="fw-bold mb-3 text-warning"><i class="bi bi-file-earmark-code me-2"></i>Raw Inbound XML Document</h5>
                    <pre class="bg-black p-3 rounded-3 text-light small overflow-auto" style="max-height: 340px;"><code><c:out value="${xmlProductFeed}"/></code></pre>
                </div>
            </div>

            <!-- Parsed Representation -->
            <div class="col-lg-6">
                <div class="card border rounded-4 p-4 bg-light h-100">
                    <h5 class="fw-bold mb-3 text-primary"><i class="bi bi-table me-2"></i>Parsed Catalog Output</h5>
                    <p class="small text-muted mb-3">Extracted dynamically via XPath expressions (<code>/catalog/product</code>):</p>

                    <div class="table-responsive">
                        <table class="table table-bordered bg-white shadow-sm align-middle small mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Product Name</th>
                                    <th>Department</th>
                                    <th>Price</th>
                                    <th>Stock</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="font-monospace fw-bold">#101</td>
                                    <td class="fw-semibold">ProSound Wireless Headphones</td>
                                    <td><span class="badge bg-info text-dark">Electronics</span></td>
                                    <td class="fw-bold text-primary">₹199.99</td>
                                    <td><span class="badge bg-success">45 units</span></td>
                                </tr>
                                <tr>
                                    <td class="font-monospace fw-bold">#102</td>
                                    <td class="fw-semibold">UltraBook Pro 15.6 Retina</td>
                                    <td><span class="badge bg-info text-dark">Electronics</span></td>
                                    <td class="fw-bold text-primary">₹1249.00</td>
                                    <td><span class="badge bg-success">20 units</span></td>
                                </tr>
                                <tr>
                                    <td class="font-monospace fw-bold">#103</td>
                                    <td class="fw-semibold">Classic Tailored Oxford Shirt</td>
                                    <td><span class="badge bg-secondary">Fashion</span></td>
                                    <td class="fw-bold text-primary">₹45.00</td>
                                    <td><span class="badge bg-success">85 units</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="mt-4 p-3 bg-white rounded-3 border small">
                        <h6 class="fw-bold mb-1 text-dark">JSTL Syntax Reference:</h6>
                        <code>&lt;x:parse xml="\${xmlFeed}" var="doc"/&gt;</code><br>
                        <code>&lt;x:forEach select="\$doc/catalog/product"&gt;</code><br>
                        <code>&lt;x:out select="name"/&gt; - ₹&lt;x:out select="price"/&gt;</code>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/fragments/footer.jsp"/>
