package com.surit.admin.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.surit.admin.model.dto.AdminFixerDetailDTO;
import com.surit.admin.model.dto.AdminMemberListDTO;
import com.surit.admin.model.dto.FixerLicenseDTO;
import com.surit.admin.model.dto.MemberSearchCondition;

@Mapper
public interface MemberManagementMapper {

	// --- 조회 ---
	List<AdminMemberListDTO> selectPendingFixers();
	List<AdminMemberListDTO> selectMemberList(MemberSearchCondition cond);
	int selectMemberCount(MemberSearchCondition cond);
	AdminFixerDetailDTO selectFixerDetail(Long userNo);
	List<FixerLicenseDTO> selectLicenses(Long userNo);
	List<String> selectCategories(Long userNo);
	List<String> selectRegions(Long userNo);

	// --- 변경 ---
	int updateApprove(@Param("userNo") Long userNo);
	int updateReject(@Param("userNo") Long userNo,
	                 @Param("reason") String reason);
}