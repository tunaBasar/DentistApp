package com.example.dentistapp.Repository;

import com.example.dentistapp.Model.Treatment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface TreatmentRepository extends JpaRepository<Treatment, UUID> {
    List<Treatment> findByDentistIdAndTreatmentNameContaining(UUID dentistId, String name);
}
