package com.shopsphere.rmi.service;

import com.shopsphere.common.model.Product;

import java.rmi.Remote;
import java.rmi.RemoteException;

/**
 * RTU Syllabus Requirement: Remote Interface for Distributed Inventory Service.
 * Extends java.rmi.Remote; all remote methods throw java.rmi.RemoteException.
 */
public interface InventoryRemoteService extends Remote {

    Product getProduct(int productId) throws RemoteException;

    int getStock(int productId) throws RemoteException;

    boolean updateStock(int productId, int quantityDelta) throws RemoteException;

    boolean setExactStock(int productId, int stock) throws RemoteException;
}

