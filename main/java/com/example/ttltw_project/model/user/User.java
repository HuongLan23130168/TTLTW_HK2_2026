package com.example.ttltw_project.model.user;


import java.sql.Timestamp;

public class User {
    private int id;
    private String fullName;
    private String birth;
    private String gender;
    private String email;
    private String password;
    private String phone;
    private String role;
    private String address;
    private Timestamp created_at;
    private int status;

    private String googleId;
    private String provider;

    public User() {
        this.provider = "local";
    }

    public User(int id, String fullName, String birth, String gender, String email, String password, String phone, String role, String address, Timestamp created_at, int status, String googleId, String provider) {
        this.id = id;
        this.fullName = fullName;
        this.birth = birth;
        this.gender = gender;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.role = role;
        this.address = address;
        this.created_at = created_at;
        this.status = status;
        this.googleId = googleId;
        this.provider = provider;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getBirth() {
        return birth;
    }

    public void setBirth(String birth) {
        this.birth = birth;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getGoogleId() { 
        return googleId; 
    }

    public void setGoogleId(String googleId) { 
        this.googleId = googleId; 
    }

    public String getProvider() { 
        return provider; 
    }

    public void setProvider(String provider) { 
        this.provider = provider; 
    }

    public boolean isGoogleAccount() {
        return "google".equals(provider) || "both".equals(provider);
    }

    public boolean isLocalAccount() {
        return "local".equals(provider) || "both".equals(provider);
    }
}

