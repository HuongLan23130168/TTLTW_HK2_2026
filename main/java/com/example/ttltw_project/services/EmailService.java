package com.example.ttltw_project.services;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.io.InputStream;
import java.util.Properties;

public class EmailService {

        private Properties mailProps = new Properties();

        public EmailService() {
            try (InputStream input = getClass().getClassLoader().getResourceAsStream("mail.properties")) {
                if (input != null) {
                    mailProps.load(input);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        public void sendMagicLink(String toEmail, String token, String contextPath) {
            final String fromEmail = mailProps.getProperty("mail.username");
            final String appPassword = mailProps.getProperty("mail.password");

            if (fromEmail == null || appPassword == null) {
                System.err.println("Lỗi: Chưa cấu hình mail.properties!");
                return;
            }

            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");

            Session session = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(fromEmail, appPassword);
                }
            });

            try {
                Message message = new MimeMessage(session);
                message.setFrom(new InternetAddress(fromEmail));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
                message.setSubject("Xác thực đăng nhập");

                String link = "http://localhost:8080" + contextPath + "/verify-login?token=" + token;
                message.setContent("<h3>Chào bạn,</h3><p>Link đăng nhập duy nhất: <a href='" + link + "'>Nhấn vào đây</a></p>", "text/html; charset=utf-8");

                Transport.send(message);
            } catch (MessagingException e) {
                e.printStackTrace();
            }
        }
    public void sendEmail(String toEmail, String subject, String content) {
        final String fromEmail = mailProps.getProperty("mail.username");
        final String appPassword = mailProps.getProperty("mail.password");

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, appPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(content, "text/html; charset=utf-8");

            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}


