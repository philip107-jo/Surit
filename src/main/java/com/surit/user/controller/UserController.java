package com.surit.user.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.surit.common.ApiResponse;
import com.surit.common.request.model.dto.RequestDTO;
import com.surit.common.request.service.RequestService;
import com.surit.user.SessionConst;
import com.surit.user.model.dto.UserDTO;
import com.surit.user.service.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/user")
public class UserController {
	private final UserService service;
	public UserController (UserService service) {
		this.service = service;
	}
	
	
	@GetMapping("/sign")
	public String signForm() {
		return "user/sign";
		
	}
	@GetMapping("/login")
	public String loginForm() {
		return "user/login";
	}
	
	@PostMapping("/sign")
	public String sign(@ModelAttribute UserDTO user,
		
			RedirectAttributes redirectAttr) {
		System.out.println(user);
		
		try {
		service.sign(user);
		}catch(IOException e) {
			e.printStackTrace();
			
			redirectAttr.addFlashAttribute("error", "회원 가입 실패");
			
			//예외 발생 시 회원 가입 페이지로 리다이렉트
			return "redirect:/user/sign";
		}
	// 회원 가입 성공 시 로그인 페이지로 리다이렉트
		redirectAttr.addFlashAttribute("signSuccess", true);
		return "redirect:/user/login";
		
	}
	//@ResponseBody : 응답 본문에 데이터를 담아 처리
	/*
	 * URL : [GET} /member/checkId?memberId=XXX
	 */
	@GetMapping("/checkId")
	@ResponseBody
	public ApiResponse<Boolean> checkId(String userId) {
		
		boolean isDuplicate = service.isUserIdCheck(userId);
		
		String message = isDuplicate ? "이미 사용중인 아이디입니다." : "사용 가능한 아이디입니다.";
		
		return ApiResponse.success(message, isDuplicate);
	}

	@PostMapping("/login")
	public String login(String userId, String userPwd
			,@RequestParam(required=false) String redirectURL
			, HttpSession session, RedirectAttributes redirectAttr) {
		try {
		UserDTO user = service.login(userId, userPwd);
		
		//로그인 성공 --> 세션에 로그인 정보 저장
		session.setAttribute("loginMember", user);
		}catch(IllegalStateException e) {
			redirectAttr.addFlashAttribute("error", e.getMessage());
			return "redirect:/user/login";
		}
		
		if(redirectURL != null && !redirectURL.isBlank()) {
			return "redirect:" + redirectURL;
		}
		return "redirect:/";
	
	
	}
	@GetMapping("/logout")
	public String logout(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if(session != null) {
			session.invalidate(); //세션 자체 만료
		}
	return "redirect:/user/login";
	}
	@PostMapping("/withdraw")
	public String withdraw(HttpSession session) {
	
	UserDTO loginMember = (UserDTO)session.getAttribute("loginMember");
	//서비스에서 비즈니스 로직 요청
	service.withdraw(loginMember.getUserId());
	//세션 영역 모든 데이터 삭제(세션 만료)
	session.invalidate();
	//메인 페이지 리다이렉트
	return "redirect:/";
	}
	@GetMapping("/mypage")
	public String myPage(HttpSession session, Model model) {
	 
	    // 세션에 저장된 로그인 사용자 번호 꺼내기 (RequestDTO.userNo 와 동일하게 Integer)
	    // SessionConst 에 정의된 키 이름은 실제 프로젝트 값에 맞게 수정 필요
	    Integer userNo = (Integer) session.getAttribute(SessionConst.LOGIN_USER_NO);
	 
	    if (userNo == null) {
	        return "redirect:/user/login";
	    }
	 
	    // 1. 내 정보 조회 - 메서드명은 기존 UserService 에 있는 실제 이름으로 수정
	    //    (예: getUserInfo, findById, getUser 등)
	    UserDTO user = UserService.getUserInfo(userNo);
	 
	    // 2. 내가 등록한 접수 목록 조회
	    List<RequestDTO> requestList = RequestService.getRequestsByUserId(userNo);
	 
	    // 3. 상태별 카운트 계산 (JSP 상단 탭 칩에 쓰는 숫자)
	    // COMMON_CODE(STATUS 그룹) 실제 코드값 기준
	    //   REQ_01 접수대기 / REQ_02 견적중 / REQ_03 매칭완료 / REQ_04 수리완료 / REQ_05 취소
	    int waitingCnt = 0, estimatingCnt = 0, matchedCnt = 0, doneCnt = 0, canceledCnt = 0;
	    for (RequestDTO req : requestList) {
	        String statusCode = req.getStatusCode();
	        if (statusCode == null) continue;
	        switch (statusCode) {
	            case "REQ_01":
	                waitingCnt++;
	                break;
	            case "REQ_02":
	                estimatingCnt++;
	                break;
	            case "REQ_03":
	                matchedCnt++;
	                break;
	            case "REQ_04":
	                doneCnt++;
	                break;
	            case "REQ_05":
	                canceledCnt++;
	                break;
	            default:
	                break;
	        }
	    }
	 
	    model.addAttribute("user", user);
	    model.addAttribute("requestList", requestList);
	    model.addAttribute("waitingCnt", waitingCnt);
	    model.addAttribute("estimatingCnt", estimatingCnt);
	    model.addAttribute("matchedCnt", matchedCnt);
	    model.addAttribute("doneCnt", doneCnt);
	    model.addAttribute("canceledCnt", canceledCnt);
	 
	    return "user/mypage";
	}
	 
}
