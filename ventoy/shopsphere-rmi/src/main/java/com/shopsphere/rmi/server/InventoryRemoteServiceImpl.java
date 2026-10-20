package com.shopsphere.rmi.server;

import com.shopsphere.common.model.Product;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.rmi.service.InventoryRemoteService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

/**
 * RTU Syllabus Requirement: Remote Implementation of InventoryRemoteService.
 * Extends UnicastRemoteObject to enable point-to-point remote communication over TCP.
 */
public class InventoryRemoteServiceImpl extends UnicastRemoteObject implements InventoryRemoteService {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(InventoryRemoteServiceImpl.class);

    private final ProductDAO productDAO;

    public InventoryRemoteServiceImpl() throws RemoteException {
        super();
        this.productDAO = new ProductDAO();
    }

    @Override
    public Product getProduct(int productId) throws RemoteException {
        logger.info("RMI call: getProduct({})", productId);
        try {
            return productDAO.findById(productId);
        } catch (Exception e) {
            logger.error("RMI error finding product", e);
            throw new RemoteException("Database error in getProduct: " + e.getMessage());
        }
    }

    @Override
    public int getStock(int productId) throws RemoteException {
        logger.info("RMI call: getStock({})", productId);
        try {
            Product p = productDAO.findById(productId);
            return (p != null) ? p.getStock() : -1;
        } catch (Exception e) {
            logger.error("RMI error getting stock", e);
            throw new RemoteException("Database error in getStock: " + e.getMessage());
        }
    }

    @Override
    public boolean updateStock(int productId, int quantityDelta) throws RemoteException {
        logger.info("RMI call: updateStock({}, delta={})", productId, quantityDelta);
        try {
            return productDAO.updateStock(productId, quantityDelta);
        } catch (Exception e) {
            logger.error("RMI error updating stock", e);
            throw new RemoteException("Database error in updateStock: " + e.getMessage());
        }
    }

    @Override
    public boolean setExactStock(int productId, int stock) throws RemoteException {
        logger.info("RMI call: setExactStock({}, stock={})", productId, stock);
        try {
            return productDAO.setStock(productId, stock);
        } catch (Exception e) {
            logger.error("RMI error setting stock", e);
            throw new RemoteException("Database error in setExactStock: " + e.getMessage());
        }
    }
}

