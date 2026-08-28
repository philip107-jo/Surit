package com.surit.fixer.job.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.surit.fixer.job.service.JobService;
import com.surit.user.SessionConst;
import com.surit.user.dto.UserDTO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/fixer/jobs")
@RequiredArgsConstructor
public class JobController {

	private final JobService service;

	/** F-17 내 작업 목록 */
	@GetMapping
	public String list(@RequestParam(value = "statusCode", required = false) String statusCode,
	                   HttpSession session,
	                   Model model,
	                   RedirectAttributes ra) {

		UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (loginMember == null) {
			return "redirect:/user/login?redirectURL=/fixer/jobs";
		}

		try {
			model.addAttribute("jobList",    service.getMyJobs(loginMember.getUserNo(), statusCode));
			model.addAttribute("statusCode", statusCode);

		} catch (IllegalStateException e) {
			ra.addFlashAttribute("message", e.getMessage());
			return "redirect:/fixer/verify";
		}

		return "fixer/jobs";
	}

	/** 작업 상세 */
	@GetMapping("/{requestId}")
	public String detail(@PathVariable("requestId") long requestId,
	                     HttpSession session,
	                     Model model,
	                     RedirectAttributes ra) {

		UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (loginMember == null) {
			return "redirect:/user/login?redirectURL=/fixer/jobs/" + requestId;
		}

		try {
			model.addAttribute("job", service.getMyJob(loginMember.getUserNo(), requestId));

		} catch (IllegalStateException e) {
			ra.addFlashAttribute("message", e.getMessage());
			return "redirect:/fixer/jobs";
		}

		return "fixer/jobDetail";
	}

	/**
	 * 수리 완료 처리.
	 *
	 * 상태를 바꾸는 일은 GET 으로 만들지 않는다.
	 * GET 으로 두면 링크를 클릭하거나 크롤러가 긁기만 해도 상태가 바뀐다.
	 */
	@PostMapping("/{requestId}/complete")
	public String complete(@PathVariable("requestId") long requestId,
	                       HttpSession session,
	                       RedirectAttributes ra) {

		UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);
		if (loginMember == null) {
			return "redirect:/user/login?redirectURL=/fixer/jobs";
		}

		try {
			service.complete(loginMember.getUserNo(), requestId);
			ra.addFlashAttribute("message", "수리 완료로 변경했습니다.");

		} catch (IllegalStateException e) {
			ra.addFlashAttribute("message", e.getMessage());
		}

		return "redirect:/fixer/jobs/" + requestId;
	}
}
