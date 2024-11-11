package com.example.android.password;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

public class ChangePasswordViewModel extends ViewModel {

    private final MutableLiveData<String> snackBarMessage = new MutableLiveData<>();
    private final ChangePasswordRepository repository;

    public MutableLiveData<String> newPassword = new MutableLiveData<>();
    public MutableLiveData<String> currentUserEmailAddress = new MutableLiveData<>();
    public MutableLiveData<String> currentUserLoginId = new MutableLiveData<>();
    public MutableLiveData<String> snackbarMessage = new MutableLiveData<>();


    public ChangePasswordViewModel(ChangePasswordRepository repository) {
        this.repository = repository;
    }

    public LiveData<String> getSnackBarMessage() {
        return snackBarMessage;
    }

    public void validateNewPassword() {
        String password = newPassword.getValue();
        String email = currentUserEmailAddress.getValue();
        String userId = currentUserLoginId.getValue();

        if (password != null) {
            String emailtoUpperCase = email.toUpperCase();

            for (int i = 0; i < emailtoUpperCase.length(); i++) {
                for (int j = i + 1; j <= emailtoUpperCase.length(); j++) {
                    String emailSubstring = emailtoUpperCase.substring(i, j);
                    if (password.toUpperCase().contains(emailSubstring)) {
                        snackbarMessage.setValue("Password must not contain any part of your email.");
                    }
                }
            }

            if (password.toUpperCase().contains(userId.toUpperCase())) {
                snackbarMessage.setValue("Password must not contain your user ID.");
            } else {
                snackbarMessage.setValue("Password is valid.");
            }
        }
    }
}
