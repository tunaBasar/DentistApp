package com.example.dentistapp.Repository;

import com.example.dentistapp.Model.Dentist;
import com.example.dentistapp.Model.Recipe;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface RecipeRepository extends JpaRepository<Recipe, UUID> {
    List<Recipe> getRecipesByDentistId(UUID id);
    List<Recipe> getRecipesByPatientId(UUID id);
    List<Recipe> getRecipesByTreatmentId(UUID id);
}
