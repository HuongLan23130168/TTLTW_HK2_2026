package com.example.ttltw_project.dao.admin;

import com.example.ttltw_project.dao.user.DBDAO;
import com.example.ttltw_project.model.user.Discount;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.UnableToExecuteStatementException;

import java.util.List;
import java.util.Optional;
import java.util.StringJoiner;

public class AdminDiscountDAO {


    private final Jdbi jdbi = DBDAO.get();

    public List<Discount> getAll() {
        String sql = """
            SELECT
                d.*,
                (SELECT GROUP_CONCAT(c.category_name SEPARATOR ', ') FROM categories c JOIN discount_categories dc ON c.id = dc.category_id WHERE dc.discount_id = d.id) as applied_categories,
                (SELECT GROUP_CONCAT(pt.type_name SEPARATOR ', ') FROM product_types pt JOIN discount_product_types dpt ON pt.id = dpt.product_type_id WHERE dpt.discount_id = d.id) as applied_types
            FROM discounts d
            ORDER BY d.id DESC
        """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .map((rs, ctx) -> {
                    Discount d = new Discount();
                    d.setId(rs.getInt("id"));
                    d.setDiscount_code(rs.getString("discount_code"));
                    d.setDiscount_name(rs.getString("discount_name"));
                    d.setDiscount_percent(rs.getInt("discount_percent"));
                    d.setStart_date(rs.getTimestamp("start_date"));
                    d.setEnd_date(rs.getTimestamp("end_date"));
                    d.setDescription(rs.getString("description"));

                    String categories = rs.getString("applied_categories");
                    String types = rs.getString("applied_types");
                    StringJoiner joiner = new StringJoiner(", ");
                    if (categories != null && !categories.isEmpty()) {
                        joiner.add("Danh mục: " + categories);
                    }
                    if (types != null && !types.isEmpty()) {
                        joiner.add("Loại: " + types);
                    }
                    d.setAppliedScopeNames(joiner.toString());

                    return d;
                }).list());
    }
    public Discount getById(int id) {
        return jdbi.withHandle(handle -> {
            Optional<Discount> discountOpt = handle.createQuery("SELECT * FROM discounts WHERE id = :id").bind("id", id).mapToBean(Discount.class).findFirst();
            if (discountOpt.isPresent()) {
                Discount d = discountOpt.get();
                d.setAppliedCategoryIds(handle.createQuery("SELECT category_id FROM discount_categories WHERE discount_id = :id").bind("id", id).mapTo(Integer.class).list());
                d.setAppliedProductTypeIds(handle.createQuery("SELECT product_type_id FROM discount_product_types WHERE discount_id = :id").bind("id", id).mapTo(Integer.class).list());
                return d;
            }
            return null;
        });
    }

    public void insert(Discount d, String scope, List<Integer> targetIds) throws UnableToExecuteStatementException {
        jdbi.useTransaction(handle -> {
            String sql = "INSERT INTO discounts (discount_code, discount_name, discount_percent, start_date, end_date, description, created_at) VALUES (:code, :name, :percent, :start, :end, :desc, NOW())";
            int discountId = handle.createUpdate(sql)
                    .bind("code", d.getDiscount_code()).bind("name", d.getDiscount_name()).bind("percent", d.getDiscount_percent())
                    .bind("start", d.getStart_date()).bind("end", d.getEnd_date()).bind("desc", d.getDescription())
                    .executeAndReturnGeneratedKeys("id").mapTo(Integer.class).one();

            if (scope != null && targetIds != null && !targetIds.isEmpty()) {
                String insertLinkSql = "";
                switch (scope) {
                    case "category" -> insertLinkSql = "INSERT INTO discount_categories (discount_id, category_id) VALUES (:discount_id, :target_id)";
                    case "type" -> insertLinkSql = "INSERT INTO discount_product_types (discount_id, product_type_id) VALUES (:discount_id, :target_id)";
                }
                if (!insertLinkSql.isEmpty()) {
                    for (Integer targetId : targetIds) {
                        handle.createUpdate(insertLinkSql).bind("discount_id", discountId).bind("target_id", targetId).execute();
                    }
                }
            }
        });
    }

    public void update(Discount d, String scope, List<Integer> targetIds) throws UnableToExecuteStatementException {
        jdbi.useTransaction(handle -> {
            String sql = "UPDATE discounts SET discount_code = :code, discount_name = :name, discount_percent = :percent, start_date = :start, end_date = :end, description = :desc WHERE id = :id";
            int updatedRows = handle.createUpdate(sql)
                    .bind("code", d.getDiscount_code()).bind("name", d.getDiscount_name()).bind("percent", d.getDiscount_percent())
                    .bind("start", d.getStart_date()).bind("end", d.getEnd_date()).bind("desc", d.getDescription()).bind("id", d.getId())
                    .execute();

            if (updatedRows == 0) {
                throw new IllegalStateException("Discount with ID " + d.getId() + " not found.");
            }

            handle.createUpdate("DELETE FROM discount_categories WHERE discount_id = :id").bind("id", d.getId()).execute();
            handle.createUpdate("DELETE FROM discount_product_types WHERE discount_id = :id").bind("id", d.getId()).execute();

            if (scope != null && targetIds != null && !targetIds.isEmpty()) {
                String insertLinkSql = "";
                switch (scope) {
                    case "category" -> insertLinkSql = "INSERT INTO discount_categories (discount_id, category_id) VALUES (:discount_id, :target_id)";
                    case "type" -> insertLinkSql = "INSERT INTO discount_product_types (discount_id, product_type_id) VALUES (:discount_id, :target_id)";
                }
                if (!insertLinkSql.isEmpty()) {
                    for (Integer targetId : targetIds) {
                        handle.createUpdate(insertLinkSql).bind("discount_id", d.getId()).bind("target_id", targetId).execute();
                    }
                }
            }
        });
    }

    public void delete(int id) {
        jdbi.useTransaction(handle -> {
            handle.createUpdate("DELETE FROM discount_categories WHERE discount_id = :id").bind("id", id).execute();
            handle.createUpdate("DELETE FROM discount_product_types WHERE discount_id = :id").bind("id", id).execute();
            handle.createUpdate("DELETE FROM discounts WHERE id = :id").bind("id", id).execute();
        });
    }
}

