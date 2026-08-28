package com.surit.common.request.service;

import java.util.List;

import com.surit.common.model.dto.CommonCodeDTO;
import com.surit.common.request.model.dto.RequestDTO;
public interface RequestService {

	/** 검색 화면의 분야 셀렉트 박스 */
	List<CommonCodeDTO> getCategoryList();

	/** 내 주변 새 접수 목록 */
	List<RequestDTO> getNearbyRequests(Long userNo, String categoryCode, String keyword);

	/** 접수 상세 (볼 수 없는 접수면 예외) */
	RequestDTO getRequestDetail(Long userNo, Long requestId);
	List<RequestDTO> getRequestsByUserId(Long userNo);

	void createRequest(RequestDTO request);
	 



}
