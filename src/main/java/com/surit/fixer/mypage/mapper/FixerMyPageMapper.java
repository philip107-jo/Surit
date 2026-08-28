package com.surit.fixer.mypage.mapper;


import java.util.List;

import com.surit.fixer.mypage.model.dto.FixerAddressDTO;

@Mapper
public interface FixerMyPageMapper {

    // --- 수리 카테고리 관리 ---
    int deleteFixerCategories(@Param("fixerNo") Long fixerNo);
    int insertFixerCategories(@Param("fixerNo") Long fixerNo, @Param("categoryCodes") List<String> categoryCodes);

    // --- 활동 지역 관리 ---
    int deleteFixerRegions(@Param("fixerNo") Long fixerNo);
    int insertFixerRegions(@Param("fixerNo") Long fixerNo, @Param("regionCodes") List<String> regionCodes);

    // --- 주소 관리 ---
    List<FixerAddressDTO> selectAddresses(@Param("fixerNo") Long fixerNo);
    int countAddresses(@Param("fixerNo") Long fixerNo);
    int resetDefaultAddress(@Param("fixerNo") Long fixerNo);
    int insertAddress(FixerAddressDTO addressDto);
    int deleteAddress(@Param("fixerNo") Long fixerNo, @Param("addressId") Long addressId);
}