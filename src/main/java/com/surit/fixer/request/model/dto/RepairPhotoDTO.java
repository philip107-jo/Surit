package com.surit.fixer.request.model.dto;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** REPAIR_PHOTO 한 줄 (고객이 올린 고장 사진) */
@Getter
@Setter
@NoArgsConstructor
public class RepairPhotoDTO {

	private Long      photoId;
	private Long      requestId;
	private String    photoPath;
	private String    photoType;
	private Integer   photoOrder;
	private Timestamp createdAt;
}
