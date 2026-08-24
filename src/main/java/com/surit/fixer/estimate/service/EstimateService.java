package com.surit.fixer.estimate.service;

import java.util.List;

import com.surit.fixer.estimate.model.dto.EstimateDTO;
import com.surit.fixer.estimate.model.dto.EstimateForm;
import com.surit.fixer.request.model.dto.RepairRequestDTO;

public interface EstimateService {

	/** 견적 작성 화면에 띄울 접수 정보 (볼 수 없는 접수면 예외) */
	RepairRequestDTO getTargetRequest(int fixerNo, long requestId);

	/** 견적 제출 */
	void submit(int fixerNo, EstimateForm form);

	/** 내가 낸 견적 목록 */
	List<EstimateDTO> getMyEstimates(int fixerNo);
}
