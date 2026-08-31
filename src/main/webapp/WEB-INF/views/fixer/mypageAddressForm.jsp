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
</form>


<script>

    function setAlias(value) {
        document.getElementById('aliasInput').value = value;
    }
</script>