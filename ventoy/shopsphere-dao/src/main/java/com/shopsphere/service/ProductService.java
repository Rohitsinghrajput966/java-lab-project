package com.shopsphere.service;

import com.shopsphere.common.model.Category;
import com.shopsphere.common.model.Product;
import com.shopsphere.dao.CategoryDAO;
import com.shopsphere.dao.ProductDAO;

import java.util.List;

public class ProductService {
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    public List<Product> getAllActiveProducts() {
        return productDAO.findAll(true);
    }

    public List<Product> getAllProducts() {
        return productDAO.findAll(false);
    }

    public Product getProductById(int productId) {
        return productDAO.findById(productId);
    }

    public List<Product> getProductsByCategory(int categoryId) {
        return productDAO.findByCategory(categoryId);
    }

    public List<Product> searchProducts(String query, Integer categoryId, Double minPrice, Double maxPrice, String sortBy) {
        return productDAO.searchAndFilter(query, categoryId, minPrice, maxPrice, sortBy);
    }

    public List<Category> getActiveCategories() {
        return categoryDAO.findAll();
    }

    public List<Category> getAllCategories() {
        return categoryDAO.findAllIncludingInactive();
    }

    public boolean createCategory(Category c) {
        return categoryDAO.create(c);
    }

    public boolean updateCategory(Category c) {
        return categoryDAO.update(c);
    }

    public boolean toggleCategoryStatus(int categoryId) {
        return categoryDAO.toggleStatus(categoryId);
    }

    public boolean deleteCategory(int categoryId) {
        return categoryDAO.delete(categoryId);
    }

    public boolean createProduct(Product p) {
        return productDAO.create(p);
    }

    public boolean updateProduct(Product p) {
        return productDAO.update(p);
    }

    public boolean deleteProduct(int productId) {
        return productDAO.delete(productId);
    }

    public List<Product> getLowStockAlerts(int threshold) {
        return productDAO.getLowStockProducts(threshold);
    }

    public int getTotalProductCount() {
        return productDAO.countProducts();
    }

    public boolean toggleProductStatus(int productId) {
        return productDAO.toggleStatus(productId);
    }

    public boolean quickUpdateStock(int productId, int stock) {
        return productDAO.setStock(productId, stock);
    }

    public List<Product> searchProductsForAdmin(String query, Integer categoryId, String stockFilter) {
        return productDAO.searchForAdmin(query, categoryId, stockFilter);
    }
}


