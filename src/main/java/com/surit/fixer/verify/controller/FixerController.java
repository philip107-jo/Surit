package com.surit.fixer.verify.controller;

import java.io.IOException;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.surit.fixer.verify.model.dto.FixerProfileDTO;
import com.surit.fixer.verify.model.dto.FixerVerifyRequest;
import com.surit.fixer.verify.model.mapper.FixerMapper;
import com.surit.fixer.verify.service.FixerService;
import com.surit.user.SessionConst;
import com.surit.user.model.dto.UserDTO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/fixer")
@RequiredArgsConstructor
public class FixerController {

	private final FixerService service;
    private final FixerMapper mapper;
	/** 기사 인증 신청 화면 */
	@GetMapping("/verify")
	public String verifyForm(HttpSession session, Model model) {

		UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (loginMember == null) {
			return "redirect:/user/login?redirectURL=/fixer/verify";
		}

		model.addAttribute("categoryList", service.getCategoryList());
		model.addAttribute("regionList",   service.getRegionList());
		model.addAttribute("profile",      service.getMyProfile(loginMember.getUserNo()));

		return "fixer/verify";
	}

	/** 기사 인증 신청 처리 */
	@PostMapping("/verify")
	public String verify(@ModelAttribute FixerVerifyRequest request,
	                     HttpSession session,
	                     RedirectAttributes ra) {

		UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (loginMember == null) {
			return "redirect:/user/login?redirectURL=/fixer/verify";
		}

		/*
		 * 성공이든 실패든 redirect 로 끝낸다 (PRG).
		 * 다만 화면에서 색을 나눠야 하므로 messageType 을 함께 넘긴다 —
		 * 실패인데 파란 안내 박스로 보이면 사용자가 오류인 줄 모르고 지나친다.
		 */
		try {
			service.applyVerify(loginMember.getUserNo(), request);
			ra.addFlashAttribute("message", "인증 신청이 완료되었습니다. 심사까지 1~2일 걸립니다.");
			ra.addFlashAttribute("messageType", "success");

		} catch (IllegalStateException e) {
			// 중복 신청 / 필수값 누락 등 — 사용자에게 그대로 보여줄 수 있는 메시지
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("messageType", "error");

		} catch (IOException e) {
			e.printStackTrace();
			ra.addFlashAttribute("message", "파일 저장 중 오류가 발생했습니다. 다시 시도해주세요.");
			ra.addFlashAttribute("messageType", "error");
		}

		return "redirect:/fixer/verify";
	}

}
