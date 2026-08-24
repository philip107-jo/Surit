package com.surit.admin.model.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class ChatRoomDTO {
	private Long roomId;
	private	String roomType;
	private Long requestId;
	private Long userId;
	private Long fixerId;
	private String categoryCode;
	private LocalDateTime createdAt;
}
