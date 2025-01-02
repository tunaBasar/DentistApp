package com.example.dentistapp.Controller;

import com.example.dentistapp.Dto.PatientDto;
import com.example.dentistapp.Request.LoginRequest;
import com.example.dentistapp.Service.PatientService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

import static org.springframework.http.HttpStatus.CREATED;
import static org.springframework.http.HttpStatus.OK;

@RestController
@RequestMapping("/api/patients")
public class PatientController {

    private final PatientService patientService;

    public PatientController(PatientService patientService) {
        this.patientService = patientService;
    }

    @GetMapping
    public ResponseEntity<List<PatientDto>> getAllUsers() {
        return new ResponseEntity<>(patientService.getAllPatients(), OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<PatientDto> getUserById(@PathVariable UUID id) {
        return new ResponseEntity<>(patientService.getPatientById(id),OK);
    }

    @PostMapping
    public ResponseEntity<PatientDto> createUser(@RequestBody PatientDto patientDto) {
        patientService.createPatient(patientDto);
        return new ResponseEntity<>(patientDto, CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<PatientDto> updateUser(@PathVariable UUID id, @RequestBody PatientDto patientDto) {
        return new
                ResponseEntity<>(patientService.updatePatient(id,patientDto),OK);
    }

    @DeleteMapping("/{id}")
    public void deleteUser(@PathVariable UUID id) {
        patientService.deletePatientById(id);
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
        return new ResponseEntity<>(patientService.login(loginRequest), OK);
    }
}
