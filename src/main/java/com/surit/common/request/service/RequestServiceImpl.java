package com.surit.common.request.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.surit.common.model.dto.CommonCodeDTO;
import com.surit.common.model.mapper.CommonCodeMapper;
import com.surit.common.request.model.dto.RequestDTO;
import com.surit.common.request.model.mapper.RequestMapper;
import com.surit.fixer.common.FixerGuard;
import com.surit.fixer.estimate.model.dto.EstimateDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RequestServiceImpl implements RequestService {

    private final RequestMapper mapper;
    private final CommonCodeMapper codeMapper;
    private final FixerGuard fixerGuard;


    // ========================================
    // 카테고리 목록
    // ========================================

    @Override
    public List<CommonCodeDTO> getCategoryList() {
        return codeMapper.selectByGroup("CATEGORY");
    }


    // ========================================
    // 방문 시간대 목록
    // ========================================

    @Override
    public List<CommonCodeDTO> getVisitTimeList() {
        return codeMapper.selectByGroup("VISIT_TIME");
    }


    // ========================================
    // 기사 - 주변 접수 목록
    // ========================================

    @Override
    @Transactional(readOnly = true)
    public List<RequestDTO> getNearbyRequests(
            Long userNo,
            String categoryCode,
            String keyword) {

        fixerGuard.requireApprovedFixer(userNo);

        return mapper.selectNearbyRequests(
                userNo,
                trimToNull(categoryCode),
                trimToNull(keyword)
        );
    }


    // ========================================
    // 기사 - 접수 상세
    // ========================================

    @Override
    @Transactional(readOnly = true)
    public RequestDTO getRequestDetail(
            Long userNo,
            Long requestId) {

        fixerGuard.requireApprovedFixer(userNo);

        RequestDTO request =
                mapper.selectRequestDetail(
                        userNo,
                        requestId
                );

        if (request == null) {
            throw new IllegalStateException(
                    "볼 수 없는 접수입니다."
            );
        }

        request.setPhotos(
                mapper.selectPhotos(requestId)
        );

        return request;
    }


    // ========================================
    // 고객 - 내 접수 목록
    // ========================================

    @Override
    @Transactional(readOnly = true)
    public List<RequestDTO> getRequestsByUserId(
            Long userNo) {

        return mapper.findByUserId(userNo);
    }


    // ========================================
    // 문자열 정리
    // ========================================

    private String trimToNull(String s) {

        if (s == null || s.isBlank()) {
            return null;
        }

        return s.trim();
    }


    // ========================================
    // 고객 - 매칭 화면용 접수 조회
    // ========================================

    @Override
    @Transactional(readOnly = true)
    public RequestDTO getRequestForMatching(
            Long userNo,
            Long requestId) {

        RequestDTO request =
                mapper.selectRequestForCustomer(
                        userNo,
                        requestId
                );

        if (request == null) {
            throw new IllegalStateException(
                    "볼 수 없는 접수입니다."
            );
        }

        return request;
    }


    // ========================================
    // 고객 - 견적 목록 조회
    // ========================================

    @Override
    @Transactional(readOnly = true)
    public List<EstimateDTO> getEstimatesForMatching(
            Long requestId) {

        return mapper.selectEstimatesByRequestId(
                requestId
        );
    }


    // ========================================
    // 고객 - 기사 선택
    // ========================================

    @Override
    @Transactional
    public void selectEstimate(
            Long userNo,
            Long requestId,
            Long estimateId) {

        RequestDTO request =
                mapper.selectRequestForCustomer(
                        userNo,
                        requestId
                );

        if (request == null) {
            throw new IllegalStateException(
                    "볼 수 없는 접수입니다."
            );
        }

        mapper.updateRequestStatus(
                requestId,
                "REQ_03"
        );

        mapper.updateSelectedEstimate(
                requestId,
                estimateId
        );
    }


    // ========================================
    // 고객 - 접수 등록
    // ========================================

    @Override
    @Transactional
    public void createRequest(
            RequestDTO request) {

        request.setStatusCode("REQ_01");

        System.out.println("===== 접수 INSERT =====");
        System.out.println(
                "userNo = " + request.getUserNo()
        );
        System.out.println(
                "categoryCode = " + request.getCategoryCode()
        );
        System.out.println(
                "title = " + request.getTitle()
        );
        System.out.println(
                "content = " + request.getContent()
        );
        System.out.println(
                "serviceAddress = "
                        + request.getServiceAddress()
        );
        System.out.println(
                "statusCode = "
                        + request.getStatusCode()
        );

        Long result =
                mapper.insertRequest(request);

        System.out.println(
                "INSERT RESULT = " + result
        );

        if (result == null || result != 1L) {
            throw new IllegalStateException(
                    "수리 접수 등록에 실패했습니다."
            );
        }
    }


    // ========================================
    // 고객 - 접수 수정
    // ========================================

    @Override
    @Transactional
    public void updateRequest(
            Long userNo,
            RequestDTO request) {

        RequestDTO existing =
                mapper.selectRequestForCustomer(
                        userNo,
                        request.getRequestId()
                );

        if (existing == null) {
            throw new IllegalStateException(
                    "수정할 수 없는 접수입니다."
            );
        }


        // 이미 기사 선택이 끝난 접수는 수정 불가
        if (!"REQ_01".equals(existing.getStatusCode())
                && !"REQ_02".equals(existing.getStatusCode())) {

            throw new IllegalStateException(
                    "이미 매칭된 접수는 수정할 수 없습니다."
            );
        }


        // 로그인 회원번호 강제 설정
        request.setUserNo(userNo);


        Long result =
                mapper.updateCustomerRequest(request);


        if (result == null || result != 1L) {
            throw new IllegalStateException(
                    "접수 수정에 실패했습니다."
            );
        }
    }


    // ========================================
    // 고객 - 접수 취소
    // ========================================

    @Override
    @Transactional
    public void cancelRequest(
            Long userNo,
            Long requestId) {

        RequestDTO existing =
                mapper.selectRequestForCustomer(
                        userNo,
                        requestId
                );

        if (existing == null) {
            throw new IllegalStateException(
                    "취소할 수 없는 접수입니다."
            );
        }


        // 접수대기 / 기사매칭 중일 때만 취소 가능
        if (!"REQ_01".equals(existing.getStatusCode())
                && !"REQ_02".equals(existing.getStatusCode())) {

            throw new IllegalStateException(
                    "이미 매칭된 접수는 취소할 수 없습니다."
            );
        }


        Long result =
                mapper.cancelCustomerRequest(
                        requestId,
                        userNo,
                        "REQ_05"
                );


        if (result == null || result != 1L) {
            throw new IllegalStateException(
                    "접수 취소에 실패했습니다."
            );
        }
    }

}