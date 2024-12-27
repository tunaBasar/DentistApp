package com.example.dentistapp.Service;

import com.example.dentistapp.Converter.Converter;
import com.example.dentistapp.Dto.RecipeDto;
import com.example.dentistapp.Model.Dentist;
import com.example.dentistapp.Model.Patient;
import com.example.dentistapp.Model.Recipe;
import com.example.dentistapp.Model.Treatment;
import com.example.dentistapp.Repository.RecipeRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class RecipeService {

    private final RecipeRepository recipeRepository;
    private final DentistService dentistService;
    private final PatientService patientService;
    private final TreatmentService treatmentService;
    private final Converter converter;

    public RecipeService(RecipeRepository recipeRepository, DentistService dentistService, PatientService patientService, TreatmentService treatmentService, Converter converter) {
        this.recipeRepository = recipeRepository;
        this.dentistService = dentistService;
        this.patientService = patientService;
        this.treatmentService = treatmentService;
        this.converter = converter;
    }

    public List<RecipeDto> getAllRecipes() {
        List<Recipe> recipes = recipeRepository.findAll();
        return recipes.stream().map(converter::recipeConvertToDto).collect(Collectors.toList());
    }

    public RecipeDto getRecipeById(UUID id) {
        return converter.recipeConvertToDto(recipeRepository.findById(id).orElseThrow(() -> new RuntimeException("Recipe not found")));
    }

    public RecipeDto createRecipe(RecipeDto recipeDto) {
        Dentist dentist = converter.dentistConvertFromDto(dentistService.getDentistById(recipeDto.getDentistId()));
        Patient patient = converter.patientConvertFromDto(patientService.getPatientById(recipeDto.getPatientId()));
        Treatment treatment = converter.treatmentConvertFromDto(treatmentService.getTreatmentById(recipeDto.getTreatmentId()));

        if (dentist == null) {
            throw new RuntimeException("Dentist not found" + recipeDto.getDentistId());
        }
        if (patient == null) {
            throw new RuntimeException("Patient not found" + recipeDto.getPatientId());
        }
        if (treatment == null) {
            throw new RuntimeException("Treatment not found" + recipeDto.getTreatmentId());
        }

        Recipe recipe = new Recipe();
        recipe.setDentist(dentist);
        recipe.setPatient(patient);
        recipe.setTreatment(treatment);
        recipe.setId(recipeDto.getId());
        recipe.setDescription(recipeDto.getDescription());

        return converter.recipeConvertToDto(recipeRepository.save(recipe));
    }

    public void deleteRecipeById(UUID id) {
        recipeRepository.deleteById(id);
    }

    public List<RecipeDto> getRecipesByPatientId(UUID id) {
        List<Recipe> recipes = recipeRepository.getRecipesByPatientId(id);
        return recipes.stream().map(converter::recipeConvertToDto).collect(Collectors.toList());
    }

    public List<RecipeDto> getRecipesByTreatmentId(UUID id) {
        List<Recipe> recipes = recipeRepository.getRecipesByTreatmentId(id);
        return recipes.stream().map(converter::recipeConvertToDto).collect(Collectors.toList());
    }

    public List<RecipeDto> getRecipesByDentistId(UUID id) {
        List<Recipe> recipes = recipeRepository.getRecipesByDentistId(id);
        return recipes.stream().map(converter::recipeConvertToDto).collect(Collectors.toList());
    }

}
