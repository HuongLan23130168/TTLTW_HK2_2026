package com.example.ttltw_project.dao.user;

import com.example.ttltw_project.model.user.Discount;
import com.example.ttltw_project.model.user.Product;

import java.util.Arrays;
import java.util.List;

public class ListProductDao {

    private Product mapRowToProduct(java.sql.ResultSet rs) throws java.sql.SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setProduct_name(rs.getString("product_name"));
        p.setCategory_name(rs.getString("category_name"));
        p.setType_name(rs.getString("type_name"));
        p.setPrice(rs.getDouble("price"));
        p.setImage_url(rs.getString("image_url"));

        int discountId = rs.getInt("d_id");
        if (discountId > 0) {
            Discount d = new Discount();
            d.setId(discountId);
            d.setDiscount_percent(rs.getInt("d_percent"));
            d.setStart_date(rs.getTimestamp("d_start"));
            d.setEnd_date(rs.getTimestamp("d_end"));
            p.setDiscount(d);
        }
        return p;
    }


    private static final String BASE_SELECT = """
    SELECT 
        p.id, p.product_name, c.category_name, t.type_name,
        MIN(v.price) AS price, 
        MAX(v.image_url) AS image_url, 
        MAX(COALESCE(dt.discount_id, dc.discount_id)) AS d_id,
        MAX(COALESCE(d2.discount_percent, d1.discount_percent)) AS d_percent,
        MAX(COALESCE(d2.start_date, d1.start_date)) AS d_start,
        MAX(COALESCE(d2.end_date, d1.end_date)) AS d_end
    FROM products p
    JOIN categories c ON p.category_id = c.id
    LEFT JOIN product_types t ON p.product_type_id = t.id
    LEFT JOIN product_variants v ON v.product_id = p.id
    LEFT JOIN discount_categories dc ON c.id = dc.category_id
    LEFT JOIN discounts d1 ON dc.discount_id = d1.id
    LEFT JOIN discount_product_types dt ON t.id = dt.product_type_id
    LEFT JOIN discounts d2 ON dt.discount_id = d2.id
    """;

    public List<Product> filterProducts(String priceRange, String[] roomCodes, String[] typeCodes, String sort, int page, int size) {
        StringBuilder sql = new StringBuilder(BASE_SELECT);


        sql.append(" WHERE 1=1 ");

        if (roomCodes != null && roomCodes.length > 0)
            sql.append(" AND c.id IN (<rooms>) ");
        if (typeCodes != null && typeCodes.length > 0)
            sql.append(" AND t.type_code IN (<types>) ");


        sql.append(" GROUP BY p.id ");

        if (priceRange != null && !priceRange.isEmpty()) {
            switch (priceRange) {
                case "1" -> sql.append(" HAVING price < 500000 ");
                case "2" -> sql.append(" HAVING price BETWEEN 500000 AND 1000000 ");
                case "3" -> sql.append(" HAVING price BETWEEN 1000000 AND 3000000 ");
                case "4" -> sql.append(" HAVING price > 3000000 ");
            }
        }

        if ("price-asc".equals(sort)) sql.append(" ORDER BY price ASC ");
        else if ("price-desc".equals(sort)) sql.append(" ORDER BY price DESC ");
        else sql.append(" ORDER BY p.id DESC ");

        sql.append(" LIMIT :limit OFFSET :offset ");

        return DBDAO.get().withHandle(h -> {
            var q = h.createQuery(sql.toString())
                    .bind("limit", size)
                    .bind("offset", (page - 1) * size);

            if (roomCodes != null && roomCodes.length > 0)
                q.bindList("rooms", Arrays.stream(roomCodes).map(Integer::parseInt).toList());
            if (typeCodes != null && typeCodes.length > 0)
                q.bindList("types", Arrays.asList(typeCodes));

            return q.map((rs, ctx) -> mapRowToProduct(rs)).list();
        });
    }

    public int countProducts(String priceRange, String[] rooms, String[] categories) {

        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM (");
        sql.append("SELECT p.id, MIN(v.price) as price FROM products p ");
        sql.append("JOIN categories c ON p.category_id = c.id ");
        sql.append("LEFT JOIN product_types t ON p.product_type_id = t.id ");
        sql.append("LEFT JOIN product_variants v ON v.product_id = p.id WHERE 1=1 ");

        if (rooms != null && rooms.length > 0) sql.append(" AND c.id IN (<rooms>) ");
        if (categories != null && categories.length > 0) sql.append(" AND t.type_code IN (<types>) ");

        sql.append(" GROUP BY p.id ");

        if (priceRange != null && !priceRange.isEmpty()) {
            switch (priceRange) {
                case "1" -> sql.append(" HAVING price < 500000 ");
                case "2" -> sql.append(" HAVING price BETWEEN 500000 AND 1000000 ");
                case "3" -> sql.append(" HAVING price BETWEEN 1000000 AND 3000000 ");
                case "4" -> sql.append(" HAVING price > 3000000 ");
            }
        }
        sql.append(") AS temp");

        return DBDAO.get().withHandle(h -> {
            var q = h.createQuery(sql.toString());
            if (rooms != null && rooms.length > 0)
                q.bindList("rooms", Arrays.stream(rooms).map(Integer::parseInt).toList());
            if (categories != null && categories.length > 0)
                q.bindList("types", Arrays.asList(categories));
            return q.mapTo(Integer.class).one();
        });
    }

}
