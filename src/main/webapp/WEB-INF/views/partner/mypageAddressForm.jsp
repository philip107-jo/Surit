<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- ... (상단 헤더 및 네비게이션 생략) ... -->

<div class="sec-head sec-head--row" style="margin-bottom:24px">
    <div><h2>주소 추가</h2><p>출발 위치 계산에 쓰이는 내 주소입니다. 최대 3개까지 등록할 수 있습니다.</p></div>
</div>

<!-- 폼 전송 액션 -->
<form action="/fixer/mypage/addresses" method="post" class="card">

    <div class="field">
        <label class="field__label">주소 별칭<span class="req">*</span></label>
        <input type="text" name="alias" id="aliasInput" class="input" placeholder="예) 집, 작업실" required>

        <!-- 칩 클릭 시 스크립트로 input 값 채우기 -->
        <div class="chip-row" style="margin-top:12px">
            <button type="button" class="chip" onclick="setAlias('집')">집</button>
            <button type="button" class="chip" onclick="setAlias('작업실')">작업실</button>
            <button type="button" class="chip" onclick="setAlias('사무실')">사무실</button>
        </div>
    </div>

    <div class="field">
        <label class="field__label">우편번호<span class="req">*</span></label>
        <div style="display:flex;gap:12px">
            <input type="text" name="zipcode" id="zipcode" class="input" placeholder="05543" readonly required>
            <!-- 주소 검색 버튼 클릭 시 카카오 API 호출 -->
            <button type="button" class="btn btn--dark" style="flex:0 0 auto" onclick="openKakaoPostcode()">
                <svg class="ico"><use href="#i-search"/></svg>주소 검색
            </button>
        </div>
    </div>

    <div class="field">
        <label class="field__label">기본주소<span class="req">*</span></label>
        <input type="text" name="baseAddress" id="baseAddress" class="input" placeholder="주소 검색으로 입력됩니다" readonly style="background:var(--g-50)" required>
    </div>

    <div class="field">
        <label class="field__label">상세주소</label>
        <input type="text" name="detailAddress" id="detailAddress" class="input" placeholder="동 · 호수 등 나머지 주소를 입력하세요">
    </div>

    <label class="check" style="margin-bottom:26px">
        <!-- 체크 시 'Y' 전송 -->
        <input type="checkbox" name="isDefault" value="Y">이 주소를 기본 주소로 설정합니다
    </label>

    <div class="btn-row">
        <button type="submit" class="btn btn--primary btn--lg">저장하기</button>
        <a class="btn btn--ghost btn--lg" href="/fixer/mypage/addresses">취소</a>
    </div>
</form>

<!-- ... (하단 푸터 생략) ... -->

<!-- ========================================== -->
<!-- 🚀 카카오 우편번호 API 연동 스크립트          -->
<!-- ========================================== -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    // 1. 주소 별칭 칩 클릭 이벤트
    function setAlias(value) {
        document.getElementById('aliasInput').value = value;
    }

    // 2. 카카오 주소 검색 API 팝업
    function openKakaoPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 우편번호와 기본 주소를 input 태그에 쏙 넣어줍니다.
                document.getElementById('zipcode').value = data.zonecode;
                document.getElementById('baseAddress').value = data.address;
                // 상세주소 입력칸으로 포커스 이동
                document.getElementById('detailAddress').focus();
            }
        }).open();
    }
</script>