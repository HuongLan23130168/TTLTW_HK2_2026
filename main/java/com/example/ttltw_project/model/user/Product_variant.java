package com.example.ttltw_project.model.user;


public class Product_variant {
    private int id;
    private String variant_code;
    private int product_id;
    private String style;
    private String color;
    private String size;
    private String origin;
    private String material;
    private double price;
    private String image_url;
    private double price_old;
    private int stock;

    public Product_variant() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getVariant_code() {
        return variant_code;
    }

    public void setVariant_code(String variant_code) {
        this.variant_code = variant_code;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public String getStyle() {
        return style;
    }

    public void setStyle(String style) {
        this.style = style;
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

    public String getMaterial() {
        return material;
    }

    public void setMaterial(String material) {
        this.material = material;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getImage_url() {
        return image_url;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }
    public double getPrice_old() {
        return price_old;
    }

    public void setPrice_old(double price_old) {
        this.price_old = price_old;
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    // Phần trăm giảm giá
    public int getDiscountPercent() {
        if (price_old > price && price_old > 0) {
            return (int) Math.round(((price_old - price) / price_old) * 100);
        }
        return 0;
    }

    public int getStock() {
        return stock;

    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getJsonSafeColor() {
        return escapeJson(this.color);
    }

    public String getJsonSafeSize() {
        return escapeJson(this.size);
    }

    public String getJsonSafeMaterial() {
        return escapeJson(this.material);
    }

    public String getJsonSafeStyle() {
        return escapeJson(this.style);
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\"", "\\\"")
                .replace("\n", " ")
                .replace("\r", " ")
                .trim();
    }
}
