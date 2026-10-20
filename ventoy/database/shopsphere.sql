-- ==============================================================================
-- shopsphere Enterprise E-Commerce Platform Database Schema
-- Compatible with MySQL 8.0+
-- Database: shopsphere
-- ==============================================================================

CREATE DATABASE IF NOT EXISTS shopsphere CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE shopsphere;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS coupon_usage;
DROP TABLE IF EXISTS coupons;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS wishlist;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

-- ------------------------------------------------------------------------------
-- 1. USERS TABLE
-- ------------------------------------------------------------------------------
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Stored as BCrypt salted hash
    mobile VARCHAR(20) DEFAULT NULL,
    role ENUM('CUSTOMER', 'ADMIN') NOT NULL DEFAULT 'CUSTOMER',
    status ENUM('ACTIVE', 'INACTIVE', 'SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_email (email),
    INDEX idx_user_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 2. ADDRESSES TABLE
-- ------------------------------------------------------------------------------
CREATE TABLE addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    address_line VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    pincode VARCHAR(20) NOT NULL,
    address_type ENUM('HOME', 'WORK', 'BILLING') NOT NULL DEFAULT 'HOME',
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_address_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_address_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 3. CATEGORIES TABLE
-- ------------------------------------------------------------------------------
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(120) NOT NULL UNIQUE,
    description TEXT,
    image_url VARCHAR(500) DEFAULT NULL,
    status BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_category_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 4. PRODUCTS TABLE
-- ------------------------------------------------------------------------------
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    brand VARCHAR(100) DEFAULT 'Generic',
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(5, 2) DEFAULT 0.00, -- Percentage discount (e.g. 10.00 for 10%)
    stock INT NOT NULL DEFAULT 0,
    image_url VARCHAR(500) DEFAULT NULL,
    status BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT,
    INDEX idx_product_category (category_id),
    INDEX idx_product_name (name),
    INDEX idx_product_status_stock (status, stock)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 5. CART TABLE
-- ------------------------------------------------------------------------------
CREATE TABLE cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_cart_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_cart_product FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    UNIQUE KEY uq_cart_user_product (user_id, product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 6. WISHLIST TABLE
-- ------------------------------------------------------------------------------
CREATE TABLE wishlist (
    wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_wishlist_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_wishlist_product FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    UNIQUE KEY uq_wishlist_user_product (user_id, product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 7. ORDERS TABLE
-- ------------------------------------------------------------------------------
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    address_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,       -- Subtotal before discount
    discount DECIMAL(10, 2) DEFAULT 0.00,       -- Absolute discount applied
    shipping_fee DECIMAL(10, 2) DEFAULT 0.00,   -- Shipping charges
    final_amount DECIMAL(10, 2) NOT NULL,       -- Payable amount
    payment_method ENUM('CARD', 'UPI', 'NET_BANKING', 'COD') NOT NULL DEFAULT 'COD',
    payment_status ENUM('PENDING', 'PAID', 'FAILED', 'REFUNDED') NOT NULL DEFAULT 'PENDING',
    order_status ENUM('PENDING', 'CONFIRMED', 'SHIPPED', 'DELIVERED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT,
    CONSTRAINT fk_order_address FOREIGN KEY (address_id) REFERENCES addresses(address_id) ON DELETE RESTRICT,
    INDEX idx_order_user (user_id),
    INDEX idx_order_status (order_status),
    INDEX idx_order_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 8. ORDER_ITEMS TABLE
-- ------------------------------------------------------------------------------
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL, -- Historical price at time of purchase
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_item_order FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_order_item_product FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT,
    INDEX idx_order_item_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 9. PAYMENTS TABLE
-- ------------------------------------------------------------------------------
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    transaction_reference VARCHAR(100) NOT NULL UNIQUE,
    amount DECIMAL(10, 2) NOT NULL,
    payment_status VARCHAR(30) NOT NULL DEFAULT 'SUCCESS',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_order FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    INDEX idx_payment_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 10. REVIEWS TABLE
-- ------------------------------------------------------------------------------
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    rating TINYINT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_review_product FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    INDEX idx_review_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 11. COUPONS TABLE
-- ------------------------------------------------------------------------------
CREATE TABLE coupons (
    coupon_id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    discount_type ENUM('PERCENTAGE', 'FIXED') NOT NULL DEFAULT 'PERCENTAGE',
    discount_value DECIMAL(10, 2) NOT NULL,
    minimum_order DECIMAL(10, 2) DEFAULT 0.00,
    maximum_discount DECIMAL(10, 2) DEFAULT NULL,
    expiry_date DATETIME NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_coupon_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 12. COUPON_USAGE TABLE
-- ------------------------------------------------------------------------------
CREATE TABLE coupon_usage (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    coupon_id INT NOT NULL,
    user_id INT NOT NULL,
    order_id INT NOT NULL,
    used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usage_coupon FOREIGN KEY (coupon_id) REFERENCES coupons(coupon_id) ON DELETE CASCADE,
    CONSTRAINT fk_usage_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_usage_order FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    INDEX idx_usage_user_coupon (user_id, coupon_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==============================================================================
-- INITIAL SEED DATA
-- Default Passwords (Authentic Hindi Logins):
-- Admin:    Pooja@123     (BCrypt: $2a$12$Ia5CpVXWK9kAwWTTIPqwUehbhF5SLRW6GmnTCmc5zmUKBM2RXGHZi)
-- Customer: Priya@123     (BCrypt: $2a$12$Edi4nniqQcf8uq6HpdZvLO8LMrntk9zvfVXU3uyD83IrmevDu93ze)
-- ==============================================================================

-- Seed Users
INSERT INTO users (user_id, name, email, password, mobile, role, status) VALUES
(1, 'Pooja Sharma', 'rohit@.com', '$2a$12$Ia5CpVXWK9kAwWTTIPqwUehbhF5SLRW6GmnTCmc5zmUKBM2RXGHZi', '9876543210', 'ADMIN', 'ACTIVE'),
(2, 'Priya Patel', 'priya@shopsphere.com', '$2a$12$Edi4nniqQcf8uq6HpdZvLO8LMrntk9zvfVXU3uyD83IrmevDu93ze', '9876543211', 'CUSTOMER', 'ACTIVE'),
(3, 'Ananya Verma', 'ananya@shopsphere.com', '$2a$12$.zNtCxXjukuVj7SAv/EvoOVWMDbY/.s34IZaO.TW7wDZ.NK03A3hu', '9876543212', 'CUSTOMER', 'ACTIVE'),
(4, 'Rohit Kumar', 'rohit@shopsphere.com', '$2a$12$bFnw8HLRJ3tjMyFqzR8Z3uOWBcQ98Bo6ockN/6CJUQRpckVvV9zn.', '9876543213', 'CUSTOMER', 'ACTIVE');

-- Seed Addresses
INSERT INTO addresses (address_id, user_id, address_line, city, state, pincode, address_type, is_default) VALUES
(1, 2, 'Flat 402, Lotus Boutique Heights, Bandra West', 'Mumbai', 'Maharashtra', '400050', 'HOME', TRUE),
(2, 2, 'Design Studio, DLF Phase 2', 'Gurugram', 'Haryana', '122002', 'WORK', FALSE),
(3, 3, '124 Lake View Apartments, Powai', 'Mumbai', 'Maharashtra', '400076', 'HOME', TRUE);

-- Seed Categories (Multi-Category Modern E-Commerce)
INSERT INTO categories (category_id, name, slug, description, image_url, status) VALUES
(1, 'Smartphones & Tablets', 'smartphones-tablets', 'Flagship 5G Smartphones, Foldables & High-Performance Tablets', 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=600', TRUE),
(2, 'Laptops & Computers', 'laptops-computers', 'Powerful Ultrabooks, Workstations & Gaming Machines', 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600', TRUE),
(3, 'Audio & Headphones', 'audio-headphones', 'Wireless ANC Over-Ear Headphones, Earbuds & High-Fidelity Speakers', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600', TRUE),
(4, 'Smartwatches & Wearables', 'smartwatches-wearables', 'Advanced Fitness Trackers, GPS Smartwatches & Designer Timepieces', 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600', TRUE),
(5, 'Men''s Fashion & Apparel', 'mens-fashion', 'Denim Jackets, Premium Cotton Shirts, Hoodies & Chinos', 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=600', TRUE),
(6, 'Women''s Fashion & Apparel', 'womens-fashion', 'Tailored Trench Coats, Linen Blends, Knitwear & Modern Apparel', 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=600', TRUE),
(7, 'Footwear & Sneakers', 'footwear-sneakers', 'Athletic Running Shoes, Retro Lifestyle Sneakers & Everyday Comfort', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600', TRUE),
(8, 'Smart Home & Kitchen', 'home-appliances', 'Cordless Vacuum Cleaners, Espresso Machines & Air Purifiers', 'https://images.unsplash.com/photo-1558317374-067fb5f30001?w=600', TRUE),
(9, 'Cameras & Drones', 'cameras-drones', 'Full-Frame Mirrorless Cameras, Lenses & 4K Aerial Drones', 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=600', TRUE);

-- Seed Products (Universal General E-Commerce Platform)
INSERT INTO products (product_id, category_id, name, brand, description, price, discount, stock, image_url, status) VALUES
(1, 1, 'Apple iPhone 15 Pro Max (256GB Titanium Blue)', 'Apple', 'Flagship aerospace-grade titanium design, A17 Pro gaming chip, customizable Action button, and 5x telephoto optical zoom system.', 134900.00, 8.00, 45, 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=600', TRUE),
(2, 1, 'Samsung Galaxy S24 Ultra 5G (Titanium Gray, 512GB)', 'Samsung', 'Next-gen Galaxy AI powerhouse with integrated S-Pen, Snapdragon 8 Gen 3, 200MP camera system, and flat quad-HD display.', 129999.00, 10.00, 35, 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=600', TRUE),
(3, 2, 'Apple MacBook Air 15" M3 (16GB RAM, 512GB SSD Midnight)', 'Apple', 'Ultra-thin liquid retina display powered by Apple M3 silicon, up to 18 hours of battery life, and fanless silent architecture.', 134900.00, 7.00, 25, 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600', TRUE),
(4, 3, 'Sony WH-1000XM5 Wireless Noise-Cancelling Headphones', 'Sony', 'Industry-leading noise canceling with two processors, 8 microphones, 30-hour battery life, and crystal-clear hands-free calling.', 29990.00, 15.00, 60, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600', TRUE),
(5, 2, 'Dell XPS 15 9530 OLED InfinityEdge Laptop', 'Dell', '13th Gen Intel Core i9-13900H, 32GB DDR5 RAM, 1TB SSD, NVIDIA GeForce RTX 4070, and 3.5K OLED touch display.', 189990.00, 10.00, 20, 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=600', TRUE),
(6, 3, 'Apple AirPods Pro 2nd Gen with MagSafe Case (USB-C)', 'Apple', 'Pro-level Active Noise Cancellation, Adaptive Audio, Transparency mode, Personalized Spatial Audio, and precision finding.', 24900.00, 10.00, 75, 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=600', TRUE),
(7, 4, 'Apple Watch Series 9 GPS + Cellular (45mm Starlight)', 'Apple', 'S9 SiP chip with magical Double Tap gesture, brighter always-on retina display, ECG, blood oxygen, and crash detection.', 44900.00, 10.00, 40, 'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=600', TRUE),
(8, 5, 'Levi''s Men''s Classic Trucker Denim Jacket', 'Levi''s', 'Iconic regular fit denim jacket in vintage stonewash, copper shank buttons, chest flap pockets, and durable heavyweight cotton.', 4499.00, 20.00, 80, 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=600', TRUE),
(9, 7, 'Nike Air Max 270 React Athletic Running Sneakers', 'Nike', 'Max Air 270 heel unit delivers unmatched all-day bounce, breathable lightweight knit upper, and dual-density foam sole.', 13995.00, 12.00, 50, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600', TRUE),
(10, 8, 'Dyson V12 Detect Slim Cordless Vacuum Cleaner', 'Dyson', 'Laser illumination reveals invisible microscopic dust, piezo sensor measures particle counts, and up to 60 minutes run time.', 49900.00, 10.00, 30, 'https://images.unsplash.com/photo-1558317374-067fb5f30001?w=600', TRUE),
(11, 3, 'Marshall Stanmore III Bluetooth Home Speaker (Black)', 'Marshall', 'Iconic vintage styling with wider soundstage, re-engineered acoustic system, dynamic loudness, and Bluetooth 5.2 connectivity.', 31999.00, 8.00, 35, 'https://images.unsplash.com/photo-1545454675-3531b543be5d?w=600', TRUE),
(12, 1, 'Google Pixel 8 Pro 5G (Obsidian 128GB)', 'Google', 'Google Tensor G3 chip, AI photography tools, best-in-class telephoto zoom, temperature sensor, and 7 years of OS updates.', 84999.00, 12.00, 40, 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=600', TRUE),
(13, 2, 'ASUS ROG Zephyrus G14 Gaming Laptop', 'ASUS', 'AMD Ryzen 9 8945HS, NVIDIA GeForce RTX 4060, 3K 120Hz OLED ROG Nebula display, in a sleek CNC aluminum chassis.', 142000.00, 14.00, 25, 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=600', TRUE),
(14, 4, 'Samsung Galaxy Watch 6 Classic (47mm Rotating Bezel)', 'Samsung', 'Premium stainless steel casing with physical rotating bezel, sapphire crystal glass, sleep coaching, and BIA body composition.', 36999.00, 15.00, 45, 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=600', TRUE),
(15, 5, 'Tommy Hilfiger Slim Fit Pure Cotton Oxford Shirt', 'Tommy Hilfiger', 'Crafted from breathable organic cotton oxford weave, button-down collar, embroidered flag logo on chest, and curved hem.', 3999.00, 15.00, 65, 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600', TRUE),
(16, 6, 'Mango Classic Double-Breasted Wool Blend Trench Coat', 'Mango', 'Elegant structured lapels, tortoiseshell front buttons, detachable waist belt, and premium satin lining for modern sophistication.', 8990.00, 15.00, 35, 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=600', TRUE),
(17, 7, 'Adidas Ultraboost Light Performance Road Running Shoes', 'Adidas', 'Light Boost cushioning provides explosive energy return, Primeknit+ foot-hugging upper, and Continental rubber outsole.', 15999.00, 18.00, 55, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600', TRUE),
(18, 8, 'Nespresso Vertuo Pop Coffee & Espresso Machine', 'Nespresso', 'Centrifusion extraction technology reads barcode on each capsule for optimal cup quality. Brews 4 distinct cup sizes with rich crema.', 16999.00, 15.00, 40, 'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=600', TRUE),
(19, 9, 'Sony Alpha 7 IV Full-Frame Mirrorless 4K Camera', 'Sony', '33MP full-frame Exmor R sensor, BIONZ XR processing, 4K 60p recording, real-time eye autofocus, and 10-bit 4:2:2 video.', 214990.00, 8.00, 15, 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=600', TRUE),
(20, 5, 'Zara Men''s Relaxed Streetwear Heavyweight Hoodie', 'Zara', '420 GSM brushed fleece cotton, drop-shoulder relaxed silhouette, kangaroo pocket, and minimal clean aesthetic styling.', 3290.00, 10.00, 75, 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=600', TRUE),
(21, 7, 'New Balance 574 Core Heritage Suede Classic Sneakers', 'New Balance', 'Timeless retro runner design with premium suede and mesh upper, ENCAP midsole cushioning, and rugged rubber tread.', 8499.00, 10.00, 60, 'https://images.unsplash.com/photo-1539185441755-769473a23570?w=600', TRUE),
(22, 9, 'DJI Mini 4 Pro 4K HDR Lightweight Aerial Drone Combo', 'DJI', 'Under 249 grams lightweight drone with omnidirectional obstacle sensing, 4K/60fps HDR true vertical shooting, and 34-min flight.', 98500.00, 10.00, 20, 'https://images.unsplash.com/photo-1508614589041-895b88991e3e?w=600', TRUE),
(23, 1, 'OnePlus 12 5G (Emerald Green, 16GB / 512GB)', 'OnePlus', 'Snapdragon 8 Gen 3, 4th Gen Hasselblad Camera System, 5400mAh battery with 100W SuperVOOC fast charging, and 2K 120Hz ProXDR.', 64999.00, 15.00, 45, 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=600', TRUE),
(24, 2, 'Lenovo ThinkPad X1 Carbon Gen 12 Ultrabook', 'Lenovo', 'Intel Core Ultra 7 with Intel AI Boost NPU, 32GB RAM, 1TB PCIe Gen 4 SSD, lightweight carbon fiber chassis, and 2.8K OLED display.', 124500.00, 15.00, 30, 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=600', TRUE),
(25, 3, 'Bose QuietComfort Ultra Spatial Audio Earbuds', 'Bose', 'World-class active noise cancellation with breakthrough Bose Immersive Audio, custom-tuned sound profile, and IPX4 sweat resistance.', 25900.00, 12.00, 50, 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600', TRUE),
(26, 4, 'Fossil Gen 6 Touchscreen Smartwatch (Smoke Stainless Steel)', 'Fossil', 'Wear OS by Google, Snapdragon Wear 4100+ platform, SpO2 sensor, continuous heart rate tracking, and 30-minute fast charging.', 18495.00, 25.00, 40, 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=600', TRUE),
(27, 6, 'H&M Premium Linen Blend Relaxed Shirt & Trousers Set', 'H&M', 'Lightweight breathable linen blend with camp collar, button placket, elasticated drawstring waistband trousers, and natural drape.', 3499.00, 10.00, 65, 'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?w=600', TRUE),
(28, 8, 'Philips Smart Air Purifier Series 3000i HEPA Filter', 'Philips', 'Purifies rooms up to 62 m² in under 6 minutes. NanoProtect HEPA filter removes 99.97% of airborne pollutants, allergens, and viruses.', 21995.00, 20.00, 35, 'https://images.unsplash.com/photo-1585771724684-38269d6639fd?w=600', TRUE);

-- Seed Coupons
INSERT INTO coupons (coupon_id, code, discount_type, discount_value, minimum_order, maximum_discount, expiry_date, status) VALUES
(1, 'WELCOME10', 'PERCENTAGE', 10.00, 1000.00, 5000.00, '2028-12-31 23:59:59', TRUE),
(2, 'FLAT20', 'FIXED', 200.00, 1500.00, 200.00, '2028-12-31 23:59:59', TRUE),
(3, 'MEGA50', 'FIXED', 500.00, 5000.00, 500.00, '2028-12-31 23:59:59', TRUE);

-- Seed Sample Reviews
INSERT INTO reviews (user_id, product_id, rating, review_text) VALUES
(2, 1, 5, 'The iPhone 15 Pro Max arrived in mint sealed condition within 24 hours. Super fast delivery and camera zoom is outstanding!'),
(3, 3, 5, 'MacBook Air M3 is an absolute beast for software development and multitasking. ShopSphere price beat all other stores.'),
(4, 4, 5, 'Sony WH-1000XM5 active noise cancellation is unmatched during flights and coding sessions. 100% genuine product!');

-- Seed Sample Orders
INSERT INTO orders (order_id, user_id, address_id, total_amount, discount, shipping_fee, final_amount, payment_method, payment_status, order_status, created_at) VALUES
(1001, 2, 1, 29990.00, 2999.00, 0.00, 26991.00, 'UPI', 'PAID', 'DELIVERED', '2026-09-10 14:32:00'),
(1002, 2, 1, 134900.00, 5000.00, 0.00, 129900.00, 'CARD', 'PAID', 'CONFIRMED', '2026-10-14 18:20:00');

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1001, 4, 1, 29990.00),
(1002, 1, 1, 134900.00);

INSERT INTO payments (order_id, payment_method, transaction_reference, amount, payment_status) VALUES
(1001, 'UPI', 'TXN_UPI_9871236540', 26991.00, 'SUCCESS'),
(1002, 'CARD', 'TXN_CARD_8829103948', 129900.00, 'SUCCESS');
