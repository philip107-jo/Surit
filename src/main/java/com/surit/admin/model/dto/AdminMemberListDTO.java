package com.surit.admin.model.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class AdminMemberListDTO {
	private Long userNo;
	private String userId;
	private String name;
	private String userRole;
	private String status;
	private LocalDateTime createdAt;
	
	private String approvalStatus;
	private Double avgScore;	//review 계산값 1
	private Integer reviewCount; // review 계산값 2
}
