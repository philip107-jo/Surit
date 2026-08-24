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

	// 서류보기 (조회 기능)
	
	List<AdminMemberListDTO> selectPendingFixers();                        // 승인 대기 기사
	List<AdminMemberListDTO> selectMemberList(MemberSearchCondition cond); // 전체 회원 목록
	int selectMemberCount(MemberSearchCondition cond);                     // 페이징용 개수
	AdminFixerDetailDTO selectFixerDetail(Long userNo);                    // 기사 상세
	List<FixerLicenseDTO> selectLicenses(Long userNo);                     // 자격증
	List<String> selectCategories(Long userNo);                            // 수리 카테고리
	List<String> selectRegions(Long userNo);                               // 활동 지역

	// --- 변경 ---
	int updateApprove(@Param("userNo") Long userNo);
	int updateReject(@Param("userNo") Long userNo,
	                 @Param("reason") String reason);
}