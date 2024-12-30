package com.example.dentistapp.Converter;

import com.example.dentistapp.Dto.*;
import com.example.dentistapp.Model.*;
import com.example.dentistapp.Repository.DentistRepository;
import com.example.dentistapp.Repository.PatientRepository;
import com.example.dentistapp.Repository.RoleRepository;
import com.example.dentistapp.Repository.TreatmentRepository;
import org.springframework.stereotype.Component;


@Component
public class Converter {

    private final RoleRepository roleRepository;
    private final DentistRepository dentistRepository;
    private final PatientRepository patientRepository;
    private final TreatmentRepository treatmentRepository;

    public Converter(RoleRepository roleRepository, DentistRepository dentistRepository, PatientRepository patientRepository, TreatmentRepository treatmentRepository) {
        this.roleRepository = roleRepository;
        this.dentistRepository = dentistRepository;
        this.patientRepository = patientRepository;
        this.treatmentRepository = treatmentRepository;
    }

    public PatientDto patientConvertToDto(Patient patient) {
        PatientDto patientDto = new PatientDto();
        patientDto.setId(patient.getId());
        patientDto.setFirstName(patient.getFirstName());
        patientDto.setLastName(patient.getLastName());
        patientDto.setEmail(patient.getEmail());
        patientDto.setPassword(patient.getPassword());
        patientDto.setSSID(patient.getSSID());
        patientDto.setDateOfBirth(patient.getDateOfBirth());
        patientDto.setRoleId(patient.getRole().getId());
        return patientDto;
    }

    public Patient patientConvertFromDto(PatientDto patientDto) {
        Patient patient = new Patient();
        patient.setId(patientDto.getId());
        patient.setFirstName(patientDto.getFirstName());
        patient.setLastName(patientDto.getLastName());
        patient.setEmail(patientDto.getEmail());
        patient.setPassword(patientDto.getPassword());
        patient.setDateOfBirth(patientDto.getDateOfBirth());
        patient.setSSID(patientDto.getSSID());

        Role role = roleRepository.findById(patientDto.getRoleId())
                .orElseThrow(() -> new RuntimeException("Role not found"));
        patient.setRole(role);

        return patient;
    }

    public Dentist dentistConvertFromDto(DentistDto dentistDto){
        Dentist dentist=new Dentist();

        dentist.setId(dentistDto.getId());
        dentist.setFirstName(dentistDto.getFirstName());
        dentist.setLastName(dentistDto.getLastName());
        dentist.setPassword(dentistDto.getPassword());
        dentist.setSSID(dentistDto.getSSID());
        dentist.setPhoneNumber(dentistDto.getPhoneNumber());
        dentist.setSpecialization(dentistDto.getSpecialization());
        dentist.setLocation(dentistDto.getLocation());

        Role role = roleRepository.findById(dentistDto.getRoleId())
                .orElseThrow(() -> new RuntimeException("Role not found"));
        dentist.setRole(role);

        return dentist;
    }

    public DentistDto dentistConvertToDto(Dentist dentist){
        DentistDto dentistDto=new DentistDto();

        dentistDto.setId(dentist.getId());
        dentistDto.setFirstName(dentist.getFirstName());
        dentistDto.setLastName(dentist.getLastName());
        dentistDto.setPhoneNumber(dentist.getPhoneNumber());
        dentistDto.setSSID(dentist.getSSID());
        dentistDto.setPassword(dentist.getPassword());
        dentistDto.setRoleId(dentist.getRole().getId());
        dentistDto.setSpecialization(dentist.getSpecialization());
        dentistDto.setLocation(dentist.getLocation());

        return dentistDto;

    }

    public AppointmentDto appointmentConvertToDto(Appointment appointment) {
        AppointmentDto appointmentDto = new AppointmentDto();
        appointmentDto.setId(appointment.getId());
        appointmentDto.setDentistId(appointment.getDentist().getId());
        appointmentDto.setPatientId(appointment.getPatient().getId());
        appointmentDto.setAppointmentDateTime(appointment.getAppointmentDateTime());
        appointmentDto.setStatus(appointment.getStatus());
        return appointmentDto;
    }

    public TreatmentDto treatmentConvertToDto(Treatment treatment) {
        TreatmentDto treatmentDto = new TreatmentDto();
        treatmentDto.setId(treatment.getId());
        treatmentDto.setTreatmentName(treatment.getTreatmentName());
        treatmentDto.setTreatmentDescription(treatment.getTreatmentDescription());
        treatmentDto.setTreatmentDate(treatment.getTreatmentDate());
        treatmentDto.setTreatmentStatus(treatment.getTreatmentStatus());
        treatmentDto.setDentistId(treatment.getDentistId());
        return treatmentDto;
    }

    public Treatment treatmentConvertFromDto(TreatmentDto treatmentDto) {
        Treatment treatment=new Treatment();
        treatment.setId(treatmentDto.getId());
        treatment.setTreatmentName(treatmentDto.getTreatmentName());
        treatment.setTreatmentDescription(treatmentDto.getTreatmentDescription());
        treatment.setTreatmentDate(treatmentDto.getTreatmentDate());
        treatment.setTreatmentStatus(treatmentDto.getTreatmentStatus());
        treatment.setDentistId(treatmentDto.getDentistId());
        return treatment;
    }

    public RecipeDto recipeConvertToDto(Recipe recipe) {
        RecipeDto recipeDto=new RecipeDto();
        recipeDto.setId(recipe.getId());
        recipeDto.setDentistId(recipe.getDentist().getId());
        recipeDto.setPatientId(recipe.getPatient().getId());
        recipeDto.setTreatmentId(recipe.getTreatment().getId());
        recipeDto.setDescription(recipe.getDescription());

        return recipeDto;
    }
    public Recipe recipeConvertFromDto(RecipeDto recipeDto) {
        Recipe recipe = new Recipe();
        recipe.setId(recipeDto.getId());
        recipe.setDescription(recipeDto.getDescription());
        Dentist dentist=dentistRepository.findById(recipeDto.getDentistId()).
                orElseThrow(() -> new RuntimeException("Dentist not found"));
        Patient patient=patientRepository.findById(recipeDto.getPatientId())
                .orElseThrow(() -> new RuntimeException("Patient not found"));
        Treatment treatment=treatmentRepository.findById(recipeDto.getTreatmentId())
                .orElseThrow(() -> new RuntimeException("Treatment not found"));
        recipe.setDentist(dentist);
        recipe.setPatient(patient);
        recipe.setTreatment(treatment);
        return recipe;
    }

}
