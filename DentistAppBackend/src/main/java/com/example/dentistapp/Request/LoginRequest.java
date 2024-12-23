package com.example.dentistapp.Request;

public class LoginRequest {

    public String getSSID() {
        return SSID;
    }


    public String getPassword() {
        return Password;
    }

    public void setSSID(String SSID) {
        this.SSID = SSID;
    }

    public void setPassword(String password) {
        Password = password;
    }

    private String SSID;
    private String Password;
}
