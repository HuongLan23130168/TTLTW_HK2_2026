package com.example.ttltw_project.model.user;


import java.sql.Timestamp;

public class UserOrder {
    private int id;
    private String orderCode;
    private Timestamp orderDate;
    private double totalPrice;

    private String status;

    private String productName;
    private String imageUrl;
    private String color;
    private String size;
    private int quantity;
    private int otherItemsCount;
    private String returnStatus;
    private boolean returnEligible;
    private String cancelReason;
    private String returnAdminNote;

    public UserOrder() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getStatus() {
        return status != null ? status : "Chờ xử lý";
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getOtherItemsCount() {
        return otherItemsCount;
    }

    public void setOtherItemsCount(int otherItemsCount) {
        this.otherItemsCount = otherItemsCount;
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

    public String getCancelReason() {
        return cancelReason;
    }

    public void setCancelReason(String cancelReason) {
        this.cancelReason = cancelReason;
    }

    public String getReturnAdminNote() {
        return returnAdminNote;
    }

    public void setReturnAdminNote(String returnAdminNote) {
        this.returnAdminNote = returnAdminNote;
    }
}

