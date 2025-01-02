package com.example.dentistapp.Controller;

import com.example.dentistapp.Dto.*;
import com.example.dentistapp.Service.AdminService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/admin")
public class AdminController {
    private final AdminService adminService;

    public AdminController(AdminService adminService) {
        this.adminService = adminService;
    }

    // List All
    @GetMapping("/patients")
    public ResponseEntity<List<PatientDto>> getAllPatients() {
        return ResponseEntity.ok(adminService.getPatients());
    }

    @GetMapping("/dentists")
    public ResponseEntity<List<DentistDto>> getAllDentists() {
        return ResponseEntity.ok(adminService.getDentists());
    }

    @GetMapping("/treatments")
    public ResponseEntity<List<TreatmentDto>> getAllTreatments() {
        return ResponseEntity.ok(adminService.getTreatments());
    }

    @GetMapping("/recipes")
    public ResponseEntity<List<RecipeDto>> getAllRecipes() {
        return ResponseEntity.ok(adminService.getRecipes());
    }

    @GetMapping("/appointments")
    public ResponseEntity<List<AppointmentDto>> getAllAppointments() {
        return ResponseEntity.ok(adminService.getAppointments());
    }

    // Get by ID
    @GetMapping("/patients/{id}")
    public ResponseEntity<PatientDto> getPatientById(@PathVariable UUID id) {
        return ResponseEntity.ok(adminService.getPatientById(id));
    }

    @GetMapping("/dentists/{id}")
    public ResponseEntity<DentistDto> getDentistById(@PathVariable UUID id) {
        return ResponseEntity.ok(adminService.getDentistById(id));
    }

    @GetMapping("/treatments/{id}")
    public ResponseEntity<TreatmentDto> getTreatmentById(@PathVariable Long id) {
        return ResponseEntity.ok(adminService.getTreatmentById(id));
    }

    @GetMapping("/recipes/{id}")
    public ResponseEntity<RecipeDto> getRecipeById(@PathVariable Long id) {
        return ResponseEntity.ok(adminService.getRecipeById(id));
    }

    @GetMapping("/appointments/{id}")
    public ResponseEntity<AppointmentDto> getAppointmentById(@PathVariable Long id) {
        return ResponseEntity.ok(adminService.getAppointmentById(id));
    }

    // Create
    @PostMapping("/patients")
    public ResponseEntity<PatientDto> createPatient(@RequestBody PatientDto patientDto) {
        return ResponseEntity.ok(adminService.createPatient(patientDto));
    }

    @PostMapping("/dentists")
    public ResponseEntity<DentistDto> createDentist(@RequestBody DentistDto dentistDto) {
        return ResponseEntity.ok(adminService.createDentist(dentistDto));
    }

    @PostMapping("/treatments")
    public ResponseEntity<TreatmentDto> createTreatment(@RequestBody TreatmentDto treatmentDto) {
        return ResponseEntity.ok(adminService.createTreatment(treatmentDto));
    }

    @PostMapping("/recipes/{patientId}")
    public ResponseEntity<RecipeDto> createRecipe(@RequestBody RecipeDto recipeDto, @PathVariable UUID patientId) {
        return ResponseEntity.ok(adminService.createRecipe(recipeDto, patientId));
    }

    @PostMapping("/appointments")
    public ResponseEntity<AppointmentDto> createAppointment(@RequestBody AppointmentDto appointmentDto) {
        return ResponseEntity.ok(adminService.createAppointment(appointmentDto));
    }

    // Update
    @PutMapping("/patients/{id}")
    public ResponseEntity<PatientDto> updatePatient(@RequestBody PatientDto patientDto, @PathVariable UUID id) {
        return ResponseEntity.ok(adminService.updatePatient(patientDto, id));
    }

    @PutMapping("/dentists/{id}")
    public ResponseEntity<DentistDto> updateDentist(@RequestBody DentistDto dentistDto, @PathVariable UUID id) {
        return ResponseEntity.ok(adminService.updateDentist(dentistDto, id));
    }

    @PutMapping("/treatments/{id}")
    public ResponseEntity<TreatmentDto> updateTreatment(@RequestBody TreatmentDto treatmentDto, @PathVariable Long id) {
        return ResponseEntity.ok(adminService.updateTreatment(treatmentDto, id));
    }

    @PutMapping("/appointments/{id}")
    public ResponseEntity<AppointmentDto> updateAppointment(@RequestBody AppointmentDto appointmentDto, @PathVariable Long id) {
        return ResponseEntity.ok(adminService.updateAppointment(appointmentDto, id));
    }

    // Delete
    @DeleteMapping("/patients/{id}")
    public ResponseEntity<Void> deletePatientById(@PathVariable UUID id) {
        adminService.deletePatientById(id);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/dentists/{id}")
    public ResponseEntity<Void> deleteDentistById(@PathVariable UUID id) {
        adminService.deleteDentistById(id);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/recipes/{id}")
    public ResponseEntity<Void> deleteRecipeById(@PathVariable Long id) {
        adminService.deleteRecipesById(id);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/appointments/{id}")
    public ResponseEntity<Void> deleteAppointmentById(@PathVariable Long id) {
        adminService.deleteAppointmentById(id);
        return ResponseEntity.noContent().build();
    }
}