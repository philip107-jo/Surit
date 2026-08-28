package com.surit.chat.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import com.surit.chat.dto.ChatRoomDTO;
import com.surit.chat.service.ChatService;
import com.surit.chat.util.ChatLoginResolver;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ChatController {

	private final ChatService chatService;

	/** 이 키로 세션에 담아두면 WebSocket 핸드셰이크 때 그대로 넘어간다 */
	public static final String CHAT_USER_NO = "CHAT_USER_NO";

	@GetMapping("/orders/{requestId}/chat")
	public String chatPage(@PathVariable Long requestId,
	                       @RequestParam(required = false) Long testUserNo,
	                       HttpSession session,
	                       Model model) {

		model.addAttribute("requestId", requestId);

		Long myNo = ChatLoginResolver.resolveUserNo(session);

		// ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
		//  임시 테스트용 뒷문 — 로그인 연동이 끝나면 이 3줄 반드시 삭제!
		//  주소에 ?testUserNo=3 을 붙이면 3번 회원인 척 들어간다.
		//  안 지우면 아무나 남의 채팅방을 열어볼 수 있다.
		if (myNo == null && testUserNo != null) {
			myNo = testUserNo;
		}
		// ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★

		if (myNo == null) {
			model.addAttribute("msg",
					"로그인이 필요합니다. (테스트: 주소 뒤에 ?testUserNo=회원번호 를 붙여보세요)");
			return "chat/chat";
		}

		ChatRoomDTO room = chatService.getOrCreateRoomByRequest(requestId);

		if (room == null) {
			model.addAttribute("msg",
					"채팅방이 없습니다. 접수번호 " + requestId
					+ " 에 배정된 기사가 있는지 확인하세요. (ESTIMATES.STATUS='SELECTED')");
			model.addAttribute("myNo", myNo);
			return "chat/chat";
		}

		// ★ 남의 방 훔쳐보기 차단
		if (!chatService.canAccess(room.getRoomId(), myNo)) {
			model.addAttribute("msg",
					"이 채팅방에 참여할 권한이 없습니다. (내 번호 " + myNo
					+ " / 방 고객 " + room.getUserNo()
					+ " / 방 기사 " + room.getFixerNo() + ")");
			model.addAttribute("myNo", myNo);
			return "chat/chat";
		}

		// WebSocket 이 "누가 보냈는지" 판단할 근거
		session.setAttribute(CHAT_USER_NO, myNo);

		chatService.markAsRead(room.getRoomId(), myNo);

		model.addAttribute("room",    room);
		model.addAttribute("myNo",    myNo);
		model.addAttribute("history", chatService.getHistory(room.getRoomId()));

		return "chat/chat";
	}
}