package com.example.dentistapp.Converter;

import com.example.dentistapp.Dto.PatientDto;
import com.example.dentistapp.Model.Patient;
import com.example.dentistapp.Model.Role;
import com.example.dentistapp.Repository.RoleRepository;
import org.springframework.stereotype.Component;

@Component
public class PatientConverter {

private final RoleRepository roleRepository;

public PatientConverter(RoleRepository roleRepository) {
    this.roleRepository = roleRepository;
}

    public PatientDto toDto(Patient patient) {
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

    public Patient toEntity(PatientDto patientDto) {
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
}
