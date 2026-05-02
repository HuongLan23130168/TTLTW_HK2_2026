package com.example.ttltw_project.dao.admin;

import com.example.ttltw_project.dao.user.DBDAO;
import com.example.ttltw_project.model.admin.Banner;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class AdminBannerDAO {
    private final Jdbi jdbi = DBDAO.get();

    public List<Banner> getAllBanners() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM banners ORDER BY is_active DESC, display_order ASC")
                        .mapToBean(Banner.class)
                        .list()
        );
    }

    public Banner getBannerById(int id) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM banners WHERE id = :id")
                        .bind("id", id)
                        .mapToBean(Banner.class)
                        .findOne()
                        .orElse(null)
        );
    }


    public void addBanner(Banner banner) {
        jdbi.useTransaction(handle -> {
            handle.createUpdate("UPDATE banners SET display_order = display_order + 1 WHERE display_order >= :order")
                    .bind("order", banner.getDisplay_order())
                    .execute();

            handle.createUpdate("INSERT INTO banners (title, description, image_url, link, display_order, is_active, sub_image_url, sub_title, sub_description) " +
                            "VALUES (:title, :description, :image_url, :link, :display_order, :is_active, :sub_image_url, :sub_title, :sub_description)")
                    .bindBean(banner)
                    .execute();
        });
    }

    public void updateBanner(Banner banner) {
        jdbi.useTransaction(handle -> {
            Integer oldOrder = handle.createQuery("SELECT display_order FROM banners WHERE id = :id")
                    .bind("id", banner.getId())
                    .mapTo(Integer.class)
                    .findOne()
                    .orElse(null);

            if (oldOrder != null && !oldOrder.equals(banner.getDisplay_order())) {
                int newOrder = banner.getDisplay_order();
                if (newOrder < oldOrder) {
                    handle.createUpdate("UPDATE banners SET display_order = display_order + 1 WHERE display_order >= :new AND display_order < :old")
                            .bind("new", newOrder).bind("old", oldOrder).execute();
                } else {
                    handle.createUpdate("UPDATE banners SET display_order = display_order - 1 WHERE display_order > :old AND display_order <= :new")
                            .bind("old", oldOrder).bind("new", newOrder).execute();
                }
            }

            handle.createUpdate("UPDATE banners SET title = :title, description = :description, image_url = :image_url, " +
                            "link = :link, display_order = :display_order, is_active = :is_active, " +
                            "sub_image_url = :sub_image_url, sub_title = :sub_title, sub_description = :sub_description WHERE id = :id")
                    .bindBean(banner)
                    .execute();
        });
    }

    public void deleteBanner(int id) {
        jdbi.useTransaction(handle -> {
            Integer orderToHide = handle.createQuery("SELECT display_order FROM banners WHERE id = :id")
                    .bind("id", id)
                    .mapTo(Integer.class)
                    .findOne().orElse(null);

            handle.createUpdate("UPDATE banners SET is_active = false, display_order = 0 WHERE id = :id")
                    .bind("id", id)
                    .execute();

            if (orderToHide != null) {
                handle.createUpdate("UPDATE banners SET display_order = display_order - 1 " +
                                "WHERE display_order > :order AND is_active = true")
                        .bind("order", orderToHide)
                        .execute();
            }
        });
    }


    public void restoreBanner(int id) {
        jdbi.useTransaction(handle -> {
            Integer maxOrder = handle.createQuery("SELECT MAX(display_order) FROM banners WHERE is_active = true")
                    .mapTo(Integer.class)
                    .findOne().orElse(0);

            handle.createUpdate("UPDATE banners SET is_active = true, display_order = :newOrder WHERE id = :id")
                    .bind("id", id)
                    .bind("newOrder", maxOrder + 1)
                    .execute();
        });
    }
    public List<Banner> getActiveBanners() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM banners WHERE is_active = true ORDER BY display_order ASC")
                        .mapToBean(Banner.class)
                        .list()
        );
    }
}
