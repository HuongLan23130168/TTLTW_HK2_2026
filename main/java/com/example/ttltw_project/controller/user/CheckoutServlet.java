package com.example.ttltw_project.controller.user;

import com.example.ttltw_project.dao.user.CartDAO;
import com.example.ttltw_project.model.user.CartItem;
import com.example.ttltw_project.model.user.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet(name = "CheckoutServlet", value = "/checkout")
public class CheckoutServlet extends HttpServlet {

    private static final int DEFAULT_WEIGHT = 1000;
    private static final int DEFAULT_LENGTH = 30;
    private static final int DEFAULT_WIDTH  = 20;
    private static final int DEFAULT_HEIGHT = 10;

    private static final int MAX_WEIGHT   = 30_000;
    private static final int MAX_DIM      = 150;
    private static final int MAX_SUM_DIMS = 200;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        CartDAO cartDAO = new CartDAO();
        Integer variantId = (Integer) session.getAttribute("buyNow_variantId");
        Integer quantity  = (Integer) session.getAttribute("buyNow_quantity");

        List<CartItem> items = new ArrayList<>();
        if (variantId != null && quantity != null) {
            CartItem item = cartDAO.getCartItemByVariant(variantId, quantity);
            if (item != null) items = List.of(item);
        } else {
            items = cartDAO.getCartByUserId(user.getId());
        }

        if (items == null || items.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        double grandTotal = items.stream().mapToDouble(CartItem::getTotalPrice).sum();

        int totalWeight = 0, maxLength = 0, maxWidth = 0, totalHeight = 0;
        for (CartItem item : items) {
            int[] dims = estimateDimensions(item.getSize());
            totalWeight += dims[0] * item.getQuantity();
            maxLength    = Math.max(maxLength, dims[1]);
            maxWidth     = Math.max(maxWidth,  dims[2]);
            totalHeight += dims[3] * item.getQuantity();
        }

        if (totalWeight <= 0) totalWeight = DEFAULT_WEIGHT;
        if (maxLength   <= 0) maxLength   = DEFAULT_LENGTH;
        if (maxWidth    <= 0) maxWidth    = DEFAULT_WIDTH;
        if (totalHeight <= 0) totalHeight = DEFAULT_HEIGHT;

        totalWeight = Math.min(totalWeight, MAX_WEIGHT);
        maxLength   = Math.min(maxLength,   MAX_DIM);
        maxWidth    = Math.min(maxWidth,    MAX_DIM);
        totalHeight = Math.min(totalHeight, MAX_DIM);

        int sumDims = maxLength + maxWidth + totalHeight;
        if (sumDims > MAX_SUM_DIMS) {
            double scale = (double) MAX_SUM_DIMS / sumDims;
            maxLength   = Math.max(1, (int)(maxLength   * scale));
            maxWidth    = Math.max(1, (int)(maxWidth    * scale));
            totalHeight = Math.max(1, (int)(totalHeight * scale));
        }

        System.out.printf("GHN dims → weight:%dg  L:%d W:%d H:%d  sum:%d%n",
                totalWeight, maxLength, maxWidth, totalHeight,
                maxLength + maxWidth + totalHeight);

        request.setAttribute("cartItems",   items);
        request.setAttribute("grandTotal",  grandTotal);
        request.setAttribute("totalWeight", totalWeight);
        request.setAttribute("shipLength",  maxLength);
        request.setAttribute("shipWidth",   maxWidth);
        request.setAttribute("shipHeight",  totalHeight);

        request.getRequestDispatcher("/user/pay.jsp").forward(request, response);
    }

    int[] estimateDimensions(String size) {
        if (size == null || size.isBlank()) return def();

        String s = size.trim().replaceAll("^\"|\"$", "");

        int[] r;
        if ((r = tryBoxCm(s))         != null) return r;
        if ((r = tryBoxMeter(s))       != null) return r;
        if ((r = tryLabeledDims(s))    != null) return r;
        if ((r = tryVietnameseDims(s)) != null) return r;
        if ((r = trySingleDim(s))      != null) return r;

        System.out.println("[estimateDimensions] Không parse được: '" + size + "'");
        return def();
    }


    private int[] tryBoxCm(String s) {
        String norm = s.toLowerCase().replaceAll("\\s+", "").replace("*", "x");

        if (!norm.matches("[0-9.x]+(cm|m)?")) return null;

        boolean isMeter = norm.endsWith("m") && !norm.endsWith("cm");
        norm = norm.replaceAll("(cm|m)$", "");

        String[] parts = norm.split("x");
        try {
            if (parts.length >= 3) {
                int l = toAbsCm(Double.parseDouble(parts[0]), isMeter);
                int w = toAbsCm(Double.parseDouble(parts[1]), isMeter);
                int h = toAbsCm(Double.parseDouble(parts[2]), isMeter);
                return buildResult(l, w, h);
            }
            if (parts.length == 2) {
                int l = toAbsCm(Double.parseDouble(parts[0]), isMeter);
                int w = toAbsCm(Double.parseDouble(parts[1]), isMeter);
                return buildResult(l, w, DEFAULT_HEIGHT);
            }
        } catch (NumberFormatException ignored) {}
        return null;
    }
    private int[] tryBoxMeter(String s) {
        String norm = s.toLowerCase().replaceAll("\\s+", "").replace("*", "x");
        if (!norm.contains("m")) return null;

        String[] parts = norm.split("x");
        if (parts.length < 2) return null;

        try {
            int[] cms = new int[parts.length];
            for (int i = 0; i < parts.length; i++) {
                cms[i] = parseMeterPart(parts[i]);
                if (cms[i] <= 0) return null;
            }
            if (cms.length >= 3) return buildResult(cms[0], cms[1], cms[2]);
            return buildResult(cms[0], cms[1], DEFAULT_HEIGHT);
        } catch (Exception e) {
            return null;
        }
    }

