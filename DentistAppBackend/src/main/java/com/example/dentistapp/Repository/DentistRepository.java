package com.example.dentistapp.Repository;


import com.example.dentistapp.Model.Dentist;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface DentistRepository extends JpaRepository<Dentist, UUID> {
}
