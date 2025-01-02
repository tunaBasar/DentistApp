package com.example.dentistapp.Converter;

import com.example.dentistapp.Dto.AppointmentDto;
import com.example.dentistapp.Model.Appointment;
import org.springframework.stereotype.Component;

@Component
public class AppointmentConverter {

    public AppointmentDto toDto(Appointment appointment) {
        AppointmentDto appointmentDto = new AppointmentDto();
        appointmentDto.setId(appointment.getId());
        appointmentDto.setAvailable(appointment.isAvailable());
        appointmentDto.setDentist(appointment.getDentist());
        appointmentDto.setPatient(appointment.getPatient());
        appointmentDto.setAppointmentDateTime(appointment.getAppointmentDateTime());
        return appointmentDto;
    }

    public Appointment toEntity(AppointmentDto appointmentDto) {
        Appointment appointment = new Appointment();
        appointment.setId(appointmentDto.getId());
        appointment.setAvailable(appointmentDto.isAvailable());
        appointment.setDentist(appointmentDto.getDentist());
        appointment.setPatient(appointmentDto.getPatient());
        appointment.setAppointmentDateTime(appointmentDto.getAppointmentDateTime());

        return appointment;
    }
}
