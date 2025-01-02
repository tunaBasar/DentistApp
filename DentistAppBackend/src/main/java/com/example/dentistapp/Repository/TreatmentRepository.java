package com.example.dentistapp.Repository;

import com.example.dentistapp.Model.Treatment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TreatmentRepository extends JpaRepository<Treatment, Long> {
}
