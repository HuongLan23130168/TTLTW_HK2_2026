package com.example.ttltw_project.model.user;

public class CartItem {
    private int detailId;
    private int variantId;
    private int productId;
    private String productName;
    private String code;
    private String color;
    private String size;
    private String imageUrl;
    private double price;
    private int quantity;
    private int stock;
    private double discountPercent;

    public CartItem() {
    }

    public CartItem(int detailId, int variantId, int productId, String productName, String code, String color, String size, String imageUrl, double price, int quantity, int stock, double discountPercent) {
        this.detailId = detailId;
        this.variantId = variantId;
        this.productId = productId;
        this.productName = productName;
        this.code = code;
        this.color = color;
        this.size = size;
        this.imageUrl = imageUrl;
        this.price = price;
        this.quantity = quantity;
        this.stock = stock;
        this.discountPercent = discountPercent;
    }

    public int getDetailId() {
        return detailId;
    }

    public void setDetailId(int detailId) {
        this.detailId = detailId;
    }

    public int getVariantId() {
        return variantId;
    }

    public void setVariantId(int variantId) {
        this.variantId = variantId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
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

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public double getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
    }

    public int getProductId() { return productId; }

    public void setProductId(int productId) { this.productId = productId; }

    public double getFinalPrice() {
        if (discountPercent > 0 && discountPercent <= 100) {
            return Math.round(price * (1 - discountPercent / 100.0));
        }
        return price;
    }

    public double getTotalPrice() {
        return getFinalPrice() * quantity;
    }
}


