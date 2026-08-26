package com.surit.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.surit.admin.model.dto.MemberSearchCondition;
import com.surit.admin.service.MemberManagementService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin/members")
@RequiredArgsConstructor
public class AdminMemberController {

	private final MemberManagementService memberService;


	
	@GetMapping("/{userNo}")
	public String memberDetail(@PathVariable Long userNo, Model model) {
		model.addAttribute("fixer", memberService.getFixerDetail(userNo));
		return "admin/admin-member-detail";
	}

	@PostMapping("/{userNo}/approve")
	public String approve(@PathVariable Long userNo,
	                      HttpSession session, RedirectAttributes ra) {
		Long adminNo = (Long) session.getAttribute("adminNo");
		memberService.approveFixer(userNo, adminNo);
		ra.addFlashAttribute("msg", "승인 처리되었습니다");
		return "redirect:/admin/members";
	}

	@PostMapping("/{userNo}/reject")
	public String reject(@PathVariable Long userNo,
	                     @RequestParam String reason,
	                     HttpSession session, RedirectAttributes ra) {
		Long adminNo = (Long) session.getAttribute("adminNo");
		memberService.rejectFixer(userNo, adminNo, reason);
		ra.addFlashAttribute("msg", "반려 처리되었습니다");
		return "redirect:/admin/members";
	}
	
	@GetMapping
	public String memberList(@ModelAttribute MemberSearchCondition condition, Model model) {
		int totalCount = memberService.getMemberCount(condition);
		int totalPage = (int) Math.ceil((double) totalCount / condition.getSize());

		model.addAttribute("pendingFixers", memberService.getPendingFixers());
		model.addAttribute("memberList",    memberService.getMemberList(condition));
		model.addAttribute("totalCount",    totalCount);
		model.addAttribute("totalPage",     totalPage);   // ← 추가
		model.addAttribute("condition",     condition);
		return "admin/admin-members";
	}
	
}