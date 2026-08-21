package com.surit.admin.model.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class FixerProfileDTO {
	private String fixerId;
	private Long fixerNo;
	private String fixerApproval;
	private LocalDateTime fixerApprovalAt;
	private String fixerRejectReason;
	private String fixerIntro;
	private String fixerCareer;

}
