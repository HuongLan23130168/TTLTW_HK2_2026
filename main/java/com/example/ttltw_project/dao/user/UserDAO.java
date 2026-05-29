package com.example.ttltw_project.dao.user;

import com.example.ttltw_project.model.user.User;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class UserDAO {
    private Jdbi jdbi = DBDAO.get();

    public boolean register(String name, String email, String rawPassword) {
        try {
            String hashedPass = EncryptionUtils.hashPassword(rawPassword);
            return jdbi.withHandle(handle ->
                    handle.createUpdate("""
                        INSERT INTO users (full_name, email, password, role, provider, status) 
                        VALUES (:name, :email, :pass, 1, 'local', 0)
                        """)
                            .bind("name", name)
                            .bind("email", email)
                            .bind("pass", hashedPass)
                            .execute() > 0
            );
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public User login(String email, String rawPassword) {
        User user = jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM users WHERE email = :email AND status = 1")
                        .bind("email", email)
                        .mapToBean(User.class)
                        .findFirst()
                        .orElse(null)
        );
        if (user == null) return null;
        String storedPassword = user.getPassword();
        if (storedPassword == null) return null;
        if (EncryptionUtils.verifyPassword(rawPassword, storedPassword)) {
            return user;
        }
        String oldMd5Hash = EncryptionUtils.hashMD5(rawPassword);
        if (oldMd5Hash != null && oldMd5Hash.equals(storedPassword)) {
            String newBcryptHash = EncryptionUtils.hashPassword(rawPassword);
            jdbi.useHandle(handle ->
                    handle.createUpdate("UPDATE users SET password = :newPass WHERE email = :email")
                            .bind("newPass", newBcryptHash)
                            .bind("email", email)
                            .execute()
            );
            return user;
        }
        return null;
    }

   public void updateToken(String email, String token) {
        jdbi.useHandle(handle ->
                handle.createUpdate("""
                    UPDATE users SET token = :token, token_expiry = DATE_ADD(NOW(), INTERVAL 15 MINUTE) 
                    WHERE email = :email
                    """)
                        .bind("token", token)
                        .bind("email", email)
                        .execute()
        );
    }

    public User getUserByToken(String token) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM users WHERE token = :token AND token_expiry > NOW()")
                        .bind("token", token)
                        .mapToBean(User.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public void clearResetToken(String email) {
        jdbi.useHandle(handle ->
                handle.createUpdate("UPDATE users SET reset_token = NULL, reset_expiry = NULL WHERE email = :email")
                        .bind("email", email)
                        .execute()
        );
    }

    public boolean checkEmailExists(String email) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM users WHERE email = :email")
                        .bind("email", email)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    public boolean updatePassword(String email, String rawPassword) {
        try {
            String hashedPass = EncryptionUtils.hashPassword(rawPassword);
            return jdbi.withHandle(handle ->
                    handle.createUpdate("UPDATE users SET password = :pass WHERE email = :email")
                            .bind("pass", hashedPass)
                            .bind("email", email)
                            .execute() > 0
            );
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<User> getAllUsers() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM users")
                        .mapToBean(User.class)
                        .list()
        );
    }

    public boolean updateAdminProfile(String email, String fullName, String birth, String gender, String phone, String address) {
        try {
            return jdbi.withHandle(handle ->
                    handle.createUpdate("UPDATE users SET full_name = :name, birth = :birth, gender = :gender, phone = :phone, address = :addr WHERE email = :email")
                            .bind("name", fullName)
                            .bind("birth", birth)
                            .bind("gender", gender)
                            .bind("phone", phone)
                            .bind("addr", address)
                            .bind("email", email)
                            .execute() > 0
            );
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public User getUserWithAddress(String email) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM users WHERE email = :email")
                        .bind("email", email)
                        .mapToBean(User.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public boolean updateUserInfo(int userId, String fullName, String phone) {
        try {
            return jdbi.withHandle(handle ->
                    handle.createUpdate("UPDATE users SET full_name = :name, phone = :phone WHERE id = :id")
                            .bind("name", fullName)
                            .bind("phone", phone)
                            .bind("id", userId)
                            .execute() > 0
            );
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public User getUserByEmail(String email) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM users WHERE email = :email")
                        .bind("email", email)
                        .mapToBean(User.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public boolean activateUser(String token) {
        try {
            return jdbi.withHandle(handle ->
                    handle.createUpdate("UPDATE users SET status = 1 WHERE token = :token AND token_expiry > NOW()")
                            .bind("token", token)
                            .execute() > 0
            );
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public void updateResetToken(String email, String token) {
        jdbi.useHandle(handle ->
                handle.createUpdate("""
                    UPDATE users SET reset_token = :token, reset_expiry = DATE_ADD(NOW(), INTERVAL 15 MINUTE) 
                    WHERE email = :email
                    """)
                        .bind("token", token)
                        .bind("email", email)
                        .execute()
        );
    }

    public boolean isResetTokenValid(String token) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM users WHERE reset_token = :token AND reset_expiry > NOW()")
                        .bind("token", token)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    public String getEmailByToken(String token) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT email FROM users WHERE reset_token = :token")
                        .bind("token", token)
                        .mapTo(String.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public User getUserByGoogleId(String googleId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM users WHERE google_id = :googleId")
                        .bind("googleId", googleId)
                        .mapToBean(User.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public boolean registerWithGoogle(String email, String fullName, String googleId, int role) {
        try {
            return jdbi.withHandle(handle ->
                    handle.createUpdate("""
                        INSERT INTO users (email, full_name, google_id, provider, status, role, created_at) 
                        VALUES (:email, :name, :googleId, 'google', 1, :role, NOW())
                        """)
                            .bind("email", email)
                            .bind("name", fullName != null ? fullName : email.split("@")[0])
                            .bind("googleId", googleId)
                            .bind("role", role)
                            .execute() > 0
            );
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean linkGoogleAccount(String email, String googleId) {
        try {
            return jdbi.withHandle(handle ->
                    handle.createUpdate("""
                        UPDATE users SET google_id = :googleId, provider = 'both' 
                        WHERE email = :email
                        """)
                            .bind("googleId", googleId)
                            .bind("email", email)
                            .execute() > 0
            );
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateUserRole(String email, int newRole) {
        try {
            return jdbi.withHandle(handle ->
                    handle.createUpdate("UPDATE users SET role = :role WHERE email = :email")
                            .bind("role", newRole)
                            .bind("email", email)
                            .execute() > 0
            );
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
}
