package com.surit.fixer.estimate.service;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.surit.fixer.common.FixerGuard;
import com.surit.fixer.estimate.model.dto.EstimateDTO;
import com.surit.fixer.estimate.model.dto.EstimateForm;
import com.surit.fixer.estimate.model.mapper.EstimateMapper;
import com.surit.fixer.request.model.dto.RepairRequestDTO;
import com.surit.fixer.request.model.mapper.RequestMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class EstimateServiceImpl implements EstimateService {

	/** 견적 금액 상한. 실수로 0 을 몇 개 더 붙이는 걸 막는다 */
	private static final BigDecimal MAX_PRICE = new BigDecimal("100000000");   // 1억
	private static final int        MAX_DURATION_MIN = 60 * 24 * 30;           // 30일

	private final EstimateMapper mapper;
	private final RequestMapper  requestMapper;
	private final FixerGuard     fixerGuard;


	@Override
	@Transactional(readOnly = true)
	public RepairRequestDTO getTargetRequest(int fixerNo, long requestId) {

		fixerGuard.requireApprovedFixer(fixerNo);

		RepairRequestDTO request = requestMapper.selectRequestDetail(fixerNo, requestId);

		if (request == null) {
			throw new IllegalStateException("견적을 낼 수 없는 접수입니다.");
		}
		return request;
	}


	@Override
	@Transactional(rollbackFor = Exception.class)
	public void submit(int fixerNo, EstimateForm form) {

		fixerGuard.requireApprovedFixer(fixerNo);

		validate(form);

		// 내 분야/지역이 맞는 접수인지, 차단한 고객은 아닌지 확인.
		// (열려 있는지 / 중복인지는 아래 INSERT 의 WHERE 가 다시 확인한다)
		RepairRequestDTO target = requestMapper.selectRequestDetail(fixerNo, form.getRequestId());
		if (target == null) {
			throw new IllegalStateException("견적을 낼 수 없는 접수입니다.");
		}

		EstimateDTO estimate = new EstimateDTO();
		estimate.setRequestId(form.getRequestId());
		estimate.setFixerNo(fixerNo);                       // 폼이 아니라 세션에서 온 값
		estimate.setEstimatedPrice(form.getEstimatedPrice());
		estimate.setEstimatedDuration(form.getEstimatedDuration());
		estimate.setContent(form.getContent());

		int inserted = mapper.insertEstimate(estimate);

		if (inserted == 0) {
			// WHERE 조건에 걸려서 안 들어갔다. 어느 조건인지 여기서 구분해준다.
			if (mapper.countMyEstimate(form.getRequestId(), fixerNo) > 0) {
				throw new IllegalStateException("이미 이 접수에 견적을 제출했습니다.");
			}
			throw new IllegalStateException("이미 마감된 접수입니다. 목록을 새로고침해주세요.");
		}

		// 접수대기 → 견적중. 이미 견적중이면 0건이지만 그건 정상이라 확인하지 않는다.
		mapper.updateRequestToEstimating(form.getRequestId());
	}


	@Override
	@Transactional(readOnly = true)
	public List<EstimateDTO> getMyEstimates(int fixerNo) {

		fixerGuard.requireApprovedFixer(fixerNo);

		return mapper.selectMyEstimates(fixerNo);
	}


	private void validate(EstimateForm form) {

		if (form.getRequestId() == null) {
			throw new IllegalStateException("접수 번호가 없습니다.");
		}

		BigDecimal price = form.getEstimatedPrice();
		if (price == null) {
			throw new IllegalStateException("예상 금액을 입력해주세요.");
		}
		// compareTo 로 비교한다. equals 는 100 과 100.0 을 다르다고 본다.
		if (price.compareTo(BigDecimal.ZERO) < 0) {
			throw new IllegalStateException("예상 금액은 0원 이상이어야 합니다.");
		}
		if (price.compareTo(MAX_PRICE) > 0) {
			throw new IllegalStateException("예상 금액이 너무 큽니다. 다시 확인해주세요.");
		}

		Integer duration = form.getEstimatedDuration();
		if (duration == null || duration <= 0) {
			throw new IllegalStateException("예상 소요 시간(분)을 입력해주세요.");
		}
		if (duration > MAX_DURATION_MIN) {
			throw new IllegalStateException("예상 소요 시간이 너무 깁니다. 다시 확인해주세요.");
		}

		String content = form.getContent();
		if (content == null || content.isBlank()) {
			throw new IllegalStateException("견적 설명을 입력해주세요.");
		}
		// DB 컬럼 길이를 넘으면 ORA-12899 라는 알아보기 힘든 에러가 난다
		if (content.length() > 1000) {
			throw new IllegalStateException("견적 설명은 1000자를 넘을 수 없습니다.");
		}
	}
}