    private int[] tryLabeledDims(String s) {
        Pattern p = Pattern.compile("[DdRrCcSsWwHhLl]\\s*([0-9]+(?:\\.[0-9]+)?)\\s*(cm|m)?");
        Matcher m = p.matcher(s);
        List<Integer> vals = new ArrayList<>();
        while (m.find()) {
            double val = Double.parseDouble(m.group(1));
            boolean isMeter = "m".equalsIgnoreCase(m.group(2));
            vals.add(isMeter ? (int)(val * 100) : (int) val);
        }
        if (vals.size() >= 3) return buildResult(vals.get(0), vals.get(1), vals.get(2));
        if (vals.size() == 2) return buildResult(vals.get(0), vals.get(1), DEFAULT_HEIGHT);
        return null;
    }

    private int[] tryVietnameseDims(String s) {
        String norm = s.toLowerCase();
        if (!norm.matches(".*\\b(dài|rộng|cao|sâu|ngang)\\b.*")) return null;

        Pattern p = Pattern.compile(
                "(dài|rộng|cao|sâu|ngang)\\s*:?\\s*([0-9]+(?:[.,][0-9]+)?)\\s*(cm|m)?",
                Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE);
        Matcher m = p.matcher(norm);

        int length = 0, width = 0, height = 0;
        while (m.find()) {
            String key  = m.group(1).toLowerCase();
            double val  = Double.parseDouble(m.group(2).replace(",", "."));
            boolean isMeter = "m".equalsIgnoreCase(m.group(3));
            int cm = isMeter ? (int)(val * 100) : (int) val;

            switch (key) {
                case "dài"          -> { if (length == 0) length = cm; }
                case "rộng", "ngang"-> { if (width  == 0) width  = cm; }
                case "cao"          -> { if (height == 0) height = cm; }
                case "sâu"          -> { if (length == 0) length = cm;
                else if (width == 0) width = cm; }
            }
        }

        if (length > 0 && width > 0 && height > 0) return buildResult(length, width, height);
        if (length > 0 && width  > 0) return buildResult(length, width,  DEFAULT_HEIGHT);
        if (length > 0) return buildResult(length, DEFAULT_WIDTH, DEFAULT_HEIGHT);
        return null;
    }

    private int[] trySingleDim(String s) {
        int cm = parseMeterPart(s.toLowerCase().replaceAll("\\s+", ""));
        if (cm > 0) return buildResult(cm, DEFAULT_WIDTH, DEFAULT_HEIGHT);
        return null;
    }

    private int parseMeterPart(String part) {
        Matcher mM = Pattern.compile("^([0-9]+)m([0-9]*)$").matcher(part);
        if (mM.matches()) {
            int meters = Integer.parseInt(mM.group(1));
            String dec = mM.group(2);
            int cm = meters * 100;
            if (!dec.isEmpty()) {
                cm += dec.length() == 1
                        ? Integer.parseInt(dec) * 10
                        : Integer.parseInt(dec);
            }
            return cm;
        }
        Matcher mDec = Pattern.compile("^([0-9]+\\.?[0-9]*)m$").matcher(part);
        if (mDec.matches()) return (int) Math.round(Double.parseDouble(mDec.group(1)) * 100);
        Matcher mCm = Pattern.compile("^([0-9]+(?:\\.[0-9]+)?)cm$").matcher(part);
        if (mCm.matches()) return (int) Double.parseDouble(mCm.group(1));
        Matcher mNum = Pattern.compile("^([0-9]+\\.?[0-9]*)$").matcher(part);
        if (mNum.matches()) return (int) Double.parseDouble(mNum.group(1));

        return -1;
    }

    private int toAbsCm(double val, boolean isMeter) {
        return isMeter ? (int) Math.round(val * 100) : (int) val;
    }

    private int[] buildResult(int l, int w, int h) {
        l = Math.max(1, l);
        w = Math.max(1, w);
        h = Math.max(1, h);
        int volumetricWeight = (l * w * h) / 6;
        int weight = Math.max(DEFAULT_WEIGHT, volumetricWeight);
        return new int[]{weight, l, w, h};
    }

    private int[] def() {
        return new int[]{DEFAULT_WEIGHT, DEFAULT_LENGTH, DEFAULT_WIDTH, DEFAULT_HEIGHT};
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}