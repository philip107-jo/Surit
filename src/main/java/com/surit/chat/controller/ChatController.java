package com.surit.chat.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

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

	/*
	 * 2026-08-31 : 임시 테스트용 뒷문(?testUserNo=회원번호) 제거.
	 *   주소에 숫자 하나만 붙이면 로그인 없이 남의 채팅방을 열 수 있었다.
	 *   메시지를 암호화해놓고 이 문이 열려 있으면 아무 의미가 없다.
	 *   로그인 연동은 끝나 있으므로 세션만 본다.
	 *     UserController → session.setAttribute("loginMember", UserDTO)
	 *     ChatLoginResolver → loginMember 를 읽어 getUserNo() 호출
	 *
	 *   한 PC 에서 고객·기사 두 명을 테스트하려면 시크릿 창(Ctrl+Shift+N)을 쓴다.
	 *   창마다 세션이 따로 잡힌다.
	 */
	@GetMapping("/orders/{requestId}/chat")
	public String chatPage(@PathVariable Long requestId,
	                       HttpSession session,
	                       Model model) {

		model.addAttribute("requestId", requestId);

		Long myNo = ChatLoginResolver.resolveUserNo(session);

		if (myNo == null) {
			// 로그인 후 원래 가려던 채팅방으로 되돌아오게 한다
			return "redirect:/user/login?redirectURL=/orders/" + requestId + "/chat";
		}

		// ★ 화면 왼쪽 채팅방 목록.
		//   새 SQL 없이 기존 getMyRooms 를 그대로 쓴다.
		//   아래 어느 경로로 빠지든 목록은 보여야 하므로 여기서 미리 담는다.
		model.addAttribute("showSide",  true);
		model.addAttribute("sideRooms", chatService.getMyRooms(myNo));
		model.addAttribute("backUrl",   "/user/mypage");
		model.addAttribute("backText",  "마이페이지로 돌아가기");

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