package com.example.android.password;

import android.os.Bundle;
import android.util.Log;
import android.widget.Button;
import android.widget.EditText;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.lifecycle.ViewModelProvider;

import com.google.android.material.snackbar.Snackbar;

public class MainActivity extends AppCompatActivity {

    private EditText etNewPassword, etUserEmailAddress, etUserLoginId;
    private Button btnChangePassword;
    private ChangePasswordViewModel viewModel;
    private static final String TAG = "MainActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });
        ChangePasswordRepository repository = new ChangePasswordRepository();
        ViewModelFactory factory = new ViewModelFactory(repository);

        viewModel = new ViewModelProvider(this, factory).get(ChangePasswordViewModel.class);

        etNewPassword = findViewById(R.id.etNewPassword);
        etUserEmailAddress = findViewById(R.id.etUserEmailAddress);
        etUserLoginId = findViewById(R.id.etUserLoginId);
        btnChangePassword = findViewById(R.id.btnChangePassword);

        viewModel.snackbarMessage.observe(this, message -> {
            if (message != null) {
                Snackbar.make(btnChangePassword, message, Snackbar.LENGTH_LONG).show();
            }
        });

        btnChangePassword.setOnClickListener(v -> {
            Log.d(TAG, "Change Password button clicked");

            String newPassword = etNewPassword.getText().toString();
            String email = etUserEmailAddress.getText().toString();
            String userId = etUserLoginId.getText().toString();

            viewModel.newPassword.setValue(newPassword);
            viewModel.currentUserEmailAddress.setValue(email);
            viewModel.currentUserLoginId.setValue(userId);

            viewModel.validateNewPassword();
        });
    }
}