package com.example.ttltw_project.model.user;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Product implements Serializable { // Giữ Serializable để dùng được với Session/Cart
    private static final long serialVersionUID = 1L;

    private int id;
    private String product_code;
    private String product_name;
    private int category_id;
    private int product_type_id;
    private String description;
    private Timestamp created_at;

    private String category_name;
    private String type_name;
    private double price;
    private String image_url;
    private int stock;
    private int totalSold;

    private boolean newProduct;
    private boolean bestSeller;

    private List<Product_variant> variants = new ArrayList<>();
    private List<Product_image> images = new ArrayList<>();
    private Discount discount;    // Dùng Object Discount để quản lý chuyên sâu

    public Product() {
    }

    public Product(int id, String product_code, String product_name, int category_id, int product_type_id, String description, Timestamp created_at, String category_name, String type_name, double price, String image_url, int stock, int totalSold, boolean newProduct, boolean bestSeller, List<Product_variant> variants, List<Product_image> images, Discount discount) {
        this.id = id;
        this.product_code = product_code;
        this.product_name = product_name;
        this.category_id = category_id;
        this.product_type_id = product_type_id;
        this.description = description;
        this.created_at = created_at;
        this.category_name = category_name;
        this.type_name = type_name;
        this.price = price;
        this.image_url = image_url;
        this.stock = stock;
        this.totalSold = totalSold;
        this.newProduct = newProduct;
        this.bestSeller = bestSeller;
        this.variants = variants;
        this.images = images;
        this.discount = discount;
    }

    public double getFinalPrice() {
        if (this.discount != null && this.discount.isActive()) {
            return this.price * (1 - (double) this.discount.getDiscount_percent() / 100);
        }
        return this.price;
    }

    // Lấy phần trăm giảm giá để hiển thị lên nhãn (Label)
    public int getDiscountDisplay() {
        if (discount != null && discount.isActive()) {
            return discount.getDiscount_percent();
        }
        return 0;
    }

    public String getDisplayImage() {
        if (variants != null && !variants.isEmpty() && variants.get(0).getImage_url() != null) {
            return variants.get(0).getImage_url();
        }
        return this.image_url;
    }

    public boolean isOnSale() {
        return discount != null && discount.isActive();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getProduct_code() {
        return product_code;
    }

    public void setProduct_code(String product_code) {
        this.product_code = product_code;
    }

    public String getProduct_name() {
        return product_name;
    }

    public void setProduct_name(String product_name) {
        this.product_name = product_name;
    }

    public int getCategory_id() {
        return category_id;
    }

    public void setCategory_id(int category_id) {
        this.category_id = category_id;
    }

    public int getProduct_type_id() {
        return product_type_id;
    }

    public void setProduct_type_id(int product_type_id) {
        this.product_type_id = product_type_id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    public String getCategory_name() {
        return category_name;
    }

    public void setCategory_name(String category_name) {
        this.category_name = category_name;
    }

    public String getType_name() {
        return type_name;
    }

    public void setType_name(String type_name) {
        this.type_name = type_name;
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

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public int getTotalSold() {
        return totalSold;
    }

    public void setTotalSold(int totalSold) {
        this.totalSold = totalSold;
    }

    public boolean isNewProduct() {
        return newProduct;
    }

    public void setNewProduct(boolean newProduct) {
        this.newProduct = newProduct;
    }

    public boolean isBestSeller() {
        return bestSeller;
    }

    public void setBestSeller(boolean bestSeller) {
        this.bestSeller = bestSeller;
    }

    public List<Product_variant> getVariants() {
        return variants;
    }

    public void setVariants(List<Product_variant> variants) {
        this.variants = variants;
    }

    public List<Product_image> getImages() {
        return images;
    }

    public void setImages(List<Product_image> images) {
        this.images = images;
    }

    public Discount getDiscount() {
        return discount;
    }

    public void setDiscount(Discount discount) {
        this.discount = discount;
    }

    public double getPrice_new() {
        return getFinalPrice();
    }

    public int getDiscountPercent() {
        return getDiscountDisplay();
    }
}
