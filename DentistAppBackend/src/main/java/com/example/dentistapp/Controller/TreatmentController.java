package com.example.dentistapp.Controller;

import com.example.dentistapp.Dto.TreatmentDto;
import com.example.dentistapp.Service.TreatmentService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/treatment")
public class TreatmentController {
    private final TreatmentService treatmentService;

    public TreatmentController(TreatmentService treatmentService) {
        this.treatmentService = treatmentService;
    }

    @GetMapping
    public ResponseEntity<List<TreatmentDto>> getAllTreatments() {
        return new ResponseEntity<>
                (treatmentService.getAllTreatments(), HttpStatus.OK);
    }
    @GetMapping("/{id}")
    public ResponseEntity<TreatmentDto> getTreatmentById(@PathVariable UUID id) {

        return new ResponseEntity<>
                (treatmentService.getTreatmentById(id), HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<TreatmentDto>createTreatment(@RequestBody TreatmentDto treatmentDto) {
        return new ResponseEntity<>
                (treatmentService.createTreatment(treatmentDto), HttpStatus.CREATED);
    }
    @PostMapping("/{id}")
    public ResponseEntity<TreatmentDto>updateTreatment(@PathVariable UUID id, @RequestBody TreatmentDto treatmentDto) {
        return new ResponseEntity<>
                (treatmentService.updateTreatment(treatmentDto, id), HttpStatus.OK);
    }
    @DeleteMapping("/{id}")
    public void deleteTreatment(@PathVariable UUID id) {
        treatmentService.deleteTreatment(id);
    }
}
