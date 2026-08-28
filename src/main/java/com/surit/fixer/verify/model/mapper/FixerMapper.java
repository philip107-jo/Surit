package com.surit.fixer.verify.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.surit.fixer.verify.model.dto.FixerLicenseDTO;
import com.surit.fixer.verify.model.dto.FixerProfileDTO;

@Mapper
public interface FixerMapper {

	// ---------- 조회 ----------

	/** 기사 프로필 (신청 이력이 있는지 확인용). 없으면 null */
<<<<<<< HEAD
	FixerProfileDTO selectFixerProfile(long userNo);

	/** 기사가 등록한 자격증 목록 (재신청 시 기존 파일 삭제용) */
	List<FixerLicenseDTO> selectLicensesByUserNo(long userNo);
=======
	FixerProfileDTO selectFixerProfile(Long userNo);

	/** 기사가 등록한 자격증 목록 (재신청 시 기존 파일 삭제용) */
	List<FixerLicenseDTO> selectLicensesByUserNo(Long userNo);
>>>>>>> 718f7fe4d56ce2dc5f6840629fa877ded9b6d8e5

	// ---------- 등록 / 수정 ----------

	int insertFixerProfile(FixerProfileDTO profile);   // 신규 신청
	int updateFixerProfile(FixerProfileDTO profile);   // 재신청

	int insertFixerLicense(FixerLicenseDTO license);

<<<<<<< HEAD
	int insertFixerRegion(@Param("userNo") long userNo,
	                      @Param("regionCode") String regionCode);

	int insertFixerCategory(@Param("userNo") long userNo,
=======
	int insertFixerRegion(@Param("userNo") Long userNo,
	                      @Param("regionCode") String regionCode);

	int insertFixerCategory(@Param("userNo") Long userNo,
>>>>>>> 718f7fe4d56ce2dc5f6840629fa877ded9b6d8e5
	                        @Param("categoryCode") String categoryCode);

	// ---------- 삭제 (재신청 시 기존 데이터 정리) ----------

<<<<<<< HEAD
	int deleteLicensesByUserNo(long userNo);
	int deleteRegionsByUserNo(long userNo);
	int deleteCategoriesByUserNo(long userNo);
=======
	int deleteLicensesByUserNo(Long userNo);
	int deleteRegionsByUserNo(Long userNo);
	int deleteCategoriesByUserNo(Long userNo);
>>>>>>> 718f7fe4d56ce2dc5f6840629fa877ded9b6d8e5
}
