package com.example.ttltw_project.config;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;

import java.io.IOException;
import java.io.InputStream;
import java.util.Collections;
import java.util.Properties;

public class GoogleOAuthConfig {

    private static final String REDIRECT_URI = "http://localhost:8080/TTLTW_Project/callback-google";
    private static final JacksonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();
    private static final NetHttpTransport HTTP_TRANSPORT = new NetHttpTransport();
    private static GoogleAuthorizationCodeFlow flow;

    static {
        try {
            Properties props = new Properties();
            try (InputStream input = GoogleOAuthConfig.class.getClassLoader().getResourceAsStream("google.properties")) {
                if (input == null) {
                    throw new RuntimeException("Không tìm thấy file google.properties!");
                }
                props.load(input);
            }

            String CLIENT_ID = props.getProperty("google.client_id");
            String CLIENT_SECRET = props.getProperty("google.client_secret");

            if (CLIENT_ID == null || CLIENT_SECRET == null) {
                throw new RuntimeException("Thiếu client_id hoặc client_secret trong google.properties!");
            }
            System.out.println("Loaded Google Client ID: " + CLIENT_ID);
            flow = new GoogleAuthorizationCodeFlow.Builder( HTTP_TRANSPORT, JSON_FACTORY, CLIENT_ID, CLIENT_SECRET, Collections.singleton("https://www.googleapis.com/auth/userinfo.email"))
                    .setAccessType("online")
                    .setApprovalPrompt("auto")
                    .build();
            System.out.println("Google OAuth configured successfully!");
        } catch (IOException e) {
            throw new RuntimeException("Failed to load Google OAuth config: " + e.getMessage(), e);
        }
    }

    public static String getAuthorizationUrl() {
        return flow.newAuthorizationUrl().setRedirectUri(REDIRECT_URI).build();
    }

    public static GoogleIdToken exchangeCodeForToken(String code) throws IOException {
        GoogleTokenResponse tokenResponse = flow.newTokenRequest(code).setRedirectUri(REDIRECT_URI).execute();
        return tokenResponse.parseIdToken();
    }
}
