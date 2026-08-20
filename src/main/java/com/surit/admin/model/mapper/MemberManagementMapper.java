package com.surit.admin.model.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.surit.admin.model.dto.FixerProfileDTO;

@Mapper
public interface MemberManagementMapper {

	// 반려 -> 데이터 추가 (approval, approved_at, rejected_reason)
	
	
	// 승인 -> 데이터 변경, 추가 (approval, approved_at)
	int approveFixer(FixerProfileDTO fixerProfile);
	
	// 계정 차단 -> 데이터 추가 (account_status)
	
}
