package com.example.dentistapp.Service;

import com.example.dentistapp.Converter.Converter;
import com.example.dentistapp.Dto.TreatmentDto;
import com.example.dentistapp.Model.Treatment;
import com.example.dentistapp.Repository.TreatmentRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class TreatmentService {

    private final TreatmentRepository treatmentRepository;
    private final Converter converter;
    public TreatmentService(TreatmentRepository treatmentRepository,Converter converter) {
        this.treatmentRepository = treatmentRepository;
        this.converter = converter;
    }

    public List<TreatmentDto> getAllTreatments() {
        List<Treatment> treatments = treatmentRepository.findAll();
        return treatments.stream()
                .map(converter::treatmentConvertToDto)
                .collect(Collectors.toList());
    }

    public TreatmentDto getTreatmentById(UUID id) {
        return converter.treatmentConvertToDto(treatmentRepository.findById(id).orElseThrow(
                () -> new RuntimeException("Treatment not found")));
    }

    public TreatmentDto createTreatment(TreatmentDto treatmentDto) {
        Treatment treatment=treatmentRepository.save(
                converter.treatmentConvertFromDto(treatmentDto));
        return converter.treatmentConvertToDto(treatment);
    }

    public TreatmentDto updateTreatment(TreatmentDto treatmentDto, UUID id) {
        Treatment treatment=converter.treatmentConvertFromDto
                (getTreatmentById(id));
        treatment.setId(treatmentDto.getId());
        treatment.setTreatmentName(treatmentDto.getTreatmentName());
        treatment.setTreatmentDescription(treatmentDto.getTreatmentDescription());
        treatment.setTreatmentStatus(treatmentDto.getTreatmentStatus());
        treatment.setTreatmentDate(treatmentDto.getTreatmentDate());

        return converter.treatmentConvertToDto
                (treatmentRepository.save(treatment));
    }

    public void deleteTreatment(UUID id) {
        treatmentRepository.deleteById(id);
    }

}
