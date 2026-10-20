<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<c:set var="pageTitle" value="Online Shopping for Electronics, Laptops, Fashion & Home" scope="request"/>
<jsp:include page="/fragments/header.jsp"/>
<jsp:include page="/fragments/navbar.jsp"/>

<div class="container my-3">
    <!-- Top Category Quick Bar (Universal Multi-Category) -->
    <div class="bg-white rounded-4 shadow-sm p-3 mb-4 border">
        <div class="d-flex align-items-center justify-content-between overflow-auto gap-3 text-center py-1">
            <a href="${pageContext.request.contextPath}/products?category=1" class="text-decoration-none text-dark flex-shrink-0 px-2 hover-primary">
                <div class="rounded-circle bg-primary bg-opacity-10 text-primary p-2.5 mx-auto mb-1 d-inline-flex" style="width: 48px; height: 48px; align-items: center; justify-content: center;">
                    <i class="bi bi-phone fs-5"></i>
                </div>
                <div class="small fw-bold">Smartphones</div>
            </a>
            <a href="${pageContext.request.contextPath}/products?category=2" class="text-decoration-none text-dark flex-shrink-0 px-2 hover-primary">
                <div class="rounded-circle bg-info bg-opacity-10 text-info p-2.5 mx-auto mb-1 d-inline-flex" style="width: 48px; height: 48px; align-items: center; justify-content: center;">
                    <i class="bi bi-laptop fs-5"></i>
                </div>
                <div class="small fw-bold">Laptops &amp; PCs</div>
            </a>
            <a href="${pageContext.request.contextPath}/products?category=3" class="text-decoration-none text-dark flex-shrink-0 px-2 hover-primary">
                <div class="rounded-circle bg-success bg-opacity-10 text-success p-2.5 mx-auto mb-1 d-inline-flex" style="width: 48px; height: 48px; align-items: center; justify-content: center;">
                    <i class="bi bi-headphones fs-5"></i>
                </div>
                <div class="small fw-bold">Audio &amp; Sound</div>
            </a>
            <a href="${pageContext.request.contextPath}/products?category=4" class="text-decoration-none text-dark flex-shrink-0 px-2 hover-primary">
                <div class="rounded-circle bg-warning bg-opacity-10 text-warning p-2.5 mx-auto mb-1 d-inline-flex" style="width: 48px; height: 48px; align-items: center; justify-content: center;">
                    <i class="bi bi-smartwatch fs-5 text-dark"></i>
                </div>
                <div class="small fw-bold">Smartwatches</div>
            </a>
            <a href="${pageContext.request.contextPath}/products?category=5" class="text-decoration-none text-dark flex-shrink-0 px-2 hover-primary">
                <div class="rounded-circle bg-primary bg-opacity-10 text-primary p-2.5 mx-auto mb-1 d-inline-flex" style="width: 48px; height: 48px; align-items: center; justify-content: center;">
                    <i class="bi bi-person fs-5"></i>
                </div>
                <div class="small fw-bold">Men's Style</div>
            </a>
            <a href="${pageContext.request.contextPath}/products?category=6" class="text-decoration-none text-dark flex-shrink-0 px-2 hover-primary">
                <div class="rounded-circle bg-danger bg-opacity-10 text-danger p-2.5 mx-auto mb-1 d-inline-flex" style="width: 48px; height: 48px; align-items: center; justify-content: center;">
                    <i class="bi bi-stars fs-5"></i>
                </div>
                <div class="small fw-bold">Women's Style</div>
            </a>
            <a href="${pageContext.request.contextPath}/products?category=7" class="text-decoration-none text-dark flex-shrink-0 px-2 hover-primary">
                <div class="rounded-circle bg-dark bg-opacity-10 text-dark p-2.5 mx-auto mb-1 d-inline-flex" style="width: 48px; height: 48px; align-items: center; justify-content: center;">
                    <i class="bi bi-bag-check fs-5"></i>
                </div>
                <div class="small fw-bold">Footwear &amp; Kicks</div>
            </a>
            <a href="${pageContext.request.contextPath}/products?category=8" class="text-decoration-none text-dark flex-shrink-0 px-2 hover-primary">
                <div class="rounded-circle bg-secondary bg-opacity-10 text-secondary p-2.5 mx-auto mb-1 d-inline-flex" style="width: 48px; height: 48px; align-items: center; justify-content: center;">
                    <i class="bi bi-house-gear fs-5 text-primary"></i>
                </div>
                <div class="small fw-bold">Smart Home</div>
            </a>
            <a href="${pageContext.request.contextPath}/products?category=9" class="text-decoration-none text-dark flex-shrink-0 px-2 hover-primary">
                <div class="rounded-circle bg-info bg-opacity-10 text-info p-2.5 mx-auto mb-1 d-inline-flex" style="width: 48px; height: 48px; align-items: center; justify-content: center;">
                    <i class="bi bi-camera fs-5"></i>
                </div>
                <div class="small fw-bold">Cameras &amp; Drones</div>
            </a>
        </div>
    </div>

    <!-- Wide Panoramic Mega Hero Banner -->
    <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4 position-relative" style="min-height: 420px; background: #0f172a;">
        <!-- Banner Image -->
        <img src="${pageContext.request.contextPath}/assets/img/hero-tech-showcase.jpg"
             onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=1600&auto=format&fit=crop&q=85';"
             alt="ShopSphere Mega Electronics &amp; Lifestyle Sale"
             class="w-100 h-100 object-fit-cover position-absolute top-0 start-0 opacity-80"
             style="object-position: right center;">

        <!-- Left Content with Translucent Gradient -->
        <div class="position-relative h-100 d-flex align-items-center" style="min-height: 420px; z-index: 2; background: linear-gradient(90deg, rgba(15, 23, 42, 0.94) 0%, rgba(15, 23, 42, 0.85) 45%, rgba(15, 23, 42, 0.45) 70%, rgba(15, 23, 42, 0.1) 100%);">
            <div class="col-12 col-md-7 col-lg-6 p-4 p-md-5 text-white">
                <div class="d-inline-flex align-items-center gap-2 mb-3">
                    <span class="badge bg-primary bg-opacity-25 text-info border border-info border-opacity-25 rounded-pill px-3 py-1.5 fw-bold font-monospace small">
                        <i class="bi bi-lightning-charge-fill text-warning me-1"></i> MEGA SUPER SALE
                    </span>
                    <span class="badge bg-success bg-opacity-25 text-success border border-success border-opacity-25 rounded-pill px-2.5 py-1 fw-bold small">
                        UP TO 60% OFF
                    </span>
                </div>
                <h1 class="display-6 fw-black text-white mb-2 tracking-tight">
                    Next-Gen Tech &amp; Everyday Lifestyle.
                </h1>
                <p class="text-white-50 small mb-4 leading-relaxed" style="max-width: 480px;">
                    Discover flagship 5G smartphones, M3 ultrabooks, ANC headphones, trending apparel &amp; smart appliances with verified warranty.
                </p>
                <div class="p-3 rounded-4 bg-dark bg-opacity-50 border border-secondary border-opacity-25 mb-4 shadow-2xs" style="max-width: 440px; backdrop-filter: blur(8px);">
                    <div class="d-flex align-items-center justify-content-between mb-1">
                        <span class="text-white-50 small">Special Coupon Code:</span>
                        <span class="badge bg-primary text-white font-monospace px-2.5 py-1">FLAT20</span>
                    </div>
                    <div class="fw-bold text-white small">Get Flat ₹200 Instant Discount on orders over ₹1,500!</div>
                </div>
                <div class="d-flex flex-wrap gap-2.5">
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill px-4 py-2.5 fw-bold shadow d-inline-flex align-items-center gap-2">
                        <span>Browse Catalog</span>
                        <i class="bi bi-arrow-right"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/products?category=1" class="btn btn-outline-light rounded-pill px-4 py-2.5 fw-bold">
                        <span>Smartphones</span>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- 4 Universal Value Pillars -->
    <div class="row g-3 mb-5">
        <div class="col-6 col-md-3">
            <div class="p-3 rounded-4 bg-white border shadow-2xs text-center h-100">
                <i class="bi bi-patch-check-fill fs-2 text-primary mb-2 d-block"></i>
                <h6 class="fw-bold mb-1 small text-dark">100% Genuine Brands</h6>
                <p class="text-muted mb-0" style="font-size: 0.75rem;">Directly sourced with brand warranty</p>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="p-3 rounded-4 bg-white border shadow-2xs text-center h-100">
                <i class="bi bi-truck fs-2 text-success mb-2 d-block"></i>
                <h6 class="fw-bold mb-1 small text-dark">Express Pan-India Delivery</h6>
                <p class="text-muted mb-0" style="font-size: 0.75rem;">Dispatched within 24 hours</p>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="p-3 rounded-4 bg-white border shadow-2xs text-center h-100">
                <i class="bi bi-arrow-counterclockwise fs-2 text-warning mb-2 d-block"></i>
                <h6 class="fw-bold mb-1 small text-dark">7-Day Easy Returns</h6>
                <p class="text-muted mb-0" style="font-size: 0.75rem;">Hassle-free instant replacement</p>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="p-3 rounded-4 bg-white border shadow-2xs text-center h-100">
                <i class="bi bi-shield-lock-fill fs-2 text-info mb-2 d-block"></i>
                <h6 class="fw-bold mb-1 small text-dark">Safe UPI, Cards &amp; COD</h6>
                <p class="text-muted mb-0" style="font-size: 0.75rem;">256-Bit SSL encrypted payments</p>
            </div>
        </div>
    </div>

    <!-- SECTION 1: Flagship Smartphones & Computing -->
    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-5">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom gap-2">
            <div>
                <span class="badge bg-primary bg-opacity-10 text-primary rounded-pill px-2.5 py-1 fw-bold small mb-1">TECH SPOTLIGHT</span>
                <h4 class="fw-bold mb-0 text-dark">Flagship Smartphones &amp; Ultrabooks</h4>
                <span class="text-muted small">Apple iPhone 15 Pro, Samsung Galaxy S24 Ultra, MacBook Air M3 &amp; Dell XPS</span>
            </div>
            <a href="${pageContext.request.contextPath}/products?category=1" class="btn btn-outline-primary btn-sm rounded-pill px-4 fw-semibold">
                View All Mobiles &rarr;
            </a>
        </div>

        <div class="row">
            <c:forEach var="prod" items="${techProducts}">
                <tags:productCard product="${prod}" />
            </c:forEach>
        </div>
    </div>

    <!-- SECTION 2: Trending Fashion & Sneakers -->
    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-5">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom gap-2">
            <div>
                <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-2.5 py-1 fw-bold small mb-1">FASHION &amp; KICKS</span>
                <h4 class="fw-bold mb-0 text-dark">Men's &amp; Women's Streetwear &amp; Sneakers</h4>
                <span class="text-muted small">Levi's Denim, Nike Air Max, Adidas Ultraboost &amp; Tailored Outerwear</span>
            </div>
            <a href="${pageContext.request.contextPath}/products?category=5" class="btn btn-outline-primary btn-sm rounded-pill px-4 fw-semibold">
                Explore Fashion &rarr;
            </a>
        </div>

        <div class="row">
            <c:forEach var="prod" items="${fashionProducts}">
                <tags:productCard product="${prod}" />
            </c:forEach>
        </div>
    </div>

    <!-- Dual Highlights Promo Banner -->
    <div class="row g-4 mb-5">
        <div class="col-md-6">
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden position-relative p-4 p-md-5 text-white" style="background: linear-gradient(135deg, #1e1b4b 0%, #2563eb 100%);">
                <span class="badge bg-white text-primary rounded-pill px-3 py-1 fw-bold mb-3 align-self-start small">SPATIAL AUDIO</span>
                <h3 class="fw-bold mb-2">Wireless ANC &amp; High-Res Sound</h3>
                <p class="text-white-50 small mb-4">Sony WH-1000XM5, AirPods Pro, Bose Ultra &amp; Marshall Bluetooth Speakers.</p>
                <a href="${pageContext.request.contextPath}/products?category=3" class="btn btn-light rounded-pill px-4 py-2 fw-bold text-primary shadow-xs align-self-start">
                    Explore Audio &rarr;
                </a>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden position-relative p-4 p-md-5 text-white" style="background: linear-gradient(135deg, #0f172a 0%, #334155 100%);">
                <span class="badge bg-white text-dark rounded-pill px-3 py-1 fw-bold mb-3 align-self-start small">SMART LIVING</span>
                <h3 class="fw-bold mb-2">Home Automation &amp; Appliances</h3>
                <p class="text-white-50 small mb-4">Dyson laser vacuums, Nespresso espresso machines &amp; smart air purifiers.</p>
                <a href="${pageContext.request.contextPath}/products?category=8" class="btn btn-light rounded-pill px-4 py-2 fw-bold text-dark shadow-xs align-self-start">
                    Discover Smart Home &rarr;
                </a>
            </div>
        </div>
    </div>

    <!-- SECTION 3: Smart Audio, Wearables & Cameras -->
    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-5">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom gap-2">
            <div>
                <span class="badge bg-warning bg-opacity-25 text-dark rounded-pill px-2.5 py-1 fw-bold small mb-1">SMART GADGETS</span>
                <h4 class="fw-bold mb-0 text-dark">Smartwatches, Wireless Audio &amp; Drones</h4>
                <span class="text-muted small">Apple Watch Series 9, Galaxy Watch 6, Sony A7 IV &amp; DJI 4K Drones</span>
            </div>
            <a href="${pageContext.request.contextPath}/products?category=4" class="btn btn-outline-primary btn-sm rounded-pill px-4 fw-semibold">
                View Gadgets &rarr;
            </a>
        </div>

        <div class="row">
            <c:forEach var="prod" items="${audioProducts}">
                <tags:productCard product="${prod}" />
            </c:forEach>
        </div>
    </div>

    <!-- SECTION 4: Fresh Mega Arrivals -->
    <c:if test="${not empty newArrivals}">
        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-5">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom gap-2">
                <div>
                    <span class="badge bg-info bg-opacity-10 text-info rounded-pill px-2.5 py-1 fw-bold small mb-1">NEW ARRIVALS</span>
                    <h4 class="fw-bold mb-0 text-dark">Latest Products Just Added</h4>
                    <span class="text-muted small">Freshly stocked flagships, sneakers &amp; appliances</span>
                </div>
                <a href="${pageContext.request.contextPath}/products?sort=newest" class="btn btn-outline-primary btn-sm rounded-pill px-4 fw-semibold">
                    Browse All Catalog &rarr;
                </a>
            </div>

            <div class="row">
                <c:forEach var="prod" items="${newArrivals}">
                    <tags:productCard product="${prod}" />
                </c:forEach>
            </div>
        </div>
    </c:if>

    <!-- Verified Customer Reviews -->
    <div class="mb-5">
        <div class="text-center mb-4">
            <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-1.5 rounded-pill fw-bold mb-2">VERIFIED REVIEWS</span>
            <h3 class="fw-bold text-dark">Trusted by Shoppers Across India</h3>
            <p class="text-muted small">Read genuine reviews from verified customers.</p>
        </div>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                    <div class="d-flex align-items-center gap-1 text-warning mb-2">
                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                    </div>
                    <p class="text-secondary small mb-3">"The iPhone 15 Pro Max arrived in mint sealed condition within 24 hours. Super fast delivery and the FLAT20 coupon saved me extra cash!"</p>
                    <div class="d-flex align-items-center gap-2 mt-auto pt-2 border-top">
                        <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-flex align-items-center justify-content-center fw-bold" style="width: 32px; height: 32px; font-size: 0.8rem;">R</div>
                        <div>
                            <div class="fw-bold small">Rohit Sharma</div>
                            <span class="text-muted" style="font-size: 0.7rem;">Verified Buyer &bull; Mumbai</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                    <div class="d-flex align-items-center gap-1 text-warning mb-2">
                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                    </div>
                    <p class="text-secondary small mb-3">"MacBook Air M3 is an absolute beast for software development. ShopSphere price and pan-India warranty registration was effortless."</p>
                    <div class="d-flex align-items-center gap-2 mt-auto pt-2 border-top">
                        <div class="bg-success bg-opacity-10 text-success rounded-circle d-flex align-items-center justify-content-center fw-bold" style="width: 32px; height: 32px; font-size: 0.8rem;">P</div>
                        <div>
                            <div class="fw-bold small">Priya Patel</div>
                            <span class="text-muted" style="font-size: 0.7rem;">Verified Buyer &bull; Bengaluru</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                    <div class="d-flex align-items-center gap-1 text-warning mb-2">
                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                    </div>
                    <p class="text-secondary small mb-3">"Sony WH-1000XM5 noise cancellation is unmatched. Original sealed box, prompt delivery, and pristine packaging."</p>
                    <div class="d-flex align-items-center gap-2 mt-auto pt-2 border-top">
                        <div class="bg-warning bg-opacity-25 text-dark rounded-circle d-flex align-items-center justify-content-center fw-bold" style="width: 32px; height: 32px; font-size: 0.8rem;">A</div>
                        <div>
                            <div class="fw-bold small">Ananya Verma</div>
                            <span class="text-muted" style="font-size: 0.7rem;">Verified Buyer &bull; Delhi</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/fragments/footer.jsp"/>
