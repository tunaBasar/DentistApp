package com.example.dentistapp.Model;

import jakarta.persistence.*;
import lombok.Getter;


@Entity
@Getter
public class Role {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(unique = true, nullable = false)
    private int id;
    private String roleName;

    public Role(String roleName) {
        this.roleName = roleName;
    }

    public Role() {

    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

}
