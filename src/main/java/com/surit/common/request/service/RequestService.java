package com.surit.common.request.service;

import java.util.List;

import com.surit.common.model.dto.CommonCodeDTO;
import com.surit.common.request.model.dto.RequestDTO;
/*
 * ─── 숫자 타입 규칙 ──────────────────────────────────────────
 *  · DTO 필드 : Long (참조형)
 *      DB 의 NULL 을 null 로 받아야 "값 없음" 과 "0" 이 구분된다.
 *
 *  · 메서드 파라미터 : long (원시형)
 *      여기 들어오는 번호는 세션이나 URL 에서 오는 값이라 null 일 수 없다.
 *      원시형으로 두면 그 사실이 타입으로 보장되고, 서비스 안에서
 *      실수로 null 검사를 빠뜨릴 여지가 사라진다.
 *      호출부에서 UserDTO.getUserNo() (Long) 가 언박싱되어 전달된다.
 * ────────────────────────────────────────────────────────────
 */
public interface RequestService {

	/** 검색 화면의 분야 셀렉트 박스 */
	List<CommonCodeDTO> getCategoryList();

	/** 내 주변 새 접수 목록 */
	List<RequestDTO> getNearbyRequests(long userNo, String categoryCode, String keyword);

	/** 접수 상세 (볼 수 없는 접수면 예외) */
	RequestDTO getRequestDetail(long userNo, long requestId);

	/** 고객 기능 — 내가 올린 접수 목록 */
	List<RequestDTO> getRequestsByUserId(long userNo);
	
	/** 고객 기능 — 접수 등록 */
	void createRequest(RequestDTO request);
}