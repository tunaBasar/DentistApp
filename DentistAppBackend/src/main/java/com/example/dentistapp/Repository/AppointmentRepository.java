package com.example.dentistapp.Repository;

import com.example.dentistapp.Model.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    List<Appointment> getAppointmentsByDentistId(UUID dentistId);

    List<Appointment> getAppointmentsByPatientId(UUID patientId);
}
