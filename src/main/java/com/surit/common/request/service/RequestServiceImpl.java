package com.surit.common.request.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.surit.common.model.dto.CommonCodeDTO;
import com.surit.common.model.mapper.CommonCodeMapper;
import com.surit.common.request.model.dto.RequestDTO;
import com.surit.common.request.model.mapper.RequestMapper;
import com.surit.fixer.common.FixerGuard;
import com.surit.fixer.estimate.model.dto.EstimateDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RequestServiceImpl implements RequestService {

	private final RequestMapper    mapper;
	private final CommonCodeMapper codeMapper;
	private final FixerGuard       fixerGuard;

	@Override
	public List<CommonCodeDTO> getCategoryList() {
		return codeMapper.selectByGroup("CATEGORY");
	}
	@Override
	public List<CommonCodeDTO> getVisitTimeList() {
	    return codeMapper.selectByGroup("VISIT_TIME");
	    
	}

	@Override
	@Transactional(readOnly = true)   // 조회만 하니까 readOnly. 커밋 처리를 안 해서 조금 가볍다
	public List<RequestDTO> getNearbyRequests(Long userNo, String categoryCode, String keyword) {

		fixerGuard.requireApprovedFixer(userNo);
		return mapper.selectNearbyRequests(userNo, trimToNull(categoryCode), trimToNull(keyword));
	}

	@Override
	@Transactional(readOnly = true)
	public RequestDTO getRequestDetail(Long userNo, Long requestId) {

		fixerGuard.requireApprovedFixer(userNo);

		RequestDTO request = mapper.selectRequestDetail(userNo, requestId);
		if (request == null) {
			// 없는 번호이거나, 내 분야/지역이 아니거나, 이미 매칭이 끝난 접수.
			// 어느 쪽인지 굳이 알려주지 않는다. 알려주면 번호를 하나씩 넣어보며
			// "이 번호는 존재하는구나" 를 알아낼 수 있다.
			throw new IllegalStateException("볼 수 없는 접수입니다.");
		}

		request.setPhotos(mapper.selectPhotos(requestId));
		return request;
	}

	/** 고객 기능 — 내가 올린 접수 목록 */
	@Override
	@Transactional(readOnly = true)
	public List<RequestDTO> getRequestsByUserId(Long userNo) {
		return mapper.findByUserId(userNo);
	}

	/** 빈 문자열은 null 로 (XML 의 <if> 조건을 단순하게 유지하려고) */
	private String trimToNull(String s) {
		if (s == null || s.isBlank()) {
			return null;
		}
		return s.trim();
	}
	




@Override
@Transactional(readOnly = true)
public RequestDTO getRequestForMatching(Long userNo, Long requestId) {
 
    RequestDTO request = mapper.selectRequestForCustomer(userNo, requestId);
 
    if (request == null) {
        // 없는 접수이거나 내 접수가 아님. 이유는 구분해서 알려주지 않는다.
        throw new IllegalStateException("볼 수 없는 접수입니다.");
    }
 
    return request;
}
 
@Override
@Transactional(readOnly = true)
public List<EstimateDTO> getEstimatesForMatching(Long requestId) {
    return mapper.selectEstimatesByRequestId(requestId);
}
 
@Override
@Transactional
public void selectEstimate(Long userNo, Long requestId, Long estimateId) {
 
    // 1. 내 접수가 맞는지 다시 한 번 확인 (URL 조작 방지)
	RequestDTO request = mapper.selectRequestForCustomer(userNo, requestId);
	if (request == null) {
	    throw new IllegalStateException("볼 수 없는 접수입니다.");
	}
	mapper.updateRequestStatus(requestId, "REQ_03");   // 여기까진 실행 안 됐을 수도 있고
	mapper.updateSelectedEstimate(requestId, estimateId);   // 이건 실행됐음 (선택됨 뱃지로 확인됨)
}
 
	@Transactional
	public void createRequest(RequestDTO request) {

	    // 신규 접수 상태
	    request.setStatusCode("REQ_01");

	    System.out.println("===== 접수 INSERT =====");
	    System.out.println("userNo = " + request.getUserNo());
	    System.out.println("categoryCode = " + request.getCategoryCode());
	    System.out.println("title = " + request.getTitle());
	    System.out.println("content = " + request.getContent());
	    System.out.println("serviceAddress = " + request.getServiceAddress());
	    System.out.println("statusCode = " + request.getStatusCode());

	    Long result = mapper.insertRequest(request);

	    System.out.println("INSERT RESULT = " + result);

	    if (result != 1) {
	        throw new IllegalStateException("수리 접수 등록에 실패했습니다.");
	    }
	}
	@Override
	@Transactional(readOnly = true)
	public RequestDTO getRequestDetailForCustomer(Long userNo, Long requestId) {
	 
	    RequestDTO request = mapper.selectRequestForCustomer(userNo, requestId);
	 
	    if (request == null) {
	        throw new IllegalStateException("볼 수 없는 접수입니다.");
	    }
	 
	    return request;
	}
	 
	@Override
	@Transactional(readOnly = true)
	public EstimateDTO getSelectedEstimate(Long requestId) {
	    return mapper.selectSelectedEstimateByRequestId(requestId);
	}
	 
	@Override
	@Transactional
	public void cancelRequest(Long userNo, Long requestId) {
	 
	    // 내 접수가 맞는지 확인 (URL 조작 방지)
	    RequestDTO request = mapper.selectRequestForCustomer(userNo, requestId);
	    if (request == null) {
	        throw new IllegalStateException("볼 수 없는 접수입니다.");
	    }
	 
	    mapper.updateRequestStatus(requestId, "REQ_05");
	}
	 
}