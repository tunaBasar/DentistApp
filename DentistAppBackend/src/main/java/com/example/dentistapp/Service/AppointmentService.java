package com.example.dentistapp.Service;

import com.example.dentistapp.Converter.AppointmentConverter;
import com.example.dentistapp.Converter.PatientConverter;
import com.example.dentistapp.Dto.AppointmentDto;
import com.example.dentistapp.Exception.ResourceNotFoundException;
import com.example.dentistapp.Model.Appointment;
import com.example.dentistapp.Model.Patient;
import com.example.dentistapp.Repository.AppointmentRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class AppointmentService {

    private final AppointmentRepository appointmentRepository;
    private final AppointmentConverter appointmentConverter;
    private final PatientService patientService;
    private final PatientConverter patientConverter;

    public AppointmentService(AppointmentRepository appointmentRepository, AppointmentConverter appointmentConverter, PatientService patientService, PatientConverter patientConverter){
        this.appointmentRepository = appointmentRepository;
        this.appointmentConverter = appointmentConverter;
        this.patientService = patientService;
        this.patientConverter = patientConverter;
    }

    public List<AppointmentDto> getAllAppointments(){
        List<Appointment> appointments = appointmentRepository.findAll();
        return appointments.stream()
                .map(appointmentConverter::toDto)
                .collect(Collectors.toList());
    }

    public AppointmentDto getAppointmentById(Long id){
        Appointment appointment = appointmentRepository.findById(id).orElseThrow(
                () -> new RuntimeException("No appointment found with id: " + id));

        return appointmentConverter.toDto(appointment);

    }

    public AppointmentDto createAppointment(AppointmentDto appointmentDto){
        Appointment appointment=appointmentRepository
                .save(appointmentConverter.toEntity(appointmentDto));
        return appointmentConverter.toDto(appointment);
    }

    public AppointmentDto updateAppointment(Long id, AppointmentDto appointmentDto){
       Appointment oldAppointment= appointmentConverter.toEntity(getAppointmentById(id));

        oldAppointment.setAvailable(appointmentDto.isAvailable());
        oldAppointment.setAppointmentDateTime(appointmentDto.getAppointmentDateTime());
        oldAppointment.setDentist(appointmentDto.getDentist());
        oldAppointment.setPatient(appointmentDto.getPatient());
        appointmentRepository.save(oldAppointment);

        return appointmentConverter.toDto(oldAppointment);
    }

    public void deleteAppointmentById(Long id){
        appointmentRepository.deleteById(id);
    }

    public List<AppointmentDto> getAllAppointmentsByDentistId(UUID dentistId){
        List<Appointment> appointments=appointmentRepository.getAppointmentsByDentistId(dentistId);
        return appointments.stream()
                .map(appointmentConverter::toDto)
                .collect(Collectors.toList());
    }
    public List<AppointmentDto> getAllAppointmentsByPatientId(UUID patientId){
        List<Appointment> appointments=appointmentRepository.getAppointmentsByPatientId(patientId);
        return appointments.stream()
                .map(appointmentConverter::toDto)
                .collect(Collectors.toList());
    }

    public AppointmentDto savePatientToAppointment(Long id,UUID patientId){
        Appointment appointment=appointmentRepository.findById(id).orElseThrow
                (() -> new ResourceNotFoundException("No appointment found with id: " + id));
        Patient newpatient=patientConverter.toEntity(patientService.getPatientById(patientId));

        if (!appointment.isAvailable()){
            throw new IllegalStateException("The appointment is not available.");
        }
        appointment.setPatient(newpatient);
        appointment.setAvailable(false);
        return appointmentConverter.toDto(appointmentRepository.save(appointment));
    }

}
