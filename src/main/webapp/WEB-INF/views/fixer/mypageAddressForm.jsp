<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="sec-head sec-head--row" style="margin-bottom:24px">
    <div><h2>주소 추가</h2><p>출발 위치 계산에 쓰이는 주소입니다. 최대 3개까지 등록할 수 있습니다.</p></div>
</div>

<form action="/fixer/mypage/addresses" method="post" class="card">

    <div class="field">
        <label class="field__label">주소 별칭<span class="req">*</span></label>
        <input type="text" name="alias" id="aliasInput" class="input" placeholder="예) 집, 작업실" required>

        <div class="chip-row" style="margin-top:12px">
            <button type="button" class="chip" onclick="setAlias('집')">집</button>
            <button type="button" class="chip" onclick="setAlias('작업실')">작업실</button>
            <button type="button" class="chip" onclick="setAlias('사무실')">사무실</button>
        </div>
    </div>


    <div class="field">
        <label class="field__label">우편번호<span class="req">*</span></label>
        <input type="text" name="zipcode" id="zipcode" class="input" placeholder="예) 05543" required>
    </div>

    <div class="field">
        <label class="field__label">기본주소<span class="req">*</span></label>
        <input type="text" name="baseAddress" id="baseAddress" class="input" placeholder="예) 서울특별시 강남구 언주로 30" required>
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

    <div class="sec-head" style="margin-top: 32px; margin-bottom: 16px;">
        <h3>활동 지역 설정</h3>
        <p style="color: var(--g-500); font-size: 14px;">수리를 진행하실 주로 활동하는 지역을 입력해 주세요.</p>
    </div>

    <div class="field">
        <label class="field__label">지역 추가</label>
        <div style="display:flex; gap:12px">
            <input type="text" id="regionInput" class="input" placeholder="예) 서울 강남구, 경기 성남시" onkeypress="if(event.keyCode==13) { addRegion(); return false; }">
            <button type="button" class="btn btn--dark" style="flex:0 0 auto" onclick="addRegion()">
                추가
            </button>
        </div>
    </div>

    <!-- 추가된 지역들이 표시될 칩(Chip) 영역 -->
    <div class="chip-row" id="regionChipContainer" style="margin-top: 16px; margin-bottom: 24px;">
        <!-- 기존에 등록된 지역이 있다면 여기에 표시 (JSTL 연동) -->
        <c:forEach var="region" items="${regions}">
        <span class="chip">
            ${region}
            <button type="button" style="margin-left: 8px; border: none; background: none; cursor: pointer;" onclick="removeRegion(this, '${region}')">✖</button>
            <input type="hidden" name="regionList" value="${region}">
        </span>
        </c:forEach>
    </div>

    <!-- ========================================== -->
    <!-- 🚀 활동지역 관리 자바스크립트 (하단에 추가)       -->
    <!-- ========================================== -->
</form>


<script>

    function setAlias(value) {
        document.getElementById('aliasInput').value = value;
    }
    function addRegion() {
        const input = document.getElementById('regionInput');
        const regionValue = input.value.trim();

        if (!regionValue) {
            alert('지역을 입력해 주세요.');
            return;
        }

        const container = document.getElementById('regionChipContainer');

        // 칩(Chip) UI 생성
        const chip = document.createElement('span');
        chip.className = 'chip';
        chip.innerHTML = `
            ${regionValue}
            <button type="button" style="margin-left: 8px; border: none; background: none; cursor: pointer;" onclick="removeRegion(this)">✖</button>
            <input type="hidden" name="regionList" value="${regionValue}">
        `;

        container.appendChild(chip);
        input.value = ''; // 입력창 초기화
    }

    function removeRegion(button, regionName) {
        // 칩 삭제
        const chip = button.parentElement;
        chip.remove();

        // DB에서도 바로 삭제해야 한다면 여기에 AJAX(fetch) 코드를 추가할 수 있습니다.
    }
</script>