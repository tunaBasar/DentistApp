package com.example.dentistapp.Repository;


import com.example.dentistapp.Model.Dentist;
import com.example.dentistapp.Model.Patient;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface DentistRepository extends JpaRepository<Dentist, UUID> {
    List<Dentist> findBySpecializationAndLocation(String specialization, String location);

    Patient findDentistById(UUID id);

    Dentist findDentistBySSID(String ssid);
}
