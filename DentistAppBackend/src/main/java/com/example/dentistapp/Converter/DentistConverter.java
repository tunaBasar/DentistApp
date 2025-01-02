package com.example.dentistapp.Converter;

import com.example.dentistapp.Dto.DentistDto;
import com.example.dentistapp.Model.Dentist;
import com.example.dentistapp.Model.Role;
import com.example.dentistapp.Repository.RoleRepository;
import org.springframework.stereotype.Component;

@Component
public class DentistConverter {

    private final RoleRepository roleRepository;

    public DentistConverter(RoleRepository roleRepository) {
        this.roleRepository = roleRepository;
    }

    public Dentist toEntity(DentistDto dentistDto){
        Dentist dentist=new Dentist();

        dentist.setId(dentistDto.getId());
        dentist.setFirstName(dentistDto.getFirstName());
        dentist.setLastName(dentistDto.getLastName());
        dentist.setPassword(dentistDto.getPassword());
        dentist.setSSID(dentistDto.getSSID());
        dentist.setPhoneNumber(dentistDto.getPhoneNumber());
        dentist.setSpecialization(dentistDto.getSpecialization());
        dentist.setLocation(dentistDto.getLocation());

        Role role = roleRepository.findById(dentistDto.getRoleId())
                .orElseThrow(() -> new RuntimeException("Role not found"));
        dentist.setRole(role);

        return dentist;
    }

    public DentistDto toDto(Dentist dentist){
        DentistDto dentistDto=new DentistDto();

        dentistDto.setId(dentist.getId());
        dentistDto.setFirstName(dentist.getFirstName());
        dentistDto.setLastName(dentist.getLastName());
        dentistDto.setPhoneNumber(dentist.getPhoneNumber());
        dentistDto.setSSID(dentist.getSSID());
        dentistDto.setPassword(dentist.getPassword());
        dentistDto.setRoleId(dentist.getRole().getId());
        dentistDto.setSpecialization(dentist.getSpecialization());
        dentistDto.setLocation(dentist.getLocation());

        return dentistDto;

    }
}
