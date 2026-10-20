package com.shopsphere.swing.view;

import com.shopsphere.common.model.Category;
import com.shopsphere.common.model.Order;
import com.shopsphere.common.model.Product;
import com.shopsphere.common.model.User;
import com.shopsphere.dao.CategoryDAO;
import com.shopsphere.dao.OrderDAO;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.swing.model.ProductTableModel;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

/**
 * Swing View & Controller: Admin Dashboard Management Window.
 */
public class AdminDashboardFrame extends JFrame {
    private final User adminUser;
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    private final ProductTableModel productTableModel = new ProductTableModel();
    private final JTable productTable = new JTable(productTableModel);

    private final DefaultTableModel orderTableModel = new DefaultTableModel(
            new String[]{"Order ID", "Customer", "Amount (₹)", "Payment", "Status", "Date"}, 0);
    private final JTable orderTable = new JTable(orderTableModel);

    private final JLabel kpiRevenue = new JLabel("₹0.00");
    private final JLabel kpiOrders = new JLabel("0");
    private final JLabel kpiProducts = new JLabel("0");

    public AdminDashboardFrame(User adminUser) {
        this.adminUser = adminUser;
        initUI();
        refreshAllData();
    }

    private void initUI() {
        setTitle("shopsphere Desktop Administration - [" + adminUser.getName() + "]");
        setSize(1000, 700);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        // Menu Bar
        JMenuBar menuBar = new JMenuBar();
        JMenu fileMenu = new JMenu("File");
        JMenuItem refreshItem = new JMenuItem("Refresh Data");
        refreshItem.addActionListener(e -> refreshAllData());
        JMenuItem exitItem = new JMenuItem("Exit");
        exitItem.addActionListener(e -> System.exit(0));
        fileMenu.add(refreshItem);
        fileMenu.addSeparator();
        fileMenu.add(exitItem);

        JMenu catalogMenu = new JMenu("Catalog");
        JMenuItem addItem = new JMenuItem("Add New Product");
        addItem.addActionListener(e -> onAddProduct());
        catalogMenu.add(addItem);

        menuBar.add(fileMenu);
        menuBar.add(catalogMenu);
        setJMenuBar(menuBar);

        // Main Tabbed Pane
        JTabbedPane tabbedPane = new JTabbedPane();
        tabbedPane.addTab("Products Inventory", createProductsPanel());
        tabbedPane.addTab("Customer Orders", createOrdersPanel());
        tabbedPane.addTab("System KPI Metrics", createMetricsPanel());

        add(tabbedPane, BorderLayout.CENTER);
    }

    private JPanel createProductsPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        // Toolbar
        JToolBar toolBar = new JToolBar();
        toolBar.setFloatable(false);

        JButton addBtn = new JButton("Add Product");
        addBtn.addActionListener(e -> onAddProduct());

        JButton editBtn = new JButton("Edit Selected");
        editBtn.addActionListener(e -> onEditProduct());

        JButton deleteBtn = new JButton("Delete Selected");
        deleteBtn.addActionListener(e -> onDeleteProduct());

        JButton refreshBtn = new JButton("Refresh");
        refreshBtn.addActionListener(e -> refreshProducts());

        toolBar.add(addBtn);
        toolBar.add(editBtn);
        toolBar.add(deleteBtn);
        toolBar.addSeparator();
        toolBar.add(refreshBtn);

