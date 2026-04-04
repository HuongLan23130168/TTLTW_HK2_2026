package com.example.ttltw_project.model.user;

import java.io.Serializable;


public class ProductType implements Serializable {
    private int id;
    private String type_name;

    public ProductType() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getType_name() {
        return type_name;
    }

    public void setType_name(String type_name) {
        this.type_name = type_name;
    }

}
