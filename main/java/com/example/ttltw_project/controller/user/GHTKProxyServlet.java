package com.example.ttltw_project.controller.user;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "GHTKProxyServlet", value = "/api/ghtk/*")
public class GHTKProxyServlet extends HttpServlet {

    private static final String GHTK_TOKEN = "b7ec17d2424604c130422f4d9e2368adbe35d5f5";
    private static final String BASE_URL = "https://services.giaohangtietkiem.vn";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String queryString = request.getQueryString();
        String apiUrl = BASE_URL + "/services/shipment/fee";
        if (queryString != null) apiUrl += "?" + queryString;

        System.out.println("GHTK GET → " + apiUrl);

        HttpURLConnection conn = (HttpURLConnection) new URL(apiUrl).openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Token", GHTK_TOKEN);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("X-Client-Source", "");

        int status = conn.getResponseCode();
        InputStream is = (status == 200) ? conn.getInputStream() : conn.getErrorStream();
        String result = new String(is.readAllBytes(), StandardCharsets.UTF_8);

        System.out.println("GHTK status=" + status + " → " + result);

        response.setContentType("application/json;charset=UTF-8");
        response.setStatus(status);
        response.getWriter().write(result);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}