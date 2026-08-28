package com.surit.chat.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.surit.chat.dto.ChatRoomDTO;
import com.surit.chat.service.ChatService;
import com.surit.chat.util.ChatLoginResolver;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/support")
@RequiredArgsConstructor
public class SupportController {

	private final ChatService chatService;

	/** 로그인 사용자 번호. testUserNo 는 임시 테스트용 (로그인 연동되면 삭제) */
	private Long resolve(HttpSession session, Long testUserNo) {
		Long myNo = ChatLoginResolver.resolveUserNo(session);
		if (myNo == null && testUserNo != null) {
			myNo = testUserNo;
		}
		return myNo;
	}

	/** 내 문의 목록 + 새 문의 시작 */
	@GetMapping
	public String list(@RequestParam(required = false) Long testUserNo,
	                   HttpSession session, Model model) {

		Long myNo = resolve(session, testUserNo);
		model.addAttribute("testUserNo", testUserNo);

		if (myNo == null) {
			model.addAttribute("msg", "로그인이 필요합니다. (테스트: ?testUserNo=회원번호)");
			return "support/support";
		}

		session.setAttribute(ChatController.CHAT_USER_NO, myNo);

		model.addAttribute("myNo",      myNo);
		model.addAttribute("supportNo", chatService.getSupportUserNo());
		model.addAttribute("rooms",     chatService.getMySupportRooms(myNo));
		model.addAttribute("types",     chatService.getInquiryTypes());
		return "support/support";
	}

	/** 새 문의 만들기 → 바로 채팅방으로 */
	@PostMapping("/new")
	public String create(@RequestParam String categoryCode,
	                     @RequestParam(required = false) Long testUserNo,
	                     HttpSession session) {

		Long myNo = resolve(session, testUserNo);
		if (myNo == null) {
			return "redirect:/support";
		}

		Long roomId = chatService.createSupportRoom(myNo, categoryCode);
		return "redirect:/support/" + roomId
				+ (testUserNo == null ? "" : "?testUserNo=" + testUserNo);
	}

	/** 문의 채팅방 */
	@GetMapping("/{roomId}")
	public String room(@PathVariable Long roomId,
	                   @RequestParam(required = false) Long testUserNo,
	                   HttpSession session, Model model) {

		Long myNo = resolve(session, testUserNo);
		if (myNo == null) {
			model.addAttribute("msg", "로그인이 필요합니다.");
			return "chat/chat";
		}

		ChatRoomDTO room = chatService.getRoom(roomId);
		if (room == null || room.getRequestId() != null) {
			model.addAttribute("msg", "문의방을 찾을 수 없습니다.");
			return "chat/chat";
		}
		if (!chatService.canAccess(roomId, myNo)) {
			model.addAttribute("msg", "이 문의에 접근할 권한이 없습니다.");
			return "chat/chat";
		}

		session.setAttribute(ChatController.CHAT_USER_NO, myNo);
		chatService.markAsRead(roomId, myNo);

		model.addAttribute("room",      room);
		model.addAttribute("myNo",      myNo);
		model.addAttribute("history",   chatService.getHistory(roomId));
		model.addAttribute("roomTitle", "수릿 고객센터");
		model.addAttribute("roomSub",   "1:1 문의 · "
				+ (room.getCategoryName() == null ? "" : room.getCategoryName()));
		model.addAttribute("backUrl",   "/support"
				+ (testUserNo == null ? "" : "?testUserNo=" + testUserNo));
		return "chat/chat";
	}
}