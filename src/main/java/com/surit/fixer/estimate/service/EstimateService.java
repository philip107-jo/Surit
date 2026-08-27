package com.surit.fixer.estimate.service;

import java.util.List;

import com.surit.common.request.model.dto.RequestDTO;
import com.surit.fixer.estimate.model.dto.EstimateDTO;
import com.surit.fixer.estimate.model.dto.EstimateForm;

public interface EstimateService {

	/** 견적 작성 화면에 띄울 접수 정보 (볼 수 없는 접수면 예외) */
	RequestDTO getTargetRequest(Long fixerNo, Long requestId);

	/** 견적 제출 */
	void submit(Long fixerNo, EstimateForm form);

	/** 내가 낸 견적 목록 */
	List<EstimateDTO> getMyEstimates(Long fixerNo);
}
