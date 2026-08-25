package com.surit.common.request.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.surit.common.request.service.RequestService;
import com.surit.user.SessionConst;
import com.surit.user.model.dto.UserDTO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/fixer/requests")
@RequiredArgsConstructor
public class RequestController {

	private final RequestService service;

	/** F-15 내 주변 새 접수 조회 */
	@GetMapping
	public String list(@RequestParam(value = "categoryCode", required = false) String categoryCode,
	                   @RequestParam(value = "keyword",      required = false) String keyword,
	                   HttpSession session,
	                   Model model,
	                   RedirectAttributes ra) {

		UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (loginMember == null) {
			return "redirect:/user/login?redirectURL=/fixer/requests";
		}

		try {
			model.addAttribute("requestList",  service.getNearbyRequests(loginMember.getUserNo(), categoryCode, keyword));
			model.addAttribute("categoryList", service.getCategoryList());
			model.addAttribute("categoryCode", categoryCode);
			model.addAttribute("keyword",      keyword);

		} catch (IllegalStateException e) {
			// 아직 인증 안 된 기사 → 신청 화면으로
			ra.addFlashAttribute("message", e.getMessage());
			return "redirect:/fixer/verify";
		}

		return "fixer/requests";
	}

	/**
	 * 접수 상세.
	 *
	 * @PathVariable 에 이름을 꼭 적는다.
	 * 컴파일 옵션(-parameters)이 없으면 자바가 파라미터 이름을 안 남겨서
	 * "Name for argument of type [long] not specified" 예외가 난다.
	 */
	@GetMapping("/{requestId}")
	public String detail(@PathVariable("requestId") long requestId,
	                     HttpSession session,
	                     Model model,
	                     RedirectAttributes ra) {

		UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (loginMember == null) {
			return "redirect:/user/login?redirectURL=/fixer/requests/" + requestId;
		}

		try {
			// 모델 이름을 "request" 로 하면 JSP 의 내장 객체 request 와 헷갈리니까 repair 로 둔다
			model.addAttribute("repair", service.getRequestDetail(loginMember.getUserNo(), requestId));

		} catch (IllegalStateException e) {
			ra.addFlashAttribute("message", e.getMessage());
			return "redirect:/fixer/requests";
		}

		return "fixer/requestDetail";
	}
}