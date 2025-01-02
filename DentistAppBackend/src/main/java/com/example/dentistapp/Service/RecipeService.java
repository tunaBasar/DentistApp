package com.example.dentistapp.Service;


import com.example.dentistapp.Converter.DentistConverter;
import com.example.dentistapp.Converter.RecipeConverter;
import com.example.dentistapp.Dto.DentistDto;
import com.example.dentistapp.Dto.RecipeDto;
import com.example.dentistapp.Exception.ResourceNotFoundException;
import com.example.dentistapp.Model.Recipe;
import com.example.dentistapp.Repository.RecipeRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class RecipeService {

    private final RecipeRepository recipeRepository;
    private final RecipeConverter recipeConverter;
    private final DentistService dentistService;
    private final DentistConverter dentistConverter;

    public RecipeService(RecipeRepository recipeRepository, RecipeConverter recipeConverter, DentistService dentistService, DentistConverter dentistConverter) {
        this.recipeRepository = recipeRepository;
        this.recipeConverter = recipeConverter;
        this.dentistService = dentistService;
        this.dentistConverter = dentistConverter;
    }

    public List<RecipeDto> getAllRecipes() {
        List<Recipe> recipes = recipeRepository.findAll();
        return recipes.stream().map(recipeConverter::toDto).collect(Collectors.toList());
    }

    public RecipeDto getRecipeById(Long id) {
        Recipe recipe = recipeRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Recipe not found"));

        return recipeConverter.toDto(recipe);
    }

    public RecipeDto createRecipe(RecipeDto recipeDto, UUID dentistId) {
        DentistDto dentistDto = dentistService.getDentistById(dentistId);
        recipeDto.setDentist(dentistConverter.toEntity(dentistDto));

        Recipe recipe = recipeConverter.toEntity(recipeDto);
        Recipe savedRecipe = recipeRepository.save(recipe);

        return recipeConverter.toDto(savedRecipe);
    }

    public void deleteRecipeById(Long id) {
        recipeRepository.deleteById(id);
    }

}
