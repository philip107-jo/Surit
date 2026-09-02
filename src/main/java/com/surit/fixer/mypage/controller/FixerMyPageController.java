package com.surit.fixer.mypage.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.surit.fixer.mypage.service.FixerMyPageService;
import com.surit.user.model.dto.UserDTO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/fixer/mypage")
@RequiredArgsConstructor
public class FixerMyPageController {

    private final FixerMyPageService service;

    @GetMapping
    public String fixerMyPage(HttpSession session, Model model) {
        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");

        if (loginMember == null) {
            return "redirect:/user/login?redirectURL=/fixer/mypage";
        }

        Long fixerId = loginMember.getUserNo();

        // JSP 사이드바 및 프로필 공통 영역을 위한 user 속성 추가
        model.addAttribute("user", loginMember);

        model.addAttribute("categoryList", service.getAllCategories());
        model.addAttribute("regionList", service.getAllRegions());
        model.addAttribute("myCategories", service.getMyCategories(fixerId));
        model.addAttribute("myRegions", service.getMyRegions(fixerId));

        return "fixer/mypage";
    }

    @PostMapping("/categories")
    public String updateCategories(@RequestParam(value="categories", required=false) List<String> categories,
                                   HttpSession session) {
        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/user/login";

        service.updateCategories(loginMember.getUserNo(), categories);
        return "redirect:/fixer/mypage";
    }

    @PostMapping("/regions")
    public String updateRegions(@RequestParam(value="regions", required=false) List<String> regions,
                                HttpSession session) {
        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/user/login";

        service.updateRegions(loginMember.getUserNo(), regions);
        return "redirect:/fixer/mypage";
    }

    // ==========================================
    // 주소 관리 컨트롤러 (FixerMyPageController.java 내부에 추가 필요)
    // ==========================================
    @GetMapping("/address")
    public String addressList(HttpSession session, Model model) {
        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/user/login";
        model.addAttribute("user", loginMember);

        // TODO: DB에서 등록된 주소 목록 가져오기 로직 필요
        // model.addAttribute("addressList", ...);

        return "fixer/address-manage"; // 뷰 리턴 주의!
    }

    @GetMapping("/address/form")
    public String addressForm(HttpSession session, Model model, @RequestParam(required=false) Long id) {
        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/user/login";
        model.addAttribute("user", loginMember);

        // TODO: id가 있으면 해당 주소 상세 조회, 없으면 빈 폼 전달 로직 필요

        return "fixer/mypageAddressForm"; // 뷰 리턴 주의!
    }


    // ==========================================
    // 내 정보 수정 컨트롤러 (FixerMyPageController.java 내부에 추가 필요)
    // ==========================================
    @GetMapping("/profile")
    public String profileForm(HttpSession session, Model model) {
        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/user/login";
        model.addAttribute("user", loginMember);

        // TODO: 회원 정보 조회 로직 필요

        return "fixer/editProfile"; // 뷰 리턴 주의!
    }
}