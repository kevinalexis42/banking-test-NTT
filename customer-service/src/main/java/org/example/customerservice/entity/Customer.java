package org.example.customerservice.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.time.LocalDateTime;

/**
 * Customer entity that references Person.
 * Customer has a foreign key relationship with Person (person_id).
 * Person fields are accessed via JOIN queries.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table("customers")
public class Customer {
    
    @Id
    private Long id;
    
    // Foreign key to Person
    @Column("person_id")
    private Long personId;
    
    // Customer specific fields
    @Column("password")
    private String password;
    
    @Column("status")
    private Boolean status;
    
    @Column("created_at")
    private LocalDateTime createdAt;
    
    @Column("updated_at")
    private LocalDateTime updatedAt;
}

