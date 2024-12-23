package com.example.dentistapp.Component;

import com.example.dentistapp.Model.Admin;
import com.example.dentistapp.Model.Role;
import com.example.dentistapp.Repository.AdminRepository;
import com.example.dentistapp.Repository.RoleRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class DataLoader implements CommandLineRunner {

    private final RoleRepository roleRepository;
    private final AdminRepository adminRepository;

    public DataLoader(RoleRepository roleRepository, AdminRepository adminRepository) {
        this.roleRepository = roleRepository;
        this.adminRepository = adminRepository;
    }

    @Override
    public void run(String... args) throws Exception {
        // Eğer 'admin', 'dentist' veya 'user' role'ları yoksa ekleyin
        if (!roleRepository.existsByRoleName("admin")) {
            roleRepository.save(new Role("admin"));
        }
        if (!roleRepository.existsByRoleName("dentist")) {
            roleRepository.save(new Role("dentist"));
        }
        if (!roleRepository.existsByRoleName("patient")) {
            roleRepository.save(new Role("patient"));
        }

       if (adminRepository.count()==0){
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
    }
}
