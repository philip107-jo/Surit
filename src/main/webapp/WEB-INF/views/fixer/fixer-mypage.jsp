<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>수리 정보 관리 | 수릿 Surit</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
<style>

    .chip-checkbox { display: none; }
    .chip-label {
        display: inline-flex; align-items: center; justify-content: center;
        padding: 8px 16px; border-radius: 20px; border: 1px solid var(--g-200);
        background: #fff; color: var(--g-600); cursor: pointer;
        font-size: 14px; transition: all 0.2s; user-select: none;
    }
    .chip-checkbox:checked + .chip-label {
        border-color: #3b82f6; color: #3b82f6; font-weight: 500;
    }
</style>
</head>
<body>


<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main>
<div class="container">

  <div class="page-head page-head--plain">
    <h1>마이페이지 (기사)</h1>
  </div>

  <div class="with-side">


    <nav class="side-nav">
      <a href="${pageContext.request.contextPath}/fixer/mypage/jobs">
        <svg class="ico"><use href="#i-list"/></svg>내 작업
      </a>
      <a href="${pageContext.request.contextPath}/fixer/verify">
        <svg class="ico"><use href="#i-star"/></svg>기사 인증
      </a>
      <!-- 현재 페이지 활성화 (is-active) -->
      <a href="${pageContext.request.contextPath}/fixer/mypage/repair-info" class="is-active">
        <svg class="ico"><use href="#i-refresh"/></svg>수리 정보 관리
      </a>
      <a href="${pageContext.request.contextPath}/fixer/mypage/address">
        <svg class="ico"><use href="#i-home"/></svg>주소 관리
      </a>
      <a href="${pageContext.request.contextPath}/fixer/mypage/profile">
        <svg class="ico"><use href="#i-user"/></svg>내 정보 수정
      </a>
      <a href="${pageContext.request.contextPath}/fixer/mypage/support">
        <svg class="ico"><use href="#i-chat"/></svg>고객센터
      </a>
    </nav>


    <div>
      <div class="sec-head" style="margin-bottom:24px">
        <h2>수리 정보 관리</h2>
        <p style="color:var(--g-500); font-size:15px; margin-top:8px;">
            여기서 고른 카테고리와 지역의 접수만 <b>접수 찾기</b>에 올라옵니다.
        </p>
      </div>

      <!-- 1. 수리 가능 카테고리 카드 -->
      <form action="/fixer/mypage/categories" method="post" class="card" style="margin-bottom: 24px;">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
            <h3 style="font-size:18px; margin:0;">수리 가능 카테고리</h3>
            <span style="color:var(--g-500); font-size:14px;"><span id="catCount">0</span>개 선택됨</span>
        </div>

        <div class="chip-row" style="margin-bottom:16px; gap:8px;">
            <!-- 백엔드 연동 전 화면 테스트를 위한 하드코딩 샘플 -->
            <label><input type="checkbox" name="categories" value="1" class="chip-checkbox" onchange="countChecked()"><span class="chip-label">도어락·잠금</span></label>
            <label><input type="checkbox" name="categories" value="2" class="chip-checkbox" onchange="countChecked()"><span class="chip-label">냉장고</span></label>
            <label><input type="checkbox" name="categories" value="3" class="chip-checkbox" onchange="countChecked()"><span class="chip-label">PC·노트북</span></label>
            <label><input type="checkbox" name="categories" value="4" class="chip-checkbox" onchange="countChecked()"><span class="chip-label">배관·누수</span></label>
            <label><input type="checkbox" name="categories" value="5" class="chip-checkbox" onchange="countChecked()"><span class="chip-label">전기·조명</span></label>
            <label><input type="checkbox" name="categories" value="6" class="chip-checkbox" onchange="countChecked()"><span class="chip-label">세탁기·건조기</span></label>
            <label><input type="checkbox" name="categories" value="7" class="chip-checkbox" onchange="countChecked()"><span class="chip-label">에어컨·보일러</span></label>
            <label><input type="checkbox" name="categories" value="8" class="chip-checkbox" onchange="countChecked()"><span class="chip-label">가구·조립</span></label>
            <label><input type="checkbox" name="categories" value="9" class="chip-checkbox" onchange="countChecked()"><span class="chip-label">TV·모니터</span></label>
            <label><input type="checkbox" name="categories" value="10" class="chip-checkbox" onchange="countChecked()"><span class="chip-label">기타</span></label>
        </div>

        <p style="color:var(--g-500); font-size:13px; margin-bottom:20px;">선택을 해제하면 해당 품목의 새 접수 알림이 오지 않습니다.</p>
        <button type="submit" class="btn btn--primary">카테고리 저장</button>
      </form>

      <!-- 2. 활동 가능 지역 카드 -->
      <div class="card">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
            <h3 style="font-size:18px; margin:0;">활동 가능 지역</h3>
            <span style="color:var(--g-500); font-size:14px;"><span id="regionCountUI">0</span> / 5</span>
        </div>

        <p style="font-size:15px; font-weight:500; margin-bottom:12px;">등록된 지역</p>

        <!-- 추가된 지역 칩 영역 -->
        <form action="/fixer/mypage/regions" method="post" id="regionForm">
            <div class="chip-row" id="regionChipContainer" style="margin-bottom: 20px;">
                <!-- JS로 지역이 추가되는 곳 -->
            </div>

            <div class="field" style="margin-bottom:0;">
                <div style="display:flex; gap:8px">
                    <input type="text" id="regionInput" class="input" placeholder="예) 서울 강남구" onkeypress="if(event.keyCode==13) { addRegion(); return false; }">
                    <button type="button" class="btn btn--dark" style="flex:0 0 auto" onclick="addRegion()">추가</button>
                    <button type="submit" class="btn btn--primary" style="flex:0 0 auto">지역 저장</button>
                </div>
            </div>
        </form>
      </div>

    </div>
  </div>
</div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script>
    // 1. 카테고리 선택 개수 카운트 스크립트
    function countChecked() {
        const checkboxes = document.querySelectorAll('.chip-checkbox:checked');
        document.getElementById('catCount').innerText = checkboxes.length;
    }
    // 페이지 로드 시 초기 카운트 설정
    document.addEventListener("DOMContentLoaded", countChecked);

    // 2. 활동 지역 스크립트 (최대 5개 제한 포함)
    let regionCount = 0;
    const MAX_REGIONS = 5;

    function addRegion() {
        if (regionCount >= MAX_REGIONS) {
            alert('활동 지역은 최대 5개까지만 등록할 수 있습니다.');
            return;
        }

        const input = document.getElementById('regionInput');
        const regionValue = input.value.trim();

        if (!regionValue) return;

        const container = document.getElementById('regionChipContainer');
        const chip = document.createElement('span');
        chip.className = 'chip';
        chip.style.border = '1px solid #e5e7eb';
        chip.innerHTML = `
            \${regionValue}
            <button type="button" style="margin-left: 8px; border: none; background: none; cursor: pointer; color: #9ca3af;" onclick="removeRegion(this)">✖</button>
            <input type="hidden" name="regions" value="\${regionValue}">
        `;

        container.appendChild(chip);
        input.value = '';

        regionCount++;
        document.getElementById('regionCountUI').innerText = regionCount;
    }

    function removeRegion(button) {
        button.parentElement.remove();
        regionCount--;
        document.getElementById('regionCountUI').innerText = regionCount;
    }
</script>
</body>
</html>