package com.surit.admin.model.dto;

import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class AdminLicenseDTO {

	private Long licenseId;
	private Long userNo;
	private String licenseName;
	private String uploadUrl;
	private LocalDate issuedAt;
}
