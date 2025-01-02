package com.example.dentistapp.Converter;

import com.example.dentistapp.Dto.TreatmentDto;
import com.example.dentistapp.Model.Treatment;
import org.springframework.stereotype.Component;


@Component
public class TreatmentConverter {

    public TreatmentDto toDto(Treatment treatment) {
        TreatmentDto treatmentDto = new TreatmentDto();
        treatmentDto.setId(treatment.getId());
        treatmentDto.setTreatmentName(treatment.getTreatmentName());
        treatmentDto.setTreatmentDescription(treatment.getTreatmentDescription());
        return treatmentDto;
    }

    public Treatment toEntity(TreatmentDto treatmentDto) {
        Treatment treatment=new Treatment();
        treatment.setId(treatmentDto.getId());
        treatment.setTreatmentName(treatmentDto.getTreatmentName());
        treatment.setTreatmentDescription(treatmentDto.getTreatmentDescription());
        return treatment;
    }


}
