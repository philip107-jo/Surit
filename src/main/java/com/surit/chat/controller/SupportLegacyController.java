package com.surit.chat.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * 옛날 주소 정리용.
 *
 * 고객센터가 /support → /user/mypage/support 로 옮겨졌다.
 * 예전 주소를 즐겨찾기 해뒀거나 다른 JSP 에 링크가 남아 있어도
 * 404 가 아니라 새 주소로 넘어가게 해준다.
 *
 * 나중에 예전 링크가 전부 정리되면 이 파일은 지워도 된다.
 */
@Controller
public class SupportLegacyController {

	@GetMapping("/support")
	public String legacySupport() {
		return "redirect:/user/mypage/support";
	}

	/** user/support.jsp 의 옛 버튼이 가리키던 주소 */
	@GetMapping("/chat")
	public String legacyChat() {
		return "redirect:/user/mypage/support";
	}
}
