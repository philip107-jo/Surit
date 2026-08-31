package com.surit.fixer.mypage.controller;

import com.surit.fixer.mypage.model.dto.FixerAddressDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.surit.fixer.mypage.service.FixerMyPageService;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/fixer/mypage")
@RequiredArgsConstructor
public class FixerMyPageController {

    private final FixerMyPageService FixerMypageService;

    // ==========================================
    // 1. 수리 정보 관리 (partner-mypage.html)
    // ==========================================

    @GetMapping
    public String showRepairInfoForm(@SessionAttribute("loginUserNo") Long fixerNo, Model model) {
        // 내 카테고리와 지역 정보를 DB에서 가져와 화면에 전달
        model.addAttribute("myCategories", FixerMypageService.getCategories(fixerNo));
        model.addAttribute("myRegions", FixerMypageService.getRegions(fixerNo));
        return "partner/mypage";
    }

    @PostMapping("/category")
    public String saveCategories(@SessionAttribute("loginUserNo") Long fixerNo,
                                 @RequestParam List<String> categoryCodes) {
        // [카테고리 저장] 버튼 클릭 시 동작
        FixerMypageService.updateCategories(fixerNo, categoryCodes);
        return "redirect:/fixer/mypage";
    }

    @PostMapping("/region")
    public String saveRegions(@SessionAttribute("loginUserNo") Long fixerNo,
                              @RequestParam List<String> regionCodes) {
        // [지역 저장] 버튼 클릭 시 동작 (최대 5개 검증 로직 필요)
        FixerMypageService.updateRegions(fixerNo, regionCodes);
        return "redirect:/fixer/mypage";
    }

    // ==========================================
    // 2. 주소 관리 (partner-mypage-address.html)
    // ==========================================

    @GetMapping("/addresses")
    public String showAddressList(@SessionAttribute("loginUserNo") Long fixerNo, Model model) {
        // 기사가 등록한 주소 목록(집, 작업실 등)을 화면에 전달
        model.addAttribute("addresses", FixerMypageService.getAddresses(fixerNo));
        return "partner/mypage-address";
    }

    @GetMapping("/addresses/form")
    public String showAddressForm() {
        // 새 주소 추가 화면으로 이동 (partner-mypage-address-form.html)
        return "partner/mypage-address-form";
    }

    @PostMapping("/addresses")
    public String saveAddress(@SessionAttribute("loginUserNo") Long fixerNo,
                              @ModelAttribute FixerAddressDTO addressDto) {
        // [저장하기] 버튼 클릭 시 새 주소 DB에 INSERT
        addressDto.setFixerNo(fixerNo);
        FixerMypageService.saveAddress(addressDto);
        return "redirect:/fixer/mypage/addresses";
    }

    @PostMapping("/addresses/{addressId}/delete")
    public String deleteAddress(@SessionAttribute("loginUserNo") Long fixerNo,
                                @PathVariable Long addressId) {
        // [삭제] 버튼 클릭 시 주소 삭제
        FixerMypageService.deleteAddress(fixerNo, addressId);
        return "redirect:/fixer/mypage/addresses";
    }
}
