package com.example.dentistapp.Converter;

import com.example.dentistapp.Dto.RecipeDto;
import com.example.dentistapp.Model.Recipe;
import org.springframework.stereotype.Component;

@Component
public class RecipeConverter {

    public RecipeDto toDto(Recipe recipe) {
        RecipeDto recipeDto = new RecipeDto();
        recipeDto.setId(recipe.getId());
        recipeDto.setTreatment(recipe.getTreatment());
        recipeDto.setDentist(recipe.getDentist());
        recipeDto.setPatient(recipe.getPatient());
        recipeDto.setDate(recipe.getDate());

        return recipeDto;
    }

    public Recipe toEntity(RecipeDto recipeDto) {
        Recipe recipe = new Recipe();
        recipe.setId(recipeDto.getId());
        recipe.setTreatment(recipeDto.getTreatment());
        recipe.setDentist(recipeDto.getDentist());
        recipe.setPatient(recipeDto.getPatient());
        recipe.setDate(recipeDto.getDate());
        return recipe;
    }
}
