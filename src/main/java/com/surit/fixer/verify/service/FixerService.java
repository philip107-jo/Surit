package com.surit.fixer.verify.service;

import java.io.IOException;
import java.util.List;

import com.surit.common.model.dto.CommonCodeDTO;
import com.surit.fixer.verify.model.dto.FixerProfileDTO;
import com.surit.fixer.verify.model.dto.FixerVerifyRequest;

public interface FixerService {

	/** 신청 화면의 '수리 분야' 체크박스 목록 */
	List<CommonCodeDTO> getCategoryList();

	/** 신청 화면의 '활동 지역' 체크박스 목록 */
	List<CommonCodeDTO> getRegionList();

	/** 내 신청 상태 (없으면 null) */
	FixerProfileDTO getMyProfile(int userNo);

	/** 기사 인증 신청 (신규 / 재신청) */
	void applyVerify(int userNo, FixerVerifyRequest request) throws IOException;
}
