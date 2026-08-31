package com.surit.user.review.model.mapper;
 
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.surit.user.model.dto.UserReviewDTO;
 
@Mapper
public interface UserReviewMapper {
 
    /** 특정 고객이 작성한 리뷰 목록 (최신순) */
    List<UserReviewDTO> selectReviewsByUserNo(@Param("userNo") Long userNo);
}
 