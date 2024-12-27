package com.example.dentistapp.Service;

import com.example.dentistapp.Converter.Converter;
import com.example.dentistapp.Dto.RecipeDto;
import com.example.dentistapp.Model.Recipe;
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
        return recipes.stream()
                .map(converter::recipeConvertToDto)
                .collect(Collectors.toList());
    }

    public RecipeDto getRecipeById(UUID id) {
        return converter.recipeConvertToDto
                (recipeRepository.findById(id).orElseThrow(
                        () -> new RuntimeException("Recipe not found")));
    }

    

}
