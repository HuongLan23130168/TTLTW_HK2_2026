package com.example.ttltw_project.dao.admin;

import com.example.ttltw_project.dao.user.DBDAO;
import com.example.ttltw_project.model.admin.Notification;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class NotificationDAO {
    private static final Jdbi jdbi = DBDAO.get();


    // Trong class NotificationDAO
    public List<Notification> getNotifications(String filter) {
        StringBuilder sql = new StringBuilder("SELECT * FROM notifications WHERE 1=1");

        if (filter != null) {
            switch (filter) {
                case "unread":
                    sql.append(" AND status = 'unread'");
                    break;
                case "read":
                    sql.append(" AND status = 'read'");
                    break;
                case "order":
                    sql.append(" AND type = 'order'");
                    break;
                case "product":
                    sql.append(" AND (type = 'product' OR type = 'inventory')");
                    break;
                case "account":
                    sql.append(" AND type = 'account'");
                    break;
                case "all":
                default:
                    break;
            }
        }

        sql.append(" ORDER BY created_at DESC");

        return jdbi.withHandle(handle ->
                handle.createQuery(sql.toString())
                        .mapToBean(Notification.class)
                        .list()
        );
    }

    public List<Notification> getLatestNotifications(int limit) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM notifications ORDER BY created_at DESC LIMIT :limit")
                        .bind("limit", limit)
                        .mapToBean(Notification.class)
                        .list()
        );
    }


    public void addNotification(Notification notification) {
        jdbi.useHandle(handle -> {
            handle.createUpdate("INSERT INTO notifications (user_id, title, content, type, status, entity_id, created_at) " +
                            "VALUES (:userId, :title, :content, :type, 'unread', :entityId, NOW())")
                    .bindBean(notification)
                    .execute();
        });
    }

    public static int getUnreadNotificationCount() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM notifications WHERE status = 'unread'")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public boolean markAsRead(int notificationId) {
        return jdbi.withHandle(handle ->
                handle.createUpdate("UPDATE notifications SET status = 'read' WHERE id = :id")
                        .bind("id", notificationId)
                        .execute() > 0
        );
    }

    public boolean markAllAsRead() {
        return jdbi.withHandle(handle ->
                handle.createUpdate("UPDATE notifications SET status = 'read' WHERE status = 'unread'")
                        .execute() > 0
        );
    }

    public boolean deleteNotification(int id) {
        return jdbi.withHandle(handle ->
                handle.createUpdate("DELETE FROM notifications WHERE id = :id")
                        .bind("id", id)
                        .execute() > 0
        );
    }

    public boolean deleteAllNotifications() {
        return jdbi.withHandle(handle ->
                handle.createUpdate("DELETE FROM notifications")
                        .execute() > 0
        );
    }
}
