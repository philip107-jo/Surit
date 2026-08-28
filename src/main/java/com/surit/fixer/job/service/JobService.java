package com.surit.fixer.job.service;

import java.util.List;

import com.surit.fixer.job.model.dto.JobDTO;

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
public interface JobService {

	List<JobDTO> getMyJobs(Long fixerNo, String statusCode);

	/** 내 작업 상세 (내 작업이 아니면 예외) */
	JobDTO getMyJob(Long fixerNo, Long requestId);

	/** 수리 완료 처리 */
	void complete(Long fixerNo, Long requestId);

}
