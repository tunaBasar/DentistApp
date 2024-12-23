package com.example.dentistapp.Service;


import com.example.dentistapp.Converter.Converter;
import com.example.dentistapp.Dto.PatientDto;
import com.example.dentistapp.Model.Patient;
import com.example.dentistapp.Repository.PatientRepository;
import com.example.dentistapp.Request.LoginRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class PatientService {

    private final Converter converter;
    private final PatientRepository patientRepository;

    public PatientService(PatientRepository patientRepository, Converter converter) {
        this.patientRepository = patientRepository;
        this.converter = converter;
    }

    public List<PatientDto> getAllPatients() {
        List<Patient> patients = patientRepository.findAll();
        return patients.stream()
                .map(converter::patientConvertToDto)
                .collect(Collectors.toList());
    }

    public PatientDto getPatientById(UUID id) {
        Patient patient = patientRepository.findById(id).orElseThrow(
                () -> new RuntimeException("Patient not found"));

        return converter.patientConvertToDto(patient);
    }

    public PatientDto updatePatient(UUID id, PatientDto patientDto) {
        Patient oldpatient= converter.patientConvertFromDto(getPatientById(id));

        oldpatient.setFirstName(patientDto.getFirstName());
        oldpatient.setLastName(patientDto.getLastName());
        oldpatient.setEmail(patientDto.getEmail());
        oldpatient.setPassword(patientDto.getPassword());
        oldpatient.setSSID(patientDto.getSSID());
        oldpatient.setDateOfBirth(patientDto.getDateOfBirth());
        oldpatient.setRole(converter.patientConvertFromDto(patientDto).getRole());

        return converter.patientConvertToDto(patientRepository.save(oldpatient));
    }

    public PatientDto createPatient(PatientDto patientDto) {
        Patient patient= patientRepository.save
               (converter.patientConvertFromDto(patientDto));
       return converter.patientConvertToDto(patient);
    }

    public void deletePatientById(UUID id) {
        patientRepository.deleteById(id);
    }

    public ResponseEntity<?> login(LoginRequest loginRequest) {
        Patient patient =patientRepository.findPatientBySSID(loginRequest.getSSID());
        if (patient == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid SSID or Password");
        }
        PatientDto patientDto=converter.patientConvertToDto(patient);

        if (patientDto.getPassword().equals(loginRequest.getPassword())) {
            return ResponseEntity.ok("Login successful");
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid SSID or Password");
        }

    }
}
