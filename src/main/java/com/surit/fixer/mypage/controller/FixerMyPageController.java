package com.surit.fixer.mypage.controller;

import com.surit.fixer.mypage.service.FixerMyPageService;
import com.surit.user.model.dto.UserDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/fixer")
public class FixerMyPageController {

    private final FixerMyPageService service;

    @Autowired
    public FixerMyPageController(FixerMyPageService service) {
        this.service = service;
    }

    // ==========================================
    // 1. 수리 정보 관리 화면 띄우기
    // ==========================================
    @GetMapping("/mypage")
    public String fixerMyPage(HttpSession session, Model model) {

        // 세션에서 로그인된 회원 정보 꺼내기
        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");

        // 만약 로그인 정보가 없거나 세션이 만료되었다면 로그인 페이지로 튕겨내기
        if (loginMember == null) {
            return "redirect:/user/login";
        }

        // 로그인한 기사님의 고유 식별 번호 가져오기
        Long fixerId = loginMember.getUserNo();

        model.addAttribute("categoryList", service.getAllCategories());
        model.addAttribute("regionList", service.getAllRegions());
        model.addAttribute("myCategories", service.getMyCategories(fixerId));
        model.addAttribute("myRegions", service.getMyRegions(fixerId));

        return "fixer/FixerMypage";
    }

    // 2. 카테고리 저장 처리
    @PostMapping("/mypage/categories")
    public String updateCategories(@RequestParam(value="categories", required=false) List<String> categories, HttpSession session) {

        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/user/login";
        }

        Long fixerId = loginMember.getUserNo();
        service.updateCategories(fixerId, categories);

        return "redirect:/fixer/mypage";
    }

    // 3. 지역 저장 처리
    @PostMapping("/mypage/regions")
    public String updateRegions(@RequestParam(value="regions", required=false) List<String> regions, HttpSession session) {

        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/user/login";
        }

        Long fixerId = loginMember.getUserNo();
        service.updateRegions(fixerId, regions);

        return "redirect:/fixer/mypage";
    }
}