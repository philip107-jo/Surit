package com.surit.fixer.block.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.surit.fixer.block.service.FixerBlockService;

@Slf4j
@Controller
@RequestMapping("/fixer/blocked")
@RequiredArgsConstructor
public class FixerBlockController {

    private final FixerBlockService blockService;

    /**
     * 차단 고객 목록 화면 조회
     */
    @GetMapping
    public String showBlockedList(@SessionAttribute("loginUserNo") Long fixerNo, Model model) {
        log.info("차단 고객 목록 조회 - 기사번호: {}", fixerNo);

        model.addAttribute("blockedList", blockService.getBlockedCustomers(fixerNo));
        return "partner/blocked"; // WEB-INF/views/partner/blocked.jsp 로 이동
    }

    /**
     * 차단 해제 처리
     */
    @PostMapping("/{blockId}/unblock")
    public String unblockCustomer(
            @SessionAttribute("loginUserNo") Long fixerNo,
            @PathVariable Long blockId) {

        log.info("차단 해제 요청 - 기사번호: {}, 차단ID: {}", fixerNo, blockId);

        blockService.unblockCustomer(fixerNo, blockId);

        // 차단 해제 후 다시 목록 화면으로 새로고침
        return "redirect:/fixer/blocked";
    }
}