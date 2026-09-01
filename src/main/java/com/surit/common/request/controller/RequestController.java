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
import com.surit.user.mapper.UserAddressMapper;
import com.surit.user.model.dto.UserAddressDTO;
import com.surit.user.model.dto.UserDTO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

/*
 * 클래스에 @RequestMapping 을 안 붙인 이유 :
 * 기사용(/fixer/requests)과 고객용(/request/...)이 한 컨트롤러에 같이 있어서
 * 공통 접두어가 없다. 그래서 메서드마다 전체 주소를 적는다.
 */
@Controller
@RequiredArgsConstructor
public class RequestController {

    private final RequestService service;
    private final UserAddressMapper userAddressMapper;

    /** F-15 내 주변 새 접수 조회 */
    @GetMapping("/fixer/requests")
    public String list(@RequestParam(value = "categoryCode", required = false) String categoryCode,
                        @RequestParam(value = "keyword", required = false) String keyword,
                        HttpSession session,
                        Model model,
                        RedirectAttributes ra) {

        UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);
        if (loginMember == null) {
            return "redirect:/user/login?redirectURL=/fixer/requests";
        }

        try {
            model.addAttribute("requestList", service.getNearbyRequests(loginMember.getUserNo(), categoryCode, keyword));
            model.addAttribute("categoryList", service.getCategoryList());
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
     * 접수 상세 (기사용).
     *
     * @PathVariable 에 이름을 꼭 적는다.
     * 컴파일 옵션(-parameters)이 없으면 자바가 파라미터 이름을 안 남겨서
     * "Name for argument of type [long] not specified" 예외가 난다.
     */
    @GetMapping("/fixer/requests/{requestId}")
    public String detail(@PathVariable("requestId") Long requestId,
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

    /**
     * 고객 수리 접수 페이지
     * GET /request/request
     */
    @GetMapping("/request/request")
    public String requestPage(@RequestParam(value = "cat", required = false) String cat,
                               HttpSession session,
                               Model model) {

        UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);
        if (loginMember == null) {
            return "redirect:/user/login?redirectURL=/request/request";
        }

        String selectedCategoryCode = null;
        if (cat != null) {
            switch (cat) {
                case "lock":   selectedCategoryCode = "CAT_10"; break;
                case "fridge": selectedCategoryCode = "CAT_02"; break;
                case "pc":     selectedCategoryCode = "CAT_01"; break;
                case "pipe":   selectedCategoryCode = "CAT_05"; break;
                case "elec":   selectedCategoryCode = "CAT_06"; break;
                case "etc":    selectedCategoryCode = "CAT_07"; break;
            }
        }

        // 카테고리 목록
        model.addAttribute("categoryList", service.getCategoryList());

        // 방문 시간대 목록
        model.addAttribute("visitTimeList", service.getVisitTimeList());

        // 메인에서 선택한 카테고리
        model.addAttribute("selectedCategoryCode", selectedCategoryCode);

        // 저장된 주소 목록 (로그인 확인은 위에서 이미 끝났으니 loginMember 그대로 재사용)
        List<UserAddressDTO> addressList =
                userAddressMapper.selectAddressesByUserNo(loginMember.getUserNo());
        model.addAttribute("addressList", addressList);

        return "request/request";
    }

    /**
     * 고객 수리 접수 등록
     * POST /request/request
     */
    @PostMapping("/request/request")
    public String createRequest(@ModelAttribute RequestDTO request,
                                 HttpSession session,
                                 RedirectAttributes ra) {

        UserDTO loginMember = (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);
        if (loginMember == null) {
            return "redirect:/user/login?redirectURL=/request/request";
        }

        try {
            // 로그인한 회원 번호는 폼이 아니라 세션에서 넣는다 (폼은 조작 가능)
            request.setUserNo(loginMember.getUserNo());

            service.createRequest(request);

            ra.addFlashAttribute("message", "수리 접수가 완료되었습니다.");

            // 방금 생성된 접수의 매칭 화면으로 이동
            // service.createRequest() 실행 후 request 객체에 requestId 가 자동으로 채워져 있어야 함
            // (RequestMapper.xml 의 insertRequest 에 useGeneratedKeys="true" keyProperty="requestId" 설정 필요)
            return "redirect:/request/matching/" + request.getRequestId();

        } catch (IllegalStateException e) {
            ra.addFlashAttribute("message", e.getMessage());
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
    public String matching(@PathVariable("requestId") Long requestId,
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
    public String selectEstimate(@RequestParam("requestId") Long requestId,
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

    /** /request 주소로 접근 시 /request/request 로 리다이렉트 (cat 파라미터는 그대로 이어줌) */
    @GetMapping("/request")
    public String index(@RequestParam(value = "cat", required = false) String cat) {

        if (cat != null && !cat.isBlank()) {
            return "redirect:/request/request?cat=" + cat;
        }

        return "redirect:/request/request";
    }
    /**
     * 고객 접수 수정 버튼
     * 기존 접수 페이지로 이동
     */
    @GetMapping("/request/{requestId}/edit")
    public String editRequest(
            @PathVariable("requestId") Long requestId,
            HttpSession session,
            RedirectAttributes ra) {

        UserDTO loginMember =
                (UserDTO) session.getAttribute(SessionConst.LOGIN_MEMBER);

        if (loginMember == null) {
            return "redirect:/user/login";
        }

        try {

            RequestDTO request =
                    service.getRequestForMatching(
                            loginMember.getUserNo(),
                            requestId
                    );

            // 접수 대기 / 매칭 중일 때만 수정 가능
            if (!"REQ_01".equals(request.getStatusCode())
                    && !"REQ_02".equals(request.getStatusCode())) {

                ra.addFlashAttribute(
                        "message",
                        "이미 매칭된 접수는 수정할 수 없습니다."
                );

                return "redirect:/request/matching/" + requestId;
            }

            // 기존 접수 페이지로 이동
            return "redirect:/request/request?editId=" + requestId;

        } catch (IllegalStateException e) {

            ra.addFlashAttribute(
                    "message",
                    e.getMessage()
            );

            return "redirect:/request/matching/" + requestId;
        }
    }
    /**
     * 고객 접수 수정 저장
     */
    @PostMapping("/request/{requestId}/edit")
    public String updateRequest(
            @PathVariable("requestId") Long requestId,
            @ModelAttribute RequestDTO request,
            HttpSession session,
            RedirectAttributes ra) {

        UserDTO loginMember =
                (UserDTO) session.getAttribute(
                        SessionConst.LOGIN_MEMBER
                );


        if (loginMember == null) {

            return "redirect:/user/login?redirectURL=/request/"
                    + requestId
                    + "/edit";
        }


        try {

            // URL의 requestId 사용
            request.setRequestId(requestId);


            service.updateRequest(
                    loginMember.getUserNo(),
                    request
            );


            ra.addFlashAttribute(
                    "message",
                    "접수 내용이 수정되었습니다."
            );


            return "redirect:/request/matching/"
                    + requestId;


        } catch (IllegalStateException e) {

            ra.addFlashAttribute(
                    "message",
                    e.getMessage()
            );


            return "redirect:/request/"
                    + requestId
                    + "/edit";
        }
    }
    /**
     * 고객 접수 취소
     */
    @PostMapping("/request/{requestId}/cancel")
    public String cancelRequest(
            @PathVariable("requestId") Long requestId,
            HttpSession session,
            RedirectAttributes ra) {

        UserDTO loginMember =
                (UserDTO) session.getAttribute(
                        SessionConst.LOGIN_MEMBER
                );


        if (loginMember == null) {

            return "redirect:/user/login";
        }


        try {

            service.cancelRequest(
                    loginMember.getUserNo(),
                    requestId
            );


            ra.addFlashAttribute(
                    "message",
                    "접수가 취소되었습니다."
            );


            return "redirect:/user/mypage";


        } catch (IllegalStateException e) {

            ra.addFlashAttribute(
                    "message",
                    e.getMessage()
            );


            return "redirect:/request/matching/"
                    + requestId;
        }
    }
       
    
}