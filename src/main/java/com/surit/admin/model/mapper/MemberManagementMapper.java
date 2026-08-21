package com.surit.admin.model.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.surit.admin.model.dto.FixerProfileDTO;
import com.surit.user.dto.UserDTO;

@Mapper
public interface MemberManagementMapper {

	// 반려 -> 데이터 추가 (approval, approved_at, rejected_reason)
	int rejectFixer(FixerProfileDTO fixerProfile);
	
	// 승인 -> 데이터 변경, 추가 (approval, approved_at)
	int approveFixer(FixerProfileDTO fixerProfile);
	
	// 계정 차단 -> 데이터 변경 (account_status)
	int blockFixerAccount (UserDTO user);
}
