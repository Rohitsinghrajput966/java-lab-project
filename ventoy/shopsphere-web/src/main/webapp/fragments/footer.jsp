<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<footer class="py-5 mt-5">
    <div class="container">
        <div class="row g-4 justify-content-between">
            <div class="col-12 col-lg-4">
                <div class="d-flex align-items-center gap-2 mb-3">
                    <img src="${pageContext.request.contextPath}/assets/img/shopsphere-logo-light.svg"
                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/shopsphere-logo-light.svg';"
                         alt="ShopSphere Mega Store" style="height: 38px; width: auto; object-fit: contain;">
                </div>
                <p class="small text-secondary mb-3 leading-relaxed">
                    ShopSphere is India's leading modern e-commerce destination for smartphones, ultrabooks, wireless audio, premium apparel, sneakers, and smart living gear. 100% genuine products with fast pan-India delivery.
                </p>
                <div class="d-flex flex-wrap gap-2">
                    <span class="badge bg-secondary bg-opacity-25 text-light border border-secondary border-opacity-25 rounded-pill px-3 py-1.5 small">100% Genuine</span>
                    <span class="badge bg-secondary bg-opacity-25 text-light border border-secondary border-opacity-25 rounded-pill px-3 py-1.5 small">Express Delivery</span>
                    <span class="badge bg-secondary bg-opacity-25 text-light border border-secondary border-opacity-25 rounded-pill px-3 py-1.5 small">Easy 7-Day Returns</span>
                    <span class="badge bg-secondary bg-opacity-25 text-light border border-secondary border-opacity-25 rounded-pill px-3 py-1.5 small">256-Bit SSL Pay</span>
                </div>
            </div>

            <div class="col-6 col-md-3 col-lg-2">
                <h6 class="text-white fw-bold mb-3 text-uppercase small" style="letter-spacing: 1px;">Customer Care</h6>
                <ul class="list-unstyled small d-flex flex-column gap-2 mb-0">
                    <li><a href="${pageContext.request.contextPath}/orders">Order Tracking</a></li>
                    <li><a href="${pageContext.request.contextPath}/wishlist">Saved Wishlist</a></li>
                    <li><a href="${pageContext.request.contextPath}/cart">Shopping Cart</a></li>
                    <li><a href="${pageContext.request.contextPath}/profile">My Profile</a></li>
                    <li><a href="${pageContext.request.contextPath}/login">Member Sign In</a></li>
                </ul>
            </div>

            <div class="col-6 col-md-3 col-lg-2">
                <h6 class="text-white fw-bold mb-3 text-uppercase small" style="letter-spacing: 1px;">Popular Categories</h6>
                <ul class="list-unstyled small d-flex flex-column gap-2 mb-0">
                    <li><a href="${pageContext.request.contextPath}/products?category=1">Smartphones &amp; Tablets</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?category=2">Laptops &amp; Computers</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?category=3">Audio &amp; Headphones</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?category=4">Smartwatches</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?category=5">Men's Fashion</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?category=7">Footwear &amp; Sneakers</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?category=8">Smart Home &amp; Kitchen</a></li>
                </ul>
            </div>

            <div class="col-12 col-md-6 col-lg-3">
                <h6 class="text-white fw-bold mb-3 text-uppercase small" style="letter-spacing: 1px;">Stay Updated</h6>
                <p class="small text-secondary mb-3">
                    Subscribe for exclusive tech drop alerts, seasonal discount vouchers, and mega sale offers.
                </p>
                <div class="input-group mb-2">
                    <input type="email" class="form-control rounded-start-pill bg-dark text-white border-secondary border-opacity-50 small shadow-none" placeholder="Enter your email" aria-label="Newsletter email">
                    <button class="btn btn-primary rounded-end-pill px-3 fw-semibold small" type="button" onclick="alert('Thank you for subscribing to ShopSphere Insider!')">Join</button>
                </div>
                <span class="small text-muted d-block" style="font-size: 0.75rem;">100% spam-free. Unsubscribe anytime.</span>
            </div>
        </div>

    </div>
</footer>

<!-- Bootstrap 5.3 Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>

