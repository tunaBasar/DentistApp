package com.example.dentistapp.Controller;

import com.example.dentistapp.Dto.TreatmentDto;
import com.example.dentistapp.Service.TreatmentService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/treatments")
public class TreatmentController {

    private final TreatmentService treatmentService;

    public TreatmentController(TreatmentService treatmentService) {
        this.treatmentService = treatmentService;
    }


    @GetMapping
    public ResponseEntity<List<TreatmentDto>> getAllTreatments() {
        List<TreatmentDto> treatments = treatmentService.getAllTreatments();
        return new ResponseEntity<>(treatments, HttpStatus.OK);
    }


    @GetMapping("/{id}")
    public ResponseEntity<TreatmentDto> getTreatmentById(@PathVariable Long id) {
        TreatmentDto treatment = treatmentService.getTreatmentById(id);
        return new ResponseEntity<>(treatment, HttpStatus.OK);
    }


    @PostMapping
    public ResponseEntity<TreatmentDto> createTreatment(@RequestBody TreatmentDto treatmentDto) {
        TreatmentDto createdTreatment = treatmentService.createTreatment(treatmentDto);
        return new ResponseEntity<>(createdTreatment, HttpStatus.CREATED);
    }


    @PutMapping("/{id}")
    public ResponseEntity<TreatmentDto> updateTreatment(@PathVariable Long id, @RequestBody TreatmentDto treatmentDto) {
        TreatmentDto updatedTreatment = treatmentService.updateTreatment(id, treatmentDto);
        return new ResponseEntity<>(updatedTreatment, HttpStatus.OK);
    }
}

