package com.example.dentistapp.Service;

import com.example.dentistapp.Converter.TreatmentConverter;
import com.example.dentistapp.Dto.TreatmentDto;
import com.example.dentistapp.Exception.ResourceNotFoundException;
import com.example.dentistapp.Model.Treatment;
import com.example.dentistapp.Repository.TreatmentRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class TreatmentService {

    private final TreatmentRepository treatmentRepository;
    private final TreatmentConverter treatmentConverter;

    public TreatmentService(TreatmentRepository treatmentRepository, TreatmentConverter treatmentConverter) {
        this.treatmentRepository = treatmentRepository;
        this.treatmentConverter = treatmentConverter;
    }

    public List<TreatmentDto> getAllTreatments() {
        List<Treatment> treatments = treatmentRepository.findAll();
        return treatments.stream()
                .map(treatmentConverter::toDto)
                .collect(Collectors.toList());
    }

    public TreatmentDto createTreatment(TreatmentDto treatmentDto) {
        treatmentRepository.save(treatmentConverter.toEntity(treatmentDto));
        return treatmentDto;
    }
    public TreatmentDto getTreatmentById(Long id) {
        treatmentRepository.findById(id).orElseThrow(
                () -> new ResourceNotFoundException("There is no treatment with this id"+id));
        return treatmentConverter.toDto(treatmentRepository.findById(id).get());
    }

    public TreatmentDto updateTreatment(Long id,TreatmentDto treatmentDto) {
        Treatment treatment = treatmentConverter.toEntity(getTreatmentById(id));
        treatment.setTreatmentName(treatmentDto.getTreatmentName());
        treatment.setTreatmentDescription(treatmentDto.getTreatmentDescription());
        treatmentRepository.save(treatment);
        return treatmentConverter.toDto(treatment);
    }
}
