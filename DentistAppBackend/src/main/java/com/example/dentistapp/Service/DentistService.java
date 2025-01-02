package com.example.dentistapp.Service;

import com.example.dentistapp.Converter.*;
import com.example.dentistapp.Dto.DentistDto;
import com.example.dentistapp.Dto.PatientDto;
import com.example.dentistapp.Model.Dentist;
import com.example.dentistapp.Model.Patient;
import com.example.dentistapp.Repository.DentistRepository;
import com.example.dentistapp.Request.LoginRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class DentistService {

    private final DentistRepository dentistRepository;
    private final DentistConverter dentistConverter;


    public DentistService (DentistRepository dentistRepository, DentistConverter dentistConverter){
        this.dentistRepository = dentistRepository;
        this.dentistConverter = dentistConverter;

    }

    public List<DentistDto> searchDentists(String specialization, String location) {
        List<Dentist> dentists= dentistRepository.findBySpecializationAndLocation(specialization, location);
        return dentists.stream()
                .map(dentistConverter::toDto)
                .collect(Collectors.toList());
    }

    public List<DentistDto> getAllDentist(){
        List<Dentist> dentists = dentistRepository.findAll();
        return dentists.stream()
                .map(dentistConverter::toDto)
                .collect(Collectors.toList());
    }

    public DentistDto getDentistById(UUID id){
        Dentist dentist = dentistRepository.findById(id).orElseThrow(
                () -> new RuntimeException("Dentist not found"));
        return dentistConverter.toDto(dentist);
    }

    public DentistDto createDentist(DentistDto dentistDto){
        Dentist dentist = dentistRepository.save(
                dentistConverter.toEntity(dentistDto));
        return dentistConverter.toDto(dentist);
    }

    public void deleteDentistById(UUID id){
        dentistRepository.deleteById(id);
    }

    public DentistDto updateDentist(UUID id, DentistDto dentistDto){
        Dentist oldDentist= dentistConverter.
                toEntity(getDentistById(id));

        oldDentist.setFirstName(dentistDto.getFirstName());
        oldDentist.setLastName(dentistDto.getLastName());
        oldDentist.setPhoneNumber(dentistDto.getPhoneNumber());
        oldDentist.setPassword(dentistDto.getPassword());
        oldDentist.setSSID(dentistDto.getSSID());
        oldDentist.setRole(dentistConverter.toEntity(dentistDto).getRole());

        return dentistConverter.toDto
                (dentistRepository.save(oldDentist));// önce dentist olan oldDentisti
                                                     // saveledik daha sonra dto ya çevirip döndürdük
    }
    public ResponseEntity<?> login(LoginRequest loginRequest) {
        Dentist dentist =dentistRepository.findDentistBySSID(loginRequest.getSSID());
        if (dentist == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid SSID or Password");
        }
        DentistDto dentistDto= dentistConverter.toDto(dentist);

        if (dentistDto.getPassword().equals(loginRequest.getPassword())) {
            return ResponseEntity.ok("Login successful");
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid SSID or Password");
        }

    }
}
