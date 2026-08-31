
package com.surit.user.review.service;
 
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.surit.user.model.dto.UserReviewDTO;
import com.surit.user.review.model.mapper.UserReviewMapper;

import lombok.RequiredArgsConstructor;
 
@Service
@RequiredArgsConstructor
public class UserReviewServiceImpl implements UserReviewService {
 
    private final UserReviewMapper mapper;
 
    @Override
    @Transactional(readOnly = true)
    public List<UserReviewDTO> getReviewsByUserNo(Long userNo) {
        return mapper.selectReviewsByUserNo(userNo);
    }
}
 