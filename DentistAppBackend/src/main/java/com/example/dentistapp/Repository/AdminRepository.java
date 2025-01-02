package com.example.dentistapp.Repository;

import com.example.dentistapp.Model.Admin;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface AdminRepository extends JpaRepository<Admin, UUID> {


}