        panel.add(toolBar, BorderLayout.NORTH);
        panel.add(new JScrollPane(productTable), BorderLayout.CENTER);
        return panel;
    }

    private JPanel createOrdersPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        JToolBar toolBar = new JToolBar();
        toolBar.setFloatable(false);
        JButton refreshBtn = new JButton("Refresh Orders");
        refreshBtn.addActionListener(e -> refreshOrders());
        toolBar.add(refreshBtn);

        panel.add(toolBar, BorderLayout.NORTH);
        panel.add(new JScrollPane(orderTable), BorderLayout.CENTER);
        return panel;
    }

    private JPanel createMetricsPanel() {
        JPanel panel = new JPanel(new GridLayout(1, 3, 20, 20));
        panel.setBorder(BorderFactory.createEmptyBorder(30, 30, 30, 30));

        panel.add(createCard("Total Revenue", kpiRevenue, new Color(79, 70, 229)));
        panel.add(createCard("Completed Orders", kpiOrders, new Color(16, 185, 129)));
        panel.add(createCard("Catalog Products", kpiProducts, new Color(14, 165, 233)));
        return panel;
    }

    private JPanel createCard(String title, JLabel valueLabel, Color accentColor) {
        JPanel card = new JPanel(new BorderLayout(10, 10));
        card.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(accentColor, 2, true),
                BorderFactory.createEmptyBorder(20, 20, 20, 20)
        ));
        card.setBackground(Color.WHITE);

        JLabel titleLabel = new JLabel(title);
        titleLabel.setFont(new Font("SansSerif", Font.BOLD, 14));
        titleLabel.setForeground(Color.GRAY);

        valueLabel.setFont(new Font("SansSerif", Font.BOLD, 26));
        valueLabel.setForeground(accentColor);

        card.add(titleLabel, BorderLayout.NORTH);
        card.add(valueLabel, BorderLayout.CENTER);
        return card;
    }

    private void onAddProduct() {
        List<Category> categories = categoryDAO.findAll();
        ProductDialog dialog = new ProductDialog(this, "Add Product", null, categories);
        dialog.setVisible(true);

        if (dialog.isSaved()) {
            productDAO.create(dialog.getProduct());
            refreshProducts();
            refreshMetrics();
        }
    }

    private void onEditProduct() {
        int selectedRow = productTable.getSelectedRow();
        if (selectedRow < 0) {
            JOptionPane.showMessageDialog(this, "Please select a product to edit.", "Selection Required", JOptionPane.WARNING_MESSAGE);
            return;
        }

        Product selected = productTableModel.getProductAt(selectedRow);
        if (selected != null) {
            List<Category> categories = categoryDAO.findAll();
            ProductDialog dialog = new ProductDialog(this, "Edit Product", selected, categories);
            dialog.setVisible(true);

            if (dialog.isSaved()) {
                productDAO.update(dialog.getProduct());
                refreshProducts();
            }
        }
    }

    private void onDeleteProduct() {
        int selectedRow = productTable.getSelectedRow();
        if (selectedRow < 0) {
            JOptionPane.showMessageDialog(this, "Please select a product to delete.", "Selection Required", JOptionPane.WARNING_MESSAGE);
            return;
        }

        Product selected = productTableModel.getProductAt(selectedRow);
        if (selected != null) {
            int confirm = JOptionPane.showConfirmDialog(this,
                    "Are you sure you want to permanently delete '" + selected.getName() + "'?",
                    "Confirm Deletion", JOptionPane.YES_NO_OPTION);

            if (confirm == JOptionPane.YES_OPTION) {
                productDAO.delete(selected.getProductId());
                refreshProducts();
                refreshMetrics();
            }
        }
    }

    private void refreshAllData() {
        refreshProducts();
        refreshOrders();
        refreshMetrics();
    }

    private void refreshProducts() {
        List<Product> list = productDAO.findAll(false);
        productTableModel.setProducts(list);
    }

    private void refreshOrders() {
        orderTableModel.setRowCount(0);
        List<Order> orders = orderDAO.findAll();
        for (Order o : orders) {
            orderTableModel.addRow(new Object[]{
                    "#SPH-" + o.getOrderId(),
                    o.getUserName(),
                    String.format("%.2f", o.getFinalAmount()),
                    o.getPaymentStatus(),
                    o.getOrderStatus(),
                    o.getCreatedAt() != null ? o.getCreatedAt().toString() : ""
            });
        }
    }

    private void refreshMetrics() {
        kpiRevenue.setText(String.format("₹%.2f", orderDAO.getTotalRevenue()));
        kpiOrders.setText(String.valueOf(orderDAO.countOrders()));
        kpiProducts.setText(String.valueOf(productDAO.countProducts()));
    }
}

