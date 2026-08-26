package com.surit.fixer.common;

import org.springframework.stereotype.Component;

import com.surit.fixer.verify.model.dto.FixerProfileDTO;
import com.surit.fixer.verify.model.mapper.FixerMapper;

import lombok.RequiredArgsConstructor;

/**
 * 기사 자격 검사를 한 곳에서 담당한다.
 * F-15 · F-16 · F-17 이 모두 이 검사를 필요로 하는데,
 * 각자 복사해두면 규칙이 바뀔 때 한 곳을 빠뜨리기 쉽다.
 */
@Component
@RequiredArgsConstructor
public class FixerGuard {

	public static final String PENDING  = "PENDING";   // 심사 대기
	public static final String APPROVED = "APPROVED";  // 승인 완료 — 이 값만 통과
	public static final String REJECTED = "REJECTED";  // 거절 (재신청 가능)

	private final FixerMapper fixerMapper;

	/**
	 * 승인된 기사가 아니면 예외를 던진다.
	 * 통과하면 아무것도 반환하지 않는다 — 조용히 끝나는 게 곧 "통과" 다.
	 *
	 * userNo 를 Long 이 아니라 long 으로 받는 이유 (팀 숫자 타입 규칙) :
	 *   이 값은 항상 로그인 세션에서 오므로 null 일 수가 없다.
	 *   원시형으로 두면 그 사실이 타입으로 보장되고, null 이 넘어와
	 *   언박싱에서 NullPointerException 이 나는 경로 자체가 막힌다.
	 *   (DTO 필드는 반대로 Long — DB 의 NULL 을 0 과 구분해야 하므로)
	 */
	public void requireApprovedFixer(long userNo) {

		FixerProfileDTO profile = fixerMapper.selectFixerProfile(userNo);

		if (profile == null) {
			throw new IllegalStateException("기사 인증 신청을 먼저 해주세요.");
		}
		if (!APPROVED.equals(profile.getApprovalStatus())) {
			throw new IllegalStateException(
					"기사 인증이 완료된 후 이용할 수 있습니다. (현재 상태: "
					+ profile.getApprovalStatus() + ")");
		}

		// 정지(SANCTION) 검사 같은 게 생기면 여기 한 줄만 추가하면
		// 세 기능에 동시에 적용된다
	}
}
