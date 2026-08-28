package com.surit.chat.service;

import java.util.List;

import com.surit.chat.dto.ChatMessageDTO;
import com.surit.chat.dto.ChatRoomDTO;
import com.surit.chat.dto.CodeDTO;

public interface ChatService {

	/* 고객 ↔ 기사 */
	ChatRoomDTO getOrCreateRoomByRequest(Long requestId);
	ChatRoomDTO getRoom(Long roomId);
	boolean canAccess(Long roomId, Long userNo);
	List<ChatRoomDTO> getMyRooms(Long userNo);

	/* 고객 ↔ 고객센터 (F-26 문의) */
	Long getSupportUserNo();
	List<CodeDTO> getInquiryTypes();
	List<ChatRoomDTO> getMySupportRooms(Long userNo);
	List<ChatRoomDTO> getSupportRooms(String filter, Long supportNo);
	Long createSupportRoom(Long userNo, String categoryCode);

	/* 메시지 공통 */
	List<ChatMessageDTO> getHistory(Long roomId);
	void saveMessage(ChatMessageDTO message);
	void markAsRead(Long roomId, Long readerNo);
}