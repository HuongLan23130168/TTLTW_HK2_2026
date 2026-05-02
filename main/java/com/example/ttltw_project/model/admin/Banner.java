package com.example.ttltw_project.model.admin;

import java.sql.Timestamp;

public class Banner {


        private int id;
        private String title;
        private String description;
        private String image_url;
        private String link;
        private int display_order;
        private boolean is_active;
        private Timestamp created_at;
        private String sub_image_url;
        private String sub_title;
        private String sub_description;

        public Banner() {
        }

        public Banner(int id, String title, String description, String image_url, String link, int display_order, boolean is_active, Timestamp created_at, String sub_image_url, String sub_title, String sub_description) {
            this.id = id;
            this.title = title;
            this.description = description;
            this.image_url = image_url;
            this.link = link;
            this.display_order = display_order;
            this.is_active = is_active;
            this.created_at = created_at;
            this.sub_image_url = sub_image_url;
            this.sub_title = sub_title;
            this.sub_description = sub_description;
        }

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {

            this.description = description;
        }

        public String getImage_url() {

            return image_url;
        }

        public void setImage_url(String image_url) {

            this.image_url = image_url;
        }

        public String getLink() {

            return link;
        }

        public void setLink(String link) {

            this.link = link;
        }

        public int getDisplay_order() {

            return display_order;
        }

        public void setDisplay_order(int display_order) {

            this.display_order = display_order;
        }

        public boolean isIs_active() {

            return is_active;
        }

        public void setIs_active(boolean is_active) {

            this.is_active = is_active;
        }

        public Timestamp getCreated_at() {

            return created_at;
        }

        public void setCreated_at(Timestamp created_at) {

            this.created_at = created_at;
        }

        public String getSub_image_url() {
            return sub_image_url;
        }

        public void setSub_image_url(String sub_image_url) {

            this.sub_image_url = sub_image_url;
        }

        public String getSub_title() {
            return sub_title;
        }

        public void setSub_title(String sub_title) {
            this.sub_title = sub_title;
        }

        public String getSub_description() {
            return sub_description;
        }

        public void setSub_description(String sub_description) {
            this.sub_description = sub_description;
        }
    }


