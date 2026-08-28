package com.surit.fixer.estimate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.surit.fixer.estimate.model.dto.EstimateForm;
import com.surit.fixer.estimate.service.EstimateService;
import com.surit.user.SessionConst;
import com.surit.user.model.dto.UserDTO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/fixer/estimates")
@RequiredArgsConstructor
public class EstimateController {

	private final EstimateService service;

	/** F-16 견적 작성 화면 */
	@GetMapping("/new")
	public String form(@RequestParam("requestId") long requestId,
	                   HttpSession session,
	                   Model model,
	                   RedirectAttributes ra) {

		UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (loginMember == null) {
			return "redirect:/user/login?redirectURL=/fixer/estimates/new?requestId=" + requestId;
		}

		try {
			model.addAttribute("repair", service.getTargetRequest(loginMember.getUserNo(), requestId));

		} catch (IllegalStateException e) {
			ra.addFlashAttribute("message", e.getMessage());
			return "redirect:/fixer/requests";
		}

		return "fixer/estimateForm";
	}

	/**
	 * 견적 제출.
	 *
	 * 성공하든 실패하든 redirect 로 끝낸다(PRG 패턴).
	 * 그냥 forward 하면 사용자가 새로고침했을 때 POST 가 다시 날아가서
	 * 견적이 두 번 등록될 수 있다.
	 */
	@PostMapping
	public String submit(@ModelAttribute EstimateForm form,
	                     HttpSession session,
	                     RedirectAttributes ra) {

		UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (loginMember == null) {
			return "redirect:/user/login?redirectURL=/fixer/requests";
		}

		try {
			service.submit(loginMember.getUserNo(), form);
			ra.addFlashAttribute("message", "견적을 제출했습니다.");
			return "redirect:/fixer/estimates";

		} catch (IllegalStateException e) {
			ra.addFlashAttribute("message", e.getMessage());

			/*
			 * requestId 가 없으면(폼이 조작됐거나 값이 안 넘어온 경우)
			 * "...new?requestId=null" 로 리다이렉트하게 되고,
			 * 그 다음 화면은 long 타입으로 못 받아서 또 에러 화면이 뜬다.
			 * requestId 가 있을 때만 견적 작성 화면으로 돌려보내고,
			 * 없으면 안전하게 목록으로 보낸다.
			 */
			if (form.getRequestId() != null) {
				return "redirect:/fixer/estimates/new?requestId=" + form.getRequestId();
			}
			return "redirect:/fixer/requests";
		}
	}

	/** 내가 낸 견적 목록 */
	@GetMapping
	public String list(HttpSession session, Model model, RedirectAttributes ra) {

		UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (loginMember == null) {
			return "redirect:/user/login?redirectURL=/fixer/estimates";
		}

		try {
			model.addAttribute("estimateList", service.getMyEstimates(loginMember.getUserNo()));

		} catch (IllegalStateException e) {
			ra.addFlashAttribute("message", e.getMessage());
			return "redirect:/fixer/verify";
		}

		return "fixer/estimates";
	}
}