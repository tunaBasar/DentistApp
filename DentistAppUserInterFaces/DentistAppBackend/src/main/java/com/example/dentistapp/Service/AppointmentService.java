package com.example.dentistapp.Service;

import com.example.dentistapp.Converter.Converter;
import com.example.dentistapp.Dto.AppointmentDto;
import com.example.dentistapp.Exception.ResourceNotFoundException;
import com.example.dentistapp.Model.Appointment;
import com.example.dentistapp.Model.Dentist;
import com.example.dentistapp.Model.Patient;
import com.example.dentistapp.Repository.AppointmentRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class AppointmentService {

    private final AppointmentRepository appointmentRepository;
    private final DentistService dentistService;
    private final PatientService patientService;
    private final Converter converter;

    public AppointmentService(AppointmentRepository appointmentRepository,
                              DentistService dentistService,
                              PatientService patientService,
                              Converter converter) {
        this.appointmentRepository = appointmentRepository;
        this.dentistService = dentistService;
        this.patientService = patientService;
        this.converter = converter;
    }

    public AppointmentDto createAppointment(AppointmentDto appointmentDto) {
        Dentist dentist = converter.dentistConvertFromDto(dentistService.getDentistById(appointmentDto.getDentistId()));
        Patient patient = converter.patientConvertFromDto(patientService.getPatientById(appointmentDto.getPatientId()));

        if (dentist == null) {
            throw new ResourceNotFoundException("Dentist not found with id: " + appointmentDto.getDentistId());
        }
        if (patient == null) {
            throw new ResourceNotFoundException("Patient not found with id: " + appointmentDto.getPatientId());
        }

        Appointment appointment = new Appointment();
        appointment.setDentist(dentist);
        appointment.setPatient(patient);
        appointment.setAppointmentDateTime(appointmentDto.getAppointmentDateTime());
        appointment.setStatus(appointmentDto.getStatus());

        return converter.appointmentConvertToDto(appointmentRepository.save(appointment));
    }


    public List<AppointmentDto>getAppointmentByPatientId(UUID id){
        List<Appointment> appointments = appointmentRepository.getAppointmentsByPatientId(id);
        return appointments.stream().
                map(converter::appointmentConvertToDto).
                collect(Collectors.toList());
   }
    public List<AppointmentDto>getAppointmentByDentistId(UUID id){
        List<Appointment> appointments = appointmentRepository.getAppointmentsByDentistId(id);
        return appointments.stream().
                map(converter::appointmentConvertToDto).
                collect(Collectors.toList());
    }

    public void deleteAppointmentById(UUID id){
        appointmentRepository.deleteById(id);
    }

    public List<AppointmentDto> getAppointment() {
        return appointmentRepository.findAll().stream()
                .map(converter::appointmentConvertToDto)
                .collect(Collectors.toList());
    }
}
