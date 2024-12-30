package com.example.dentistapp.Service;

import com.example.dentistapp.Converter.Converter;
import com.example.dentistapp.Dto.DentistDto;
import com.example.dentistapp.Model.Dentist;
import com.example.dentistapp.Repository.DentistRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class DentistService {

    private final DentistRepository dentistRepository;
    private final Converter converter;

    public DentistService (DentistRepository dentistRepository,Converter converter){
        this.dentistRepository = dentistRepository;
        this.converter = converter;
    }

    public List<DentistDto> searchDentists(String specialization, String location) {
        List<Dentist> dentists= dentistRepository.findBySpecializationAndLocation(specialization, location);
        return dentists.stream()
                .map(converter::dentistConvertToDto)
                .collect(Collectors.toList());
    }

    public List<DentistDto> getAllDentist(){
        List<Dentist> dentists = dentistRepository.findAll();
        return dentists.stream()
                .map(converter::dentistConvertToDto)
                .collect(Collectors.toList());
    }

    public DentistDto getDentistById(UUID id){
        Dentist dentist = dentistRepository.findById(id).orElseThrow(
                () -> new RuntimeException("Dentist not found"));
        return converter.dentistConvertToDto(dentist);
    }

    public DentistDto createDentist(DentistDto dentistDto){
        Dentist dentist = dentistRepository.save(
                converter.dentistConvertFromDto(dentistDto));
        return converter.dentistConvertToDto(dentist);
    }

    public void deleteDentistById(UUID id){
        dentistRepository.deleteById(id);
    }

    public DentistDto updateDentist(UUID id, DentistDto dentistDto){
        Dentist oldDentist= converter.
                dentistConvertFromDto(getDentistById(id));

        oldDentist.setFirstName(dentistDto.getFirstName());
        oldDentist.setLastName(dentistDto.getLastName());
        oldDentist.setPhoneNumber(dentistDto.getPhoneNumber());
        oldDentist.setPassword(dentistDto.getPassword());
        oldDentist.setSSID(dentistDto.getSSID());
        oldDentist.setRole(converter.dentistConvertFromDto(dentistDto).getRole());

        return converter.dentistConvertToDto
                (dentistRepository.save(oldDentist));// önce dentist olan oldDentisti
                                                     // saveledik daha sonra dto ya çevirip döndürdük
    }
}
