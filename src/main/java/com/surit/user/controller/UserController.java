package com.surit.user.controller;

import java.io.IOException;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.surit.common.ApiResponse;
import com.surit.user.dto.UserDTO;
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
	@GetMapping("/mypage")
	public String mypage() {
		return "user/mypage";
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
	

}
