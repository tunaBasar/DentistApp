package com.example.dentistapp.Service;

import com.example.dentistapp.Converter.Converter;
import com.example.dentistapp.Dto.AppointmentDto;
import com.example.dentistapp.Dto.FilterCriteria;
import com.example.dentistapp.Enum.AppointmentStatus;
import com.example.dentistapp.Exception.ResourceNotFoundException;
import com.example.dentistapp.Model.Appointment;
import com.example.dentistapp.Model.Dentist;
import com.example.dentistapp.Model.Patient;
import com.example.dentistapp.Model.Treatment;
import com.example.dentistapp.Repository.AppointmentRepository;
import com.example.dentistapp.Request.AppointmentRequest;
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
    private final TreatmentService treatmentService;

    public AppointmentService(AppointmentRepository appointmentRepository,
                              DentistService dentistService,
                              PatientService patientService,
                              Converter converter, TreatmentService treatmentService) {
        this.appointmentRepository = appointmentRepository;
        this.dentistService = dentistService;
        this.patientService = patientService;
        this.converter = converter;
        this.treatmentService = treatmentService;
    }

    public AppointmentRequest bookAppointment(AppointmentRequest request) {
        Appointment appointment = new Appointment();
        Dentist dentist= converter.dentistConvertFromDto(dentistService.getDentistById(request.getDentistId()));
        Patient patient= converter.patientConvertFromDto(patientService.getPatientById(request.getPatientId()));
        Treatment treatment= converter.treatmentConvertFromDto(treatmentService.getTreatmentById(request.getTreatmentId()));
        if (dentist != null) {
            appointment.setDentist(dentist);
        }
        else {
            throw new ResourceNotFoundException("Dentist not found"+request.getDentistId());
        }
        if (patient != null) {
            appointment.setPatient(patient);
        }
        else {
            throw new ResourceNotFoundException("Patient not found"+request.getPatientId());
        }
        if (treatment != null) {
            appointment.setTreatment(treatment);
        }
        else {
            throw new ResourceNotFoundException("Treatment not found"+request.getTreatmentId());
        }
        appointment.setAppointmentDateTime(request.getDateTime());
        appointmentRepository.save(appointment);
        return request;
    }


    public List<AppointmentDto>getAppointmentByPatientId(UUID id){
        List<Appointment> appointments = appointmentRepository.getAppointmentsByPatientId(id);
        return appointments.stream().
                map(converter::appointmentConvertToDto).
                collect(Collectors.toList());
   }
    public AppointmentDto addAvailability(UUID dentistId, Appointment appointment) {
        appointment.setDentist(converter.dentistConvertFromDto(dentistService.getDentistById(dentistId)));
        appointment.setAvailable(true);
        return converter.appointmentConvertToDto(appointmentRepository.save(appointment));
    }
    public List<AppointmentDto>getAppointmentByDentistId(UUID id){
        List<Appointment> appointments = appointmentRepository.getAppointmentsByDentistId(id);
        return appointments.stream().
                map(converter::appointmentConvertToDto).
                collect(Collectors.toList());
    }
    public AppointmentDto updateAppointmentStatus(UUID appointmentId, AppointmentStatus status) {
        Appointment appointment = appointmentRepository.findById(appointmentId).orElseThrow(() -> new RuntimeException("Appointment not found"));
        appointment.setStatus(status);
        return converter.appointmentConvertToDto(appointmentRepository.save(appointment));
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
