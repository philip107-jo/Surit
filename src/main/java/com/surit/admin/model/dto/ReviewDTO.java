package com.surit.admin.model.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class ReviewDTO {
	private Long reviewId;
	private Long requestId;
	private Long userId;	
	private Long fixerId;
	private int score;
	private String content;
	private LocalDateTime createdAt;
	
}
