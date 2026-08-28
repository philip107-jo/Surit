package com.surit.fixer.verify.service;

import java.io.IOException;
import java.util.List;

import com.surit.common.model.dto.CommonCodeDTO;
import com.surit.fixer.verify.model.dto.FixerProfileDTO;
import com.surit.fixer.verify.model.dto.FixerVerifyRequest;

/*
 * ─── 숫자 타입 규칙 (팀 합의) ────────────────────────────────
 *  · DTO 필드      : Long  (참조형)
 *      값이 없는 상태를 null 로 표현해야 하기 때문.
 *      원시형으로 바꾸면 DB 의 NULL 이 0 으로 들어와서
 *      "값 없음" 과 "0" 을 구분할 수 없게 된다.
 *
 *  · 메서드 파라미터 : long  (원시형)
 *      여기 들어오는 번호는 항상 세션이나 URL 에서 오는 값이라
 *      null 일 수가 없다. 원시형으로 두면 그 사실이 타입으로 보장되고,
 *      null 이 넘어와 언박싱에서 NPE 가 나는 경로 자체가 막힌다.
 *      또한 UserDTO.getUserNo() 가 int 라서 int → long 확대변환으로
 *      그대로 넘길 수 있다. (자바는 int → Long 은 자동변환하지 않는다)
 * ────────────────────────────────────────────────────────────
 */
public interface FixerService {

	/** 신청 화면의 '수리 분야' 체크박스 목록 */
	List<CommonCodeDTO> getCategoryList();

	/** 신청 화면의 '활동 지역' 체크박스 목록 */
	List<CommonCodeDTO> getRegionList();

	/** 내 신청 상태 (없으면 null) */

	FixerProfileDTO getMyProfile(Long userNo);

	/** 기사 인증 신청 (신규 / 재신청) */
	void applyVerify(Long userNo, FixerVerifyRequest request) throws IOException;
}

