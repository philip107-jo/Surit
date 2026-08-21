package com.surit.admin.model.dto;

import java.time.LocalDateTime;

public class SanctionDTO {
	private Long sanctionId;
	private Long targetId;
	private String sanctionType;
	private String sanctionReason;
	private LocalDateTime startAt;
	private LocalDateTime endAt;
	private LocalDateTime releasedAt;
	private String adminId;
}
