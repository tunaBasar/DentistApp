package com.example.dentistapp.Repository;

import com.example.dentistapp.Dto.FilterCriteria;
import com.example.dentistapp.Model.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface AppointmentRepository extends JpaRepository<Appointment, UUID> {
    List<Appointment>getAppointmentsByDentistId(UUID id);
    List<Appointment> getAppointmentsByPatientId(UUID id);
}
