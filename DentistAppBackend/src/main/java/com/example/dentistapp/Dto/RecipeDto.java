package com.example.dentistapp.Dto;

import java.util.UUID;

public class RecipeDto {

    private UUID id;
    private UUID dentistId;
    private UUID patientId;
    private UUID treatmentId;
    private String description;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getDentistId() {
        return dentistId;
    }

    public void setDentistId(UUID dentistId) {
        this.dentistId = dentistId;
    }

    public UUID getPatientId() {
        return patientId;
    }

    public void setPatientId(UUID patientId) {
        this.patientId = patientId;
    }

    public UUID getTreatmentId() {
        return treatmentId;
    }

    public void setTreatmentId(UUID treatmentId) {
        this.treatmentId = treatmentId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
