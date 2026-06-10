package com.example.ttltw_project.dao.admin;

import com.example.ttltw_project.dao.user.DBDAO;
import com.example.ttltw_project.model.user.User;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.Query;

import java.util.List;

public class AdminCustomerDAO {
    private final Jdbi jdbi = DBDAO.get();

    public List<User> getAllCustomers(String sortBy, String search) {
        return jdbi.withHandle(handle -> {
            StringBuilder sql = new StringBuilder("""
                    SELECT
                        u.id,
                        u.full_name AS fullName,
                        u.birth,
                        u.gender,
                        u.email,
                        COALESCE(
                            NULLIF(TRIM(u.phone), ''),
                            (
                                SELECT o.recipient_phone
                                FROM orders o
                                WHERE o.user_id = u.id
                                  AND o.recipient_phone IS NOT NULL
                                  AND TRIM(o.recipient_phone) <> ''
                                ORDER BY o.order_date DESC
                                LIMIT 1
                            )
                        ) AS phone,
                        COALESCE(
                            NULLIF(TRIM(u.address), ''),
                            (
                                SELECT a.address
                                FROM addresses a
                                WHERE a.user_id = u.id
                                  AND a.address IS NOT NULL
                                  AND TRIM(a.address) <> ''
                                ORDER BY a.is_default DESC, a.id DESC
                                LIMIT 1
                            ),
                            (
                                SELECT o.shipping_address
                                FROM orders o
                                WHERE o.user_id = u.id
                                  AND o.shipping_address IS NOT NULL
                                  AND TRIM(o.shipping_address) <> ''
                                ORDER BY o.order_date DESC
                                LIMIT 1
                            )
                        ) AS address,
                        u.role,
                        u.created_at
                    FROM users u
                    """);

            if (search != null && !search.trim().isEmpty()) {
                sql.append("""
                         WHERE u.full_name LIKE :search
                            OR u.email LIKE :search
                            OR u.phone LIKE :search
                            OR u.address LIKE :search
                            OR EXISTS (
                                SELECT 1
                                FROM orders so
                                WHERE so.user_id = u.id
                                  AND (so.recipient_phone LIKE :search OR so.shipping_address LIKE :search)
                            )
                            OR EXISTS (
                                SELECT 1
                                FROM addresses sa
                                WHERE sa.user_id = u.id
                                  AND sa.address LIKE :search
                            )
                        """);
            }

            String orderBy;
            switch (sortBy) {
                case "oldest":
                    orderBy = " ORDER BY u.created_at ASC";
                    break;
                case "name_asc":
                    orderBy = " ORDER BY u.full_name ASC";
                    break;
                case "name_desc":
                    orderBy = " ORDER BY u.full_name DESC";
                    break;
                case "newest":
                default:
                    orderBy = " ORDER BY u.created_at DESC";
                    break;
            }
            sql.append(orderBy);

            Query query = handle.createQuery(sql.toString());

            if (search != null && !search.trim().isEmpty()) {
                query.bind("search", "%" + search.trim() + "%");
            }

            return query.mapToBean(User.class).list();
        });
    }

    public User getCustomerById(int id) {
        return jdbi.withHandle(handle ->
                handle.createQuery("""
                        SELECT
                            u.id,
                            u.full_name AS fullName,
                            u.birth,
                            u.gender,
                            u.email,
                            COALESCE(
                                NULLIF(TRIM(u.phone), ''),
                                (
                                    SELECT o.recipient_phone
                                    FROM orders o
                                    WHERE o.user_id = u.id
                                      AND o.recipient_phone IS NOT NULL
                                      AND TRIM(o.recipient_phone) <> ''
                                    ORDER BY o.order_date DESC
                                    LIMIT 1
                                )
                            ) AS phone,
                            COALESCE(
                                NULLIF(TRIM(u.address), ''),
                                (
                                    SELECT a.address
                                    FROM addresses a
                                    WHERE a.user_id = u.id
                                      AND a.address IS NOT NULL
                                      AND TRIM(a.address) <> ''
                                    ORDER BY a.is_default DESC, a.id DESC
                                    LIMIT 1
                                ),
                                (
                                    SELECT o.shipping_address
                                    FROM orders o
                                    WHERE o.user_id = u.id
                                      AND o.shipping_address IS NOT NULL
                                      AND TRIM(o.shipping_address) <> ''
                                    ORDER BY o.order_date DESC
                                    LIMIT 1
                                )
                            ) AS address,
                            u.role,
                            u.created_at
                        FROM users u
                        WHERE u.id = :id
                        """)
                        .bind("id", id)
                        .mapToBean(User.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public void deleteCustomer(int id) {
        jdbi.useHandle(handle ->
                handle.createUpdate("DELETE FROM users WHERE id = :id")
                        .bind("id", id)
                        .execute()
        );
    }
}
