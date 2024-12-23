package com.example.dentistapp.Converter;

import com.example.dentistapp.Dto.AppointmentDto;
import com.example.dentistapp.Dto.DentistDto;
import com.example.dentistapp.Dto.PatientDto;
import com.example.dentistapp.Exception.ResourceNotFoundException;
import com.example.dentistapp.Model.Appointment;
import com.example.dentistapp.Model.Dentist;
import com.example.dentistapp.Model.Patient;
import com.example.dentistapp.Model.Role;
import com.example.dentistapp.Repository.RoleRepository;
import org.springframework.stereotype.Component;

@Component
public class Converter {

    private final RoleRepository roleRepository;

    public Converter(RoleRepository roleRepository) {
        this.roleRepository = roleRepository;
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
        patientDto.setRoleId(patient.getRole().getId()); // Role'den ID alındı
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
                .orElseThrow(() -> new RuntimeException("Role not found for ID: " + patientDto.getRoleId()));
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

        Role role = roleRepository.findById(dentistDto.getRoleId())
                .orElseThrow(() -> new RuntimeException("Role not found for ID: " + dentistDto.getRoleId()));
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
}
