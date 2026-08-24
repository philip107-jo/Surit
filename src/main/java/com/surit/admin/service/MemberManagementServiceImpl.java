package com.surit.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.surit.admin.model.dto.AdminFixerDetailDTO;
import com.surit.admin.model.dto.AdminMemberListDTO;
import com.surit.admin.model.dto.MemberSearchCondition;
import com.surit.admin.model.mapper.MemberManagementMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MemberManagementServiceImpl implements MemberManagementService {

	private final MemberManagementMapper memberMapper;

	@Override
	@Transactional(readOnly = true)
	public List<AdminMemberListDTO> getPendingFixers() {
		return memberMapper.selectPendingFixers();
	}

	@Override
	@Transactional(readOnly = true)
	public List<AdminMemberListDTO> getMemberList(MemberSearchCondition cond) {
		cond.setOffset((cond.getPage() - 1) * cond.getSize());
		return memberMapper.selectMemberList(cond);
	}

	@Override
	@Transactional(readOnly = true)
	public int getMemberCount(MemberSearchCondition cond) {
		return memberMapper.selectMemberCount(cond);
	}

	@Override
	@Transactional(readOnly = true)
	public AdminFixerDetailDTO getFixerDetail(Long userNo) {

		// 1) 꺼낸다
		AdminFixerDetailDTO fixer = memberMapper.selectFixerDetail(userNo);

		// 2) 확인한다
		if (fixer == null) {
			throw new IllegalArgumentException("존재하지 않는 회원입니다");
		}

		// 3) 기사면 1:N 정보를 채운다
		if ("FIXER".equals(fixer.getUserRole())) {
			fixer.setLicenses(memberMapper.selectLicenses(userNo));
			fixer.setCategories(memberMapper.selectCategories(userNo));
			fixer.setRegions(memberMapper.selectRegions(userNo));
		}
		return fixer;
	}

	@Override
	@Transactional
	public void approveFixer(Long userNo, Long adminNo) {

		// 1) 꺼낸다
		AdminFixerDetailDTO fixer = memberMapper.selectFixerDetail(userNo);

		// 2) 확인한다
		if (fixer == null) {
			throw new IllegalArgumentException("존재하지 않는 회원입니다");
		}
		if (!"FIXER".equals(fixer.getUserRole())) {
			throw new IllegalStateException("기사 계정이 아닙니다");
		}
		if ("APPROVED".equals(fixer.getApprovalStatus())) {
			throw new IllegalStateException("이미 승인된 기사입니다");
		}
		if (memberMapper.selectLicenses(userNo).isEmpty()) {
			throw new IllegalStateException("제출된 자격증이 없습니다");
		}

		// 3~4) 바꾸고 저장한다
		memberMapper.updateApprove(userNo);

		// 5) 남긴다 (TODO: AdminLogMapper)
	}

	@Override
	@Transactional
	public void rejectFixer(Long userNo, Long adminNo, String reason) {

		// 1) 꺼낸다
		AdminFixerDetailDTO fixer = memberMapper.selectFixerDetail(userNo);

		// 2) 확인한다
		if (fixer == null) {
			throw new IllegalArgumentException("존재하지 않는 회원입니다");
		}
		if (reason == null || reason.isBlank()) {
			throw new IllegalArgumentException("반려 사유를 입력해 주세요");
		}
		if ("APPROVED".equals(fixer.getApprovalStatus())) {
			throw new IllegalStateException("이미 승인된 기사는 반려할 수 없습니다");
		}

		// 3~4) 바꾸고 저장한다
		memberMapper.updateReject(userNo, reason);

		// 5) 남긴다 (TODO: AdminLogMapper)
	}
}