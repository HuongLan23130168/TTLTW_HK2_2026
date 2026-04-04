package com.example.ttltw_project.model.user;

public class Address {

    private int id;
    private int user_id;
    private String address;
    private int is_default; // 1: Mặc định, 0: Thường

    public Address() {
    }

    public Address(int id, int user_id, String address, int is_default) {
        this.id = id;
        this.user_id = user_id;
        this.address = address;
        this.is_default = is_default;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUser_id() {
        return user_id;
    }
    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }

    public int getIs_default() {
        return is_default;
    }

    public void setIs_default(int is_default) {
        this.is_default = is_default;
    }

}


