package com.example.dentistapp.Component;

import com.example.dentistapp.Model.Admin;
import com.example.dentistapp.Model.Role;
import com.example.dentistapp.Model.Treatment;
import com.example.dentistapp.Enum.TreatmentStatus;
import com.example.dentistapp.Repository.AdminRepository;
import com.example.dentistapp.Repository.RoleRepository;
import com.example.dentistapp.Repository.TreatmentRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

@Component
public class DataLoader implements CommandLineRunner {

    private final RoleRepository roleRepository;
    private final AdminRepository adminRepository;
    private final TreatmentRepository treatmentRepository;

    public DataLoader(RoleRepository roleRepository, AdminRepository adminRepository, TreatmentRepository treatmentRepository) {
        this.roleRepository = roleRepository;
        this.adminRepository = adminRepository;
        this.treatmentRepository = treatmentRepository;
    }

    @Override
    public void run(String... args) throws Exception {
        // Rol verilerini kontrol et ve ekle
        if (!roleRepository.existsByRoleName("admin")) {
            roleRepository.save(new Role("admin"));
        }
        if (!roleRepository.existsByRoleName("dentist")) {
            roleRepository.save(new Role("dentist"));
        }
        if (!roleRepository.existsByRoleName("patient")) {
            roleRepository.save(new Role("patient"));
        }

        // Admin verilerini kontrol et ve ekle
        if (adminRepository.count() == 0) {
            Admin admin = new Admin();
            Admin admin2 = new Admin();
            admin.setFirstName("Ibrahim");
            admin.setLastName("Bakir");
            admin.setRole(roleRepository.getById(1));
            admin.setPassword("123456");
            admin.setSSID("654321");

            admin2.setFirstName("Tuna");
            admin2.setLastName("Basar");
            admin2.setRole(roleRepository.getById(1));
            admin2.setPassword("3579");
            admin2.setSSID("53134159168");

            adminRepository.save(admin);
            adminRepository.save(admin2);
        }

        // Tedavi verilerini kontrol et ve ekle
        if (treatmentRepository.count() == 0) {
            Treatment treatment1 = new Treatment();
            treatment1.setTreatmentName("Root Canal Treatment");
            treatment1.setTreatmentDescription("A procedure to save a severely decayed or infected tooth.");
            treatment1.setTreatmentDate(LocalDate.of(2024, 12, 30));
            treatment1.setTreatmentStatus(TreatmentStatus.NOTHING);

            Treatment treatment2 = new Treatment();
            treatment2.setTreatmentName("Teeth Whitening");
            treatment2.setTreatmentDescription("A cosmetic procedure to lighten the color of teeth.");
            treatment2.setTreatmentDate(LocalDate.of(2025, 1, 10));
            treatment2.setTreatmentStatus(TreatmentStatus.NOTHING);

            Treatment treatment3 = new Treatment();
            treatment3.setTreatmentName("Dental Implant");
            treatment3.setTreatmentDescription("A surgical procedure to replace a missing tooth with an artificial one.");
            treatment3.setTreatmentDate(LocalDate.of(2025, 2, 15));
            treatment3.setTreatmentStatus(TreatmentStatus.NOTHING);

            treatmentRepository.save(treatment1);
            treatmentRepository.save(treatment2);
            treatmentRepository.save(treatment3);
        }
    }
}
