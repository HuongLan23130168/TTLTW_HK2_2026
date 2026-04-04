package com.example.ttltw_project.model.user;

public class Category {
    private int id;
    private String code;
    private String category_name;

    public Category() {}

    public Category(int id, String code, String category_name) {
        this.id = id;
        this.code = code;
        this.category_name = category_name;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getCategory_name() {
        return category_name;
    }

    public void setCategory_name(String category_name) {
        this.category_name = category_name;
    }

}

