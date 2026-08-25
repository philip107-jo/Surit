package com.surit.fixer.verify.model.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * FIXER_PROFILE 한 행.
 * PK 가 USER_NO 라서 USERS 와 1:1 이다. (한 사람당 기사 프로필 하나)
 */
@Getter @Setter @NoArgsConstructor @ToString
public class FixerProfileDTO {

	private Integer userNo;          // USER_NO (PK, USERS 참조)
	private String  intro;           // INTRO
	private Integer careerYears;     // CAREER_YEARS (숫자! 예전엔 문자열이었음)
	private String  approvalStatus;  // PENDING / APPROVED / REJECTED
	private String  photoUrl;        // FIXER_PHOTO_URL (고객 확인용 사진, 파일 경로)
}