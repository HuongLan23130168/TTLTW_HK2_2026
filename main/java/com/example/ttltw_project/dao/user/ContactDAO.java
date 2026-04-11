package com.example.ttltw_project.dao.user;

import com.example.ttltw_project.model.user.Contact;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.Query;

import java.util.List;

public class ContactDAO {
    private final Jdbi jdbi = DBDAO.get();

    // Thêm liên hệ mới
    public void insert(Contact contact) {
        jdbi.useHandle(handle -> {
            String safeStatus = (contact.getStatus() != null && !contact.getStatus().trim().isEmpty())
                    ? contact.getStatus()
                    : "NEW";

            handle.createUpdate(
                            "INSERT INTO contacts(full_name, email, message, status) " +
                                    "VALUES (:fullName, :email, :message, :status)"
                    )
                    .bind("fullName", contact.getFullName())
                    .bind("email", contact.getEmail())
                    .bind("message", contact.getMessage())
                    .bind("status", safeStatus)
                    .execute();
        });
    }

    public List<Contact> getAllContacts(String search, String statusFilter) {
        return jdbi.withHandle(handle -> {
            StringBuilder sql = new StringBuilder("SELECT * FROM contacts WHERE 1=1");

            if (search != null && !search.trim().isEmpty()) {
                sql.append(" AND (full_name LIKE :search OR email LIKE :search)");
            }

            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                sql.append(" AND status = :status");
            }

            sql.append(" ORDER BY id DESC");

            Query query = handle.createQuery(sql.toString());

            if (search != null && !search.trim().isEmpty()) {
                query.bind("search", "%" + search.trim() + "%");
            }

            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                query.bind("status", statusFilter.trim());
            }

            return query.mapToBean(Contact.class).list();
        });
    }

    public Contact findById(int id) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM contacts WHERE id = :id")
                        .bind("id", id)
                        .mapToBean(Contact.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    // Cập nhật trạng thái liên hệ
    public void updateStatus(int id, String status) {
        jdbi.useHandle(handle ->
                handle.createUpdate("UPDATE contacts SET status = :status WHERE id = :id")
                        .bind("status", status)
                        .bind("id", id)
                        .execute()
        );
    }
}