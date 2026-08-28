package com.surit.request.model.dto;

import java.sql.Timestamp;
import java.util.List;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * REPAIR_REQUESTS 한 줄 + 화면에 같이 보여줄 조인 결과.
 *
 * REQUEST_ID 는 IDENTITY 라 INSERT 할 때 넣지 않는다.
 */
@Getter
@Setter
@NoArgsConstructor
public class RepairRequestDTO {

	// ---- REPAIR_REQUESTS 컬럼 ----
	private Long      requestId;
	private Long      userNo;          // 의뢰한 고객
	private String    categoryCode;
	private String    title;
	private String    content;
	private String    serviceAddress;
	private String    statusCode;
	private Timestamp createdAt;

	// ---- 조인해서 가져오는 값 ----
	private String  categoryName;      // COMMON_CODE.CODE_NAME
	private String  statusName;        // COMMON_CODE.CODE_NAME
	private String  customerName;      // USERS.NAME
	private Long    estimateCount;     // 이 접수에 달린 견적 수

	/**
	 * 내가 이미 이 접수에 견적을 냈으면 그 ESTIMATE_ID, 아니면 null.
	 * 목록에서 접수 하나마다 따로 조회하면 N+1 이 되니까
	 * 목록 SQL 안에서 스칼라 서브쿼리로 한 번에 가져온다.
	 */
	private Long myEstimateId;

	// ---- 상세 화면에서만 채운다 ----
	private List<RepairPhotoDTO> photos;
}
