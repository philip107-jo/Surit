package com.surit.fixer.mypage.service;

import com.surit.fixer.mypage.model.dto.FixerAddressDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

import com.surit.fixer.mypage.mapper.FixerMyPageMapper;

@Service
@RequiredArgsConstructor
public class FixerMyPageService {

    private final FixerMyPageMapper myPageMapper;

    // --- 수리 정보 관리 로직 ---

    @Transactional
    public void updateCategories(Long fixerNo, List<String> categoryCodes) {
        myPageMapper.deleteFixerCategories(fixerNo); // 기존 세팅 전부 날리고
        if (categoryCodes != null && !categoryCodes.isEmpty()) {
            myPageMapper.insertFixerCategories(fixerNo, categoryCodes); // 새로 인서트
        }
    }

    @Transactional
    public void updateRegions(Long fixerNo, List<String> regionCodes) {
        if (regionCodes != null && regionCodes.size() > 5) {
            throw new IllegalArgumentException("지역은 최대 5개까지만 등록 가능합니다."); // UI 기획 방어 로직
        }
        myPageMapper.deleteFixerRegions(fixerNo);
        if (regionCodes != null && !regionCodes.isEmpty()) {
            myPageMapper.insertFixerRegions(fixerNo, regionCodes);
        }
    }

    // --- 주소 관리 로직 ---

    public List<FixerAddressDTO> getAddresses(Long fixerNo) {
        return myPageMapper.selectAddresses(fixerNo);
    }

    @Transactional
    public void saveAddress(FixerAddressDTO addressDto) {
        // 현재 등록된 주소 개수 확인 (UI 기획상 최대 3개 제한)
        int currentCount = myPageMapper.countAddresses(addressDto.getFixerNo());
        if (currentCount >= 3) {
            throw new IllegalStateException("주소는 최대 3개까지만 등록할 수 있습니다.");
        }

        // '기본 주소'로 설정 체크박스를 눌렀다면, 기존 주소들의 기본주소 플래그를 N으로 해제
        if ("Y".equals(addressDto.getIsDefault())) {
            myPageMapper.resetDefaultAddress(addressDto.getFixerNo());
        }

        myPageMapper.insertAddress(addressDto);
    }

    @Transactional
    public void deleteAddress(Long fixerNo, Long addressId) {
        myPageMapper.deleteAddress(fixerNo, addressId);
    }
}