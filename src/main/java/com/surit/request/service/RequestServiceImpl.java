package com.surit.request.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.surit.common.FixerGuard;
import com.surit.common.model.dto.CommonCodeDTO;
import com.surit.common.model.mapper.CommonCodeMapper;
import com.surit.request.model.dto.RepairRequestDTO;
import com.surit.request.model.mapper.RequestMapper;

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
	public List<RepairRequestDTO> getNearbyRequests(long userNo, String categoryCode, String keyword) {

		fixerGuard.requireApprovedFixer(userNo);

		return mapper.selectNearbyRequests(userNo, trimToNull(categoryCode), trimToNull(keyword));
	}

	@Override
	@Transactional(readOnly = true)
	public RepairRequestDTO getRequestDetail(long userNo, long requestId) {

		fixerGuard.requireApprovedFixer(userNo);

		RepairRequestDTO request = mapper.selectRequestDetail(userNo, requestId);

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
}
