package com.example.dentistapp.Controller;

import com.example.dentistapp.Dto.DentistDto;
import com.example.dentistapp.Request.LoginRequest;
import com.example.dentistapp.Service.DentistService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

import static org.springframework.http.HttpStatus.CREATED;
import static org.springframework.http.HttpStatus.OK;

@RestController
@RequestMapping("/api/dentists")
public class DentistController {

    private final DentistService dentistService;

    public DentistController(DentistService dentistService){
        this.dentistService = dentistService;
    }

    @GetMapping
    public ResponseEntity<List<DentistDto>> getAllDentists(){
        return new  ResponseEntity<>(dentistService.getAllDentist(),OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<DentistDto> getDentistById(@PathVariable UUID id){
        return new  ResponseEntity<>(dentistService.getDentistById(id),OK);
    }

    @PostMapping
    public ResponseEntity<DentistDto> createDentist(@RequestBody DentistDto dentistDto){
        dentistService.createDentist(dentistDto);
        return new ResponseEntity<>(dentistDto,CREATED);
    }


    @PutMapping("/{id}")
    public ResponseEntity<DentistDto> updateDentist(@PathVariable UUID id, @RequestBody DentistDto dentistDto){
        return new ResponseEntity<>
                (dentistService.updateDentist(id,dentistDto),OK);
    }

    @DeleteMapping("/{id}")
    public void deleteDentist(@PathVariable UUID id){
        dentistService.deleteDentistById(id);
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
        return new ResponseEntity<>(dentistService.login(loginRequest), OK);
    }
}
