package com.surit.admin.model.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class ChatMessageDTO {
	
	private Long messageId;
	private Long roomId;
	private Long senderId;
	private String messageType;
	private String content; 
	private String filePath;
	private LocalDateTime sentAt;
	private LocalDateTime readAt;
	
}
