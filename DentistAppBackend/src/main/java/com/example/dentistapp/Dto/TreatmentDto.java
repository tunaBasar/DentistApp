package com.example.dentistapp.Dto;


import com.example.dentistapp.Enum.TreatmentStatus;

import java.time.LocalDate;
import java.util.UUID;

public class TreatmentDto {

    private UUID id;
    private String treatmentName;
    private String treatmentDescription;
    private LocalDate treatmentDate;
    private TreatmentStatus treatmentStatus;

    public UUID getDentistId() {
        return dentistId;
    }

    public void setDentistId(UUID dentistId) {
        this.dentistId = dentistId;
    }

    private UUID dentistId;

    public TreatmentStatus getTreatmentStatus() {
        return treatmentStatus;
    }

    public void setTreatmentStatus(TreatmentStatus treatmentStatus) {
        this.treatmentStatus = treatmentStatus;
    }

    public LocalDate getTreatmentDate() {
        return treatmentDate;
    }

    public void setTreatmentDate(LocalDate treatmentDate) {
        this.treatmentDate = treatmentDate;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getTreatmentName() {
        return treatmentName;
    }

    public void setTreatmentName(String treatmentName) {
        this.treatmentName = treatmentName;
    }

    public String getTreatmentDescription() {
        return treatmentDescription;
    }

    public void setTreatmentDescription(String treatmentDescription) {
        this.treatmentDescription = treatmentDescription;
    }
}
