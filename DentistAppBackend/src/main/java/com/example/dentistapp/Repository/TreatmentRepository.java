package com.example.dentistapp.Repository;

import com.example.dentistapp.Model.Treatment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface TreatmentRepository extends JpaRepository<Treatment, UUID> {
}
