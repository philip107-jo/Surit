package com.surit.common.request.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.surit.common.model.dto.CommonCodeDTO;
import com.surit.common.model.mapper.CommonCodeMapper;
import com.surit.common.request.model.dto.RequestDTO;
import com.surit.common.request.model.mapper.RequestMapper;
import com.surit.fixer.common.FixerGuard;

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
	@Transactional(readOnly = true)   // 조회만 하니까 readOnly. 커밋 처리를 안 해서 조금 가볍다
<<<<<<< HEAD:src/main/java/com/surit/fixer/request/service/RequestServiceImpl.java
	public List<RepairRequestDTO> getNearbyRequests(long userNo, String categoryCode, String keyword) {
=======
	public List<RequestDTO> getNearbyRequests(Long userNo, String categoryCode, String keyword) {
>>>>>>> 718f7fe4d56ce2dc5f6840629fa877ded9b6d8e5:src/main/java/com/surit/common/request/service/RequestServiceImpl.java

		fixerGuard.requireApprovedFixer(userNo);

		return mapper.selectNearbyRequests(userNo, trimToNull(categoryCode), trimToNull(keyword));
	}

	@Override
	@Transactional(readOnly = true)
<<<<<<< HEAD:src/main/java/com/surit/fixer/request/service/RequestServiceImpl.java
	public RepairRequestDTO getRequestDetail(long userNo, long requestId) {
=======
	public RequestDTO getRequestDetail(Long userNo, Long requestId) {
>>>>>>> 718f7fe4d56ce2dc5f6840629fa877ded9b6d8e5:src/main/java/com/surit/common/request/service/RequestServiceImpl.java

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

	/** 빈 문자열은 null 로 (XML 의 <if> 조건을 단순하게 유지하려고) */
	private String trimToNull(String s) {
		if (s == null || s.isBlank()) {
			return null;
		}
		return s.trim();
	}
	// ==========================================================
	// [2] 파일: com.surit.common.request.service.RequestServiceImpl (구현체)
	// 클래스 내부에 아래 메서드 추가 (기존에 requestMapper 필드가 이미 주입되어 있다는 전제)
	// ==========================================================
	 
	@Override
	public List<RequestDTO> getRequestsByUserId(Long userNo) {
	    return mapper.findByUserId(userNo);
	}
}