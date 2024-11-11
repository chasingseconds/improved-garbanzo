package com.example.android.password;

public class ChangePasswordRepository {

    public boolean isPasswordContainingEmailOrUserId(String newPassword, String email, String userId) {
        if (newPassword == null || email == null || userId == null) {
            return false;
        }
        return newPassword.toUpperCase().contains(email.toUpperCase()) ||
                newPassword.toUpperCase().contains(userId.toUpperCase());
    }
}
