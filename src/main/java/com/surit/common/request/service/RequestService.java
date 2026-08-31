package com.surit.common.request.service;

import java.util.List;

import com.surit.common.model.dto.CommonCodeDTO;
import com.surit.common.request.model.dto.RequestDTO;
import com.surit.fixer.estimate.model.dto.EstimateDTO;
public interface RequestService {

	/** 검색 화면의 분야 셀렉트 박스 */
	List<CommonCodeDTO> getCategoryList();
	List<CommonCodeDTO> getVisitTimeList();

	/** 내 주변 새 접수 목록 */
	List<RequestDTO> getNearbyRequests(Long userNo, String categoryCode, String keyword);

	/** 접수 상세 (볼 수 없는 접수면 예외) */
	RequestDTO getRequestDetail(Long userNo, Long requestId);
	List<RequestDTO> getRequestsByUserId(Long userNo);

	 

	/**
	 * 매칭 화면용 접수 정보 조회 (내 접수가 맞는지 확인 포함)
	*/
	RequestDTO getRequestForMatching(Long userNo, Long requestId);
	 
	/** 특정 접수에 들어온 견적 목록 */
	List<EstimateDTO> getEstimatesForMatching(Long requestId);
	 
	/**
	 * 견적(기사) 선택 확정.
	 * 접수 상태를 매칭완료(REQ_03)로 바꾸고, 선택된 견적을 표시한다.
	 */
	void selectEstimate(Long userNo, Long requestId, Long estimateId);
	void createRequest(RequestDTO request);


}
