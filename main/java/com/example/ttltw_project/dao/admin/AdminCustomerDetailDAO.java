package com.example.ttltw_project.dao.admin;

import com.example.ttltw_project.dao.user.DBDAO;
import com.example.ttltw_project.model.user.User;
import org.jdbi.v3.core.Jdbi;
import java.util.List;

public class AdminCustomerDetailDAO {
    private final Jdbi jdbi = DBDAO.get();

    public List<User> getCustomerDetailsById(int customerId) {
        String sql = """
            SELECT
                u.id,
                u.full_name,
                u.email,
                u.phone,
                u.created_at,
                u.gender,
                u.birth,
                u.role,
                u.address,
                o.id AS order_id,
                o.order_date,
                o.total_amount AS total_price,
                o.status
            FROM
                users u
            LEFT JOIN
                orders o ON u.id = o.user_id
            WHERE
                u.id = :customerId AND u.role = 'user'
            ORDER BY o.order_date DESC
        """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("customerId", customerId)
                        .mapToBean(User.class)
                        .list()
        );
    }
}
