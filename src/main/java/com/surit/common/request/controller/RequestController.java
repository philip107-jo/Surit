package com.surit.common.request.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.surit.common.request.model.dto.RequestDTO;
import com.surit.common.request.service.RequestService;
import com.surit.fixer.estimate.model.dto.EstimateDTO;
import com.surit.user.SessionConst;
import com.surit.user.model.dto.UserDTO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class RequestController {

    private final RequestService service;

    /** F-15 내 주변 새 접수 조회 */
    @GetMapping("/fixer/requests")
    public String list(
            @RequestParam(value = "categoryCode", required = false) String categoryCode,
            @RequestParam(value = "keyword", required = false) String keyword,
            HttpSession session,
            Model model,
            RedirectAttributes ra) {

        UserDTO loginMember =
                (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);

        if (loginMember == null) {
            return "redirect:/user/login?redirectURL=/fixer/requests";
        }

        try {

            model.addAttribute(
                "requestList",
                service.getNearbyRequests(
                    Long.valueOf(loginMember.getUserNo()),
                    categoryCode,
                    keyword
                )
            );

            model.addAttribute(
                "categoryList",
                service.getCategoryList()
            );
            model.addAttribute(
            	    "visitTimeList",
            	    service.getVisitTimeList()
            	);

            model.addAttribute("categoryCode", categoryCode);
            model.addAttribute("keyword", keyword);

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
    @GetMapping("/fixer/requests/{requestId}")
    public String detail(
            @PathVariable("requestId") Long requestId,
            HttpSession session,
            Model model,
            RedirectAttributes ra) {

        UserDTO loginMember =
                (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);

        if (loginMember == null) {
            return "redirect:/user/login?redirectURL=/fixer/requests/" + requestId;
        }

        try {
            // 모델 이름을 "request" 로 하면 JSP 의 내장 객체 request 와 헷갈리니까 repair 로 둔다

            model.addAttribute(
                "repair",
                service.getRequestDetail(
                    Long.valueOf(loginMember.getUserNo()),
                    requestId
                )
            );

        } catch (IllegalStateException e) {

            ra.addFlashAttribute("message", e.getMessage());

            return "redirect:/fixer/requests";
        }

        return "fixer/requestDetail";
    }

    /** 고객 수리 접수 페이지 */
    @GetMapping("/request/request")
    public String requestPage(
            @RequestParam(value = "cat", required = false) String cat,
            Model model, HttpSession session) {
    	UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);
    	if (loginMember == null) {
    	    return "redirect:/user/login?redirectURL=/request/request";
    	}
        String selectedCategoryCode = null;

        if (cat != null) {
            switch (cat) {
                case "lock":
                    selectedCategoryCode = "CAT_10";
                    break;

                case "fridge":
                    selectedCategoryCode = "CAT_02";
                    break;

                case "pc":
                    selectedCategoryCode = "CAT_01";
                    break;

                case "pipe":
                    selectedCategoryCode = "CAT_05";
                    break;

                case "elec":
                    selectedCategoryCode = "CAT_06";
                    break;

                case "etc":
                    selectedCategoryCode = "CAT_07";
                    break;
            }
        }

        // 카테고리 목록
        model.addAttribute(
            "categoryList",
            service.getCategoryList()
        );

        // 방문 시간대 목록
        model.addAttribute(
            "visitTimeList",
            service.getVisitTimeList()
        );

        // 메인에서 선택한 카테고리
        model.addAttribute(
            "selectedCategoryCode",
            selectedCategoryCode
        );

        return "request/request";
    }

    @PostMapping("/request/request")
    public String createRequest(
            @ModelAttribute RequestDTO request,
            HttpSession session,
            RedirectAttributes ra) {

        UserDTO loginMember =
                (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);

        if (loginMember == null) {
            return "redirect:/user/login?redirectURL=/request/request";
        }

        try {

            request.setUserNo(
                    Long.valueOf(loginMember.getUserNo())
            );

            service.createRequest(request);

            ra.addFlashAttribute(
                    "message",
                    "수리 접수가 완료되었습니다."
            );

            // 방금 생성된 접수의 매칭 화면으로 이동
            // service.createRequest() 실행 후 request 객체에 requestId 가 자동으로 채워져 있어야 함
            // (RequestMapper.xml 의 insertRequest 에 useGeneratedKeys="true" keyProperty="requestId" 설정 필요)
            return "redirect:/request/matching/" + request.getRequestId();

        } catch (IllegalStateException e) {

            ra.addFlashAttribute(
                    "message",
                    e.getMessage()
            );

            return "redirect:/request/request";
        }
    }

    /**
     * 기사 매칭 · 선택 화면
     * GET /request/matching/{requestId}
     *
     * 이 접수에 들어온 견적(기사) 목록을 보여주고, 고객이 그중 하나를 고른다.
     */
    @GetMapping("/request/matching/{requestId}")
    public String matching(
            @PathVariable("requestId") Long requestId,
            HttpSession session,
            Model model,
            RedirectAttributes ra) {

        UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);

        if (loginMember == null) {
            return "redirect:/user/login?redirectURL=/request/matching/" + requestId;
        }

        try {
            // 내 접수가 맞는지 확인 + 접수 정보
            RequestDTO request = service.getRequestForMatching(loginMember.getUserNo(), requestId);

            // 이 접수에 들어온 견적 목록
            List<EstimateDTO> estimateList = service.getEstimatesForMatching(requestId);

            model.addAttribute("request", request);
            model.addAttribute("estimateList", estimateList);

        } catch (IllegalStateException e) {
            ra.addFlashAttribute("message", e.getMessage());
            return "redirect:/user/mypage";
        }

        return "request/matching";
    }

    /**
     * 기사(견적) 선택 확정
     * POST /request/matching/select
     */
    @PostMapping("/request/matching/select")
    public String selectEstimate(
            @RequestParam("requestId") Long requestId,
            @RequestParam("estimateId") Long estimateId,
            HttpSession session,
            RedirectAttributes ra) {

        UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);

        if (loginMember == null) {
            return "redirect:/user/login?redirectURL=/request/matching/" + requestId;
        }

        try {
            service.selectEstimate(loginMember.getUserNo(), requestId, estimateId);
            ra.addFlashAttribute("message", "기사님을 선택했습니다.");

        } catch (IllegalStateException e) {
            ra.addFlashAttribute("message", e.getMessage());
            return "redirect:/request/matching/" + requestId;
        }

        return "redirect:/user/mypage";
    }

    /** /request 주소로 접근 시 /request/request 로 리다이렉트 */
    @GetMapping("/request")
    public String index(
            @RequestParam(value = "cat", required = false) String cat) {

        if (cat != null && !cat.isBlank()) {
            return "redirect:/request/request?cat=" + cat;
        }

        return "redirect:/request/request";
    }
}