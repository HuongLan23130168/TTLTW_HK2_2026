package com.example.ttltw_project.model.user;

import java.sql.Timestamp;

public class Cart {
        private int id;
        private int user_id;
        private Timestamp created_at;

        public Cart() {
        }

        public Cart(int id, int user_id, Timestamp created_at) {
            this.id = id;
            this.user_id = user_id;
            this.created_at = created_at;
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

        public Timestamp getCreated_at() {
            return created_at;
        }

        public void setCreated_at(Timestamp created_at) {
            this.created_at = created_at;
        }
    }


