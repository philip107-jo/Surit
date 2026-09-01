package com.surit.common.request.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.surit.common.model.dto.CommonCodeDTO;
import com.surit.common.model.mapper.CommonCodeMapper;
import com.surit.common.request.model.dto.RequestDTO;
import com.surit.common.request.model.mapper.EstimateSelectMapper;
import com.surit.common.request.model.mapper.RequestMapper;
import com.surit.fixer.common.FixerGuard;
import com.surit.fixer.estimate.model.dto.EstimateDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RequestServiceImpl implements RequestService {

	private final RequestMapper        mapper;
	private final CommonCodeMapper     codeMapper;
	private final FixerGuard           fixerGuard;

	/** 견적 수락 전용 Mapper (2026-08-31 추가) */
	private final EstimateSelectMapper selectMapper;


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

	/**
	 * 고객 기능 — 내가 올린 접수 목록
	 *
	 * ★ 머지할 때마다 두 벌이 생기려고 하는 메서드다.
	 *   같은 이름·같은 파라미터가 클래스에 두 개면 컴파일이 안 된다.
	 *   readOnly 트랜잭션이 붙은 이 한 벌만 남긴다.
	 */
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


	/* ══════════════════════════════════════════════════════
	   기사 매칭 (고객이 견적을 고르는 화면)

	   ★ 이 세 메서드도 머지 때 옛날 버전이 통째로 다시 붙는다.
	     옛 selectEstimate 는 updateSelectedEstimate 만 부르고
	     ESTIMATES.STATUS 를 'SELECTED' 로 안 바꾼다.
	     그러면 화면엔 "선택됨" 뱃지가 떠도 채팅방이 안 열린다.
	     (selectRoomSeedByRequest 가 STATUS='SELECTED' 인 기사를 찾기 때문)
	     아래 4단계 버전이 최신이다.
	   ══════════════════════════════════════════════════════ */

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

	/**
	 * 견적(기사) 선택 확정.  2026-08-31 재작성
	 *
	 * ★ 반드시 한 트랜잭션이어야 한다.
	 *   중간에 끊기면 "기사는 SELECTED 인데 접수는 아직 REQ_02" 같은 상태가 남고,
	 *   그러면 마이페이지에 채팅 버튼이 안 뜨거나 채팅방이 안 열린다.
	 *   여기서 던지는 IllegalStateException 은 RuntimeException 이라
	 *   스프링이 알아서 전부 되돌린다(rollback).
	 *
	 * 순서
	 *   1. 내 접수가 맞는지 확인
	 *   2. 고른 견적 → SELECTED      (이게 있어야 채팅방이 생긴다)
	 *   3. 나머지 견적 → REJECTED
	 *   4. 접수 → REQ_03(매칭완료)
	 */
	@Override
	@Transactional
	public void selectEstimate(Long userNo, Long requestId, Long estimateId) {

		// 1. 내 접수가 맞는지 확인 (주소창·폼 조작 방지)
		if (mapper.selectRequestForCustomer(userNo, requestId) == null) {
			throw new IllegalStateException("볼 수 없는 접수입니다.");
		}

		// 2. 고른 견적을 SELECTED 로.
		//    쿼리에 REQUEST_ID 와 STATUS='PENDING' 조건이 걸려 있어서,
		//    남의 견적 번호를 넣었거나 이미 처리된 견적이면 0건이 된다.
		if (selectMapper.markEstimateSelected(requestId, estimateId) != 1) {
			throw new IllegalStateException("이미 처리되었거나 선택할 수 없는 견적입니다.");
		}

		// 3. 나머지 견적은 REJECTED.
		//    견적이 하나뿐이면 0건인데, 그건 실패가 아니라 정상이다.
		selectMapper.rejectOtherEstimates(requestId, estimateId);

		// 4. 접수를 매칭완료(REQ_03)로.
		//    0건이면 그 사이 누군가 상태를 바꾼 것이므로 2·3번까지 전부 되돌린다.
		if (selectMapper.updateRequestToMatched(userNo, requestId) != 1) {
			throw new IllegalStateException("이미 기사님이 정해진 접수입니다.");
		}
	}

	@Override

	@Transactional
	public void createRequest(RequestDTO request) {

		// 신규 접수 상태
		request.setStatusCode("REQ_01");

		Long result = mapper.insertRequest(request);

		if (result == null || result != 1) {
			throw new IllegalStateException("수리 접수 등록에 실패했습니다.");
		}
	}


	/* ══════════════════════════════════════════════════════
	   고객 접수 상세 · 취소  (develop 브랜치에서 들어온 기능)
	   ══════════════════════════════════════════════════════ */

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
