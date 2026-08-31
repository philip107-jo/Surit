<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container" style="max-width: 600px; margin: 0 auto; padding-top: 30px;">
    <h2>내 활동 지역 (주소 관리)</h2>
    <p style="color: gray;">고객과 매칭될 기준이 되는 활동 주소를 입력해 주세요.</p>

    <hr>

    <form id="addressForm" action="/fixer/mypage/address" method="post">

        <!-- 기본 주소 입력 -->
        <div style="margin-bottom: 20px;">
            <label for="address" style="font-weight: bold; margin-bottom: 8px; display: block;">
                기본 주소 <span style="color:red">*</span>
            </label>
            <input type="text" id="address" name="address" class="form-control"
                   value="${fixerInfo.address}"
                   placeholder="예: 서울특별시 강남구 역삼동" required>
            <small style="color: gray;">시/군/구 동까지 정확하게 입력해 주세요.</small>
        </div>

        <!-- 상세 주소 입력 -->
        <div style="margin-bottom: 30px;">
            <label for="detailAddress" style="font-weight: bold; margin-bottom: 8px; display: block;">
                상세 주소 <span style="color:red">*</span>
            </label>
            <input type="text" id="detailAddress" name="detailAddress" class="form-control"
                   value="${fixerInfo.detailAddress}"
                   placeholder="예: 수릿오피스텔 302호" required>
        </div>

        <div style="text-align: center;">
            <button type="button" class="btn btn-primary btn-lg" style="width: 100%;" onclick="saveAddress()">
                주소 저장하기
            </button>
        </div>

    </form>
</div>

<!-- ========================================== -->
<!-- 🚀 자바스크립트 영역 (JS)                    -->
<!-- ========================================== -->
<script>
    function saveAddress() {
        const addressInput = document.getElementById('address');
        const detailAddressInput = document.getElementById('detailAddress');

        // 1. 빈 값 검사 (유효성 체크)
        if (addressInput.value.trim() === '') {
            alert('기본 주소를 입력해 주세요.');
            addressInput.focus();
            return;
        }

        if (detailAddressInput.value.trim() === '') {
            alert('상세 주소를 입력해 주세요.');
            detailAddressInput.focus();
            return;
        }

        // 2. 저장 확인 및 제출
        if (confirm('이 주소로 활동 지역을 설정하시겠습니까?')) {
            document.getElementById('addressForm').submit();
        }
    }
</script>