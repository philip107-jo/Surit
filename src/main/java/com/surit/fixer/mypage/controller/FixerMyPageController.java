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

/**
 * 기사 마이페이지 (수리 정보 관리) 컨트롤러
 * 유저 마이페이지(MypageController)와 동일한 세션 로직(loginMember) 사용
 */
@Controller
@RequestMapping("/fixer/mypage") // 유저처럼 클래스 레벨로 경로 통일
@RequiredArgsConstructor // 팀 규칙: Autowired 대신 롬복 사용
public class FixerMyPageController {

    private final FixerMyPageService service;

    /**
     * 기사 마이페이지 화면 조회
     * GET /fixer/mypage
     */
    @GetMapping
    public String fixerMyPage(HttpSession session, Model model) {

        // 1. 팀 규칙에 맞게 'loginMember'로 세션 꺼내기
        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");

        // 2. 로그인 안 되어 있으면 로그인 창으로 (되돌아올 주소 포함)
        if (loginMember == null) {
            return "redirect:/user/login?redirectURL=/fixer/mypage";
        }

        Long fixerId = loginMember.getUserNo();

        // 3. JSP 화면에서 ${user.name} 등을 쓸 수 있게 유저 객체 담기 (유저 마이페이지와 동일)
        model.addAttribute("user", loginMember);

        // 4. 기사 카테고리 & 지역 데이터 담기
        model.addAttribute("categoryList", service.getAllCategories());
        model.addAttribute("regionList", service.getAllRegions());
        model.addAttribute("myCategories", service.getMyCategories(fixerId));
        model.addAttribute("myRegions", service.getMyRegions(fixerId));

        return "fixer/mypage";
    }

    /**
     * 카테고리 설정 저장
     * POST /fixer/mypage/categories
     */
    @PostMapping("/categories")
    public String updateCategories(@RequestParam(value="categories", required=false) List<String> categories,
                                   HttpSession session) {

        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");

        if (loginMember == null) {
            return "redirect:/user/login?redirectURL=/fixer/mypage";
        }

        service.updateCategories(loginMember.getUserNo(), categories);

        return "redirect:/fixer/mypage";
    }

    /**
     * 지역 설정 저장
     * POST /fixer/mypage/regions
     */
    @PostMapping("/regions")
    public String updateRegions(@RequestParam(value="regions", required=false) List<String> regions,
                                HttpSession session) {

        UserDTO loginMember = (UserDTO) session.getAttribute("loginMember");

        if (loginMember == null) {
            return "redirect:/user/login?redirectURL=/fixer/mypage";
        }

        service.updateRegions(loginMember.getUserNo(), regions);

        return "redirect:/fixer/mypage";
    }
}