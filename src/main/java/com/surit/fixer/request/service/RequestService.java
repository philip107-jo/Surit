package com.surit.fixer.request.service;

import java.util.List;

import com.surit.fixer.common.model.dto.CommonCodeDTO;
import com.surit.fixer.request.model.dto.RepairRequestDTO;

public interface RequestService {

	/** 검색 화면의 분야 셀렉트 박스 */
	List<CommonCodeDTO> getCategoryList();

	/** 내 주변 새 접수 목록 */
	List<RepairRequestDTO> getNearbyRequests(int userNo, String categoryCode, String keyword);

	/** 접수 상세 (볼 수 없는 접수면 예외) */
	RepairRequestDTO getRequestDetail(int userNo, long requestId);
}
