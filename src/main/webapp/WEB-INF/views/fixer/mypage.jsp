<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- 1. 팀 공통 헤더와 아이콘 불러오기 --%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<%@ include file="common/icons.jspf" %>

<%-- 2. 현재 활성화된 탭 지정 (fixernav.jspf와 연동) --%>
<c:set var="navActive" value="fixerMypage"/>

<style>
    /* 칩 선택 디자인 유지 */
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

<!-- 팀 규격에 맞춘 중앙 정렬 컨테이너 -->
<div class="container" style="max-width:900px">

    <div class="page-head page-head--plain">
        <h1>수리 정보 관리</h1>
        <p>여기서 고른 카테고리와 지역의 접수만 <b>내 주변 새 접수</b>에 올라옵니다.</p>
    </div>

    <%-- 3. 기사 공통 가로 탭 네비게이션 삽입 --%>
    <%@ include file="common/fixernav.jspf" %>

    <!-- ============================================== -->
    <!-- 본문 영역 (수리 카테고리 & 활동 지역) -->
    <!-- ============================================== -->

    <!-- 수리 가능 카테고리 카드 -->
    <form action="/fixer/mypage/categories" method="post" class="card" style="margin-bottom: 24px;">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
            <h3 style="font-size:18px; margin:0;">수리 가능 카테고리</h3>
            <span style="color:var(--g-500); font-size:14px;"><span id="catCount">0</span>개 선택됨</span>
        </div>

        <div class="chip-row" style="margin-bottom:16px; gap:8px;">
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

    <!-- 활동 가능 지역 카드 -->
    <div class="card">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
            <h3 style="font-size:18px; margin:0;">활동 가능 지역</h3>
            <span style="color:var(--g-500); font-size:14px;"><span id="regionCountUI">0</span> / 5</span>
        </div>

        <p style="font-size:15px; font-weight:500; margin-bottom:12px;">등록된 지역</p>

        <form action="/fixer/mypage/regions" method="post" id="regionForm">
            <div class="chip-row" id="regionChipContainer" style="margin-bottom: 20px;">
                <!-- JS로 추가된 지역이 들어가는 곳 -->
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

<%-- 4. 팀 공통 푸터 불러오기 --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script>
    function countChecked() {
        const checkboxes = document.querySelectorAll('.chip-checkbox:checked');
        document.getElementById('catCount').innerText = checkboxes.length;
    }
    document.addEventListener("DOMContentLoaded", countChecked);

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