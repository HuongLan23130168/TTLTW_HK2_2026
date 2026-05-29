package com.example.ttltw_project.model.admin;

public class OrderItem {
    private int variantId;
    private String variantCode;
    private String name;
    private int quantity;
    private double price;
    private String color;
    private String size;
    private String imageUrl;
    private double discount;
    private double total;



    public OrderItem() {
    }

    public OrderItem(int variantId, String variantCode, String name, int quantity, double price, String color, String size, String imageUrl, double discount, double total) {
        this.variantId = variantId;
        this.variantCode = variantCode;
        this.name = name;
        this.quantity = quantity;
        this.price = price;
        this.color = color;
        this.size = size;
        this.imageUrl = imageUrl;
        this.discount = discount;
        this.total = total;
    }

    public int getVariantId() {
        return variantId;
    }

    public void setVariantId(int variantId) {
        this.variantId = variantId;
    }

    public String getVariantCode() {
        return variantCode;
    }

    public void setVariantCode(String variantCode) {
        this.variantCode = variantCode;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
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

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }

    public double getTotal() {
        if (this.discount > 0) {
            return (this.price * this.quantity) * (1 - this.discount / 100);
        }
        return this.price * this.quantity;
    }

    public void setTotal(double total) {
        this.total = total;
    }
    public double getUnitPrice() {
        return this.price;
    }

    public void setUnitPrice(double unitPrice) {
        this.price = unitPrice;
    }

}

