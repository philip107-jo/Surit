package com.surit.fixer.job.service;

import java.util.List;

import com.surit.fixer.job.model.dto.JobDTO;

public interface JobService {

	/** 내 작업 목록 (statusCode 가 null 이면 전체) */
	List<JobDTO> getMyJobs(Long fixerNo, String statusCode);

	/** 내 작업 상세 (내 작업이 아니면 예외) */
	JobDTO getMyJob(Long fixerNo, Long requestId);

	/** 수리 완료 처리 */
	void complete(Long fixerNo, Long requestId);
}
