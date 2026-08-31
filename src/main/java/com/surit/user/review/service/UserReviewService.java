package com.surit.user.review.service;
 
import java.util.List;

import com.surit.user.model.dto.UserReviewDTO;
 
public interface UserReviewService {
 
    /** 특정 고객이 작성한 리뷰 목록 조회 */
    List<UserReviewDTO> getReviewsByUserNo(Long userNo);
}