package com.example.dentistapp.Controller;

import com.example.dentistapp.Dto.AppointmentDto;
import com.example.dentistapp.Service.AppointmentService;
import com.example.dentistapp.Exception.ResourceNotFoundException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

import static org.springframework.http.HttpStatus.CREATED;
import static org.springframework.http.HttpStatus.OK;
import static org.springframework.http.HttpStatus.NOT_FOUND;

@RestController
@RequestMapping("/appointments")
public class AppointmentController {

    private final AppointmentService appointmentService;

    public AppointmentController(AppointmentService appointmentService) {
        this.appointmentService = appointmentService;
    }

    @PostMapping()
    public ResponseEntity<AppointmentDto> createAppointment(@RequestBody AppointmentDto appointmentDto) {
        return new ResponseEntity<>(appointmentService.createAppointment(appointmentDto), CREATED);
    }

    @GetMapping("/dentist/{id}")
    public ResponseEntity<List<AppointmentDto>> getAppointmentByDentistId(@PathVariable UUID id) {
        List<AppointmentDto> appointments = appointmentService.getAppointmentByDentistId(id);
        if (appointments.isEmpty()) {
            throw new ResourceNotFoundException("No appointments found for dentist with id: " + id);
        }
        return new ResponseEntity<>(appointments, OK);
    }

    @GetMapping("/patient/{id}")
    public ResponseEntity<List<AppointmentDto>> getAppointmentByPatientId(@PathVariable UUID id) {
        return new ResponseEntity<>(appointmentService.getAppointmentByPatientId(id), OK);
    }

    @GetMapping
    public ResponseEntity<List<AppointmentDto>> getAllAppointments() {
        return new ResponseEntity<>(appointmentService.getAppointment(), OK);
    }

    @DeleteMapping("/{id}")
    public void deleteAppointment(@PathVariable UUID id) {
        appointmentService.deleteAppointmentById(id);
    }

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<String> handleResourceNotFound(ResourceNotFoundException ex) {
        return new ResponseEntity<>(ex.getMessage(), NOT_FOUND);
    }
}
