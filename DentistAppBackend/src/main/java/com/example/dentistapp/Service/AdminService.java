package com.example.dentistapp.Service;

import com.example.dentistapp.Dto.*;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class AdminService {
    private final PatientService patientService;
    private final DentistService dentistService;
    private final TreatmentService treatmentService;
    private final RecipeService recipeService;
    private final AppointmentService appointmentService;

    public AdminService(PatientService patientService, DentistService dentistService, TreatmentService treatmentService, RecipeService recipeService, AppointmentService appointmentService) {
        this.patientService = patientService;
        this.dentistService = dentistService;
        this.treatmentService = treatmentService;
        this.recipeService = recipeService;
        this.appointmentService = appointmentService;
    }

    //List
    public List<PatientDto> getPatients() {
        return patientService.getAllPatients();
    }
    public List<DentistDto> getDentists() {
        return dentistService.getAllDentist();
    }
    public List<TreatmentDto> getTreatments() {
        return treatmentService.getAllTreatments();
    }
    public List<RecipeDto> getRecipes() {
        return recipeService.getAllRecipes();
    }
    public List<AppointmentDto> getAppointments() {
        return appointmentService.getAllAppointments();
    }
    //ListById
    public PatientDto getPatientById(UUID id) {
        return patientService.getPatientById(id);
    }
    public DentistDto getDentistById(UUID id) {
        return dentistService.getDentistById(id);
    }
    public TreatmentDto getTreatmentById(Long id) {
        return treatmentService.getTreatmentById(id);
    }
    public RecipeDto getRecipeById(Long id) {
        return recipeService.getRecipeById(id);
    }
    public AppointmentDto getAppointmentById(Long id) {
        return appointmentService.getAppointmentById(id);
    }
    //Create
    public PatientDto createPatient(PatientDto patientDto) {
        return patientService.createPatient(patientDto);
    }
    public DentistDto createDentist(DentistDto dentistDto) {
        return dentistService.createDentist(dentistDto);
    }
    public TreatmentDto createTreatment(TreatmentDto treatmentDto) {
        return treatmentService.createTreatment(treatmentDto);
    }
    public RecipeDto createRecipe(RecipeDto recipeDto,UUID id) {
        return recipeService.createRecipe(recipeDto,id);
    }
    public AppointmentDto createAppointment(AppointmentDto appointmentDto) {
        return appointmentService.createAppointment(appointmentDto);
    }

    //Update
    public PatientDto updatePatient(PatientDto patientDto, UUID id) {
        return patientService.updatePatient(id,patientDto);
    }
    public DentistDto updateDentist(DentistDto dentistDto, UUID id) {
        return dentistService.updateDentist(id,dentistDto);
    }
    public TreatmentDto updateTreatment(TreatmentDto treatmentDto, Long id) {
        return treatmentService.updateTreatment(id,treatmentDto);
    }
    public AppointmentDto updateAppointment(AppointmentDto appointmentDto, Long id) {
        return appointmentService.updateAppointment(id,appointmentDto);
    }

    //Delete

    public void deletePatientById(UUID id) {
        patientService.deletePatientById(id);
    }
    public void deleteDentistById(UUID id) {
        dentistService.deleteDentistById(id);
    }
    public void deleteRecipesById(Long id) {
        recipeService.deleteRecipeById(id);
    }
    public void deleteAppointmentById(Long id) {
        appointmentService.deleteAppointmentById(id);
    }


}
