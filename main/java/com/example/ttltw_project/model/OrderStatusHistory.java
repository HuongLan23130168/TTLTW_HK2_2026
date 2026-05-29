package com.example.ttltw_project.model.admin;

import java.sql.Timestamp;

public class OrderStatusHistory {
    private int id;
    private int orderId;
    private String status;
    private Timestamp createdAt;

    public OrderStatusHistory() {
    }

    public OrderStatusHistory(int id, int orderId, String status, Timestamp createdAt) {
        this.id = id;
        this.orderId = orderId;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

   public String getReturnStatus() {
        return returnStatus;
    }

    public void setReturnStatus(String returnStatus) {
        this.returnStatus = returnStatus;
    }

    public boolean isReturnEligible() {
        return returnEligible;
    }

    public void setReturnEligible(boolean returnEligible) {
        this.returnEligible = returnEligible;
    }

    
}
