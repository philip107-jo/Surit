<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<%@ include file="common/icons.jspf" %>
<c:set var="navActive" value="fixerMypage"/>

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

<div class="container" style="max-width:900px">

    <div class="page-head page-head--plain">
        <h1>수리 정보 관리</h1>
        <p>여기서 고른 카테고리와 지역의 접수만 <b>내 주변 새 접수</b>에 올라옵니다.</p>
    </div>

    <%@ include file="common/fixernav.jspf" %>

    <!-- 1. 수리 가능 카테고리 카드 -->
    <form action="/fixer/mypage/categories" method="post" class="card" style="margin-bottom: 24px;">
        <%-- CSRF 토큰 (400 에러 방지) --%>
        <c:if test="${not empty _csrf}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </c:if>

        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
            <h3 style="font-size:18px; margin:0;">수리 가능 카테고리</h3>
            <span style="color:var(--g-500); font-size:14px;"><span id="catCount">0</span>개 선택됨</span>
        </div>

        <div class="chip-row" style="margin-bottom:16px; gap:8px;">
            <c:forEach var="cat" items="${categoryList}">
                <label>
                    <input type="checkbox" name="categories" value="${cat.codeId}" class="chip-checkbox cat-checkbox"
                           onchange="countCatChecked()"
                           <c:if test="${fn:contains(myCategories, cat.codeId)}">checked</c:if>>
                    <span class="chip-label"><c:out value="${cat.codeName}"/></span>
                </label>
            </c:forEach>
        </div>
        <p style="color:var(--g-500); font-size:13px; margin-bottom:20px;">선택을 해제하면 해당 품목의 새 접수 알림이 오지 않습니다.</p>
        <button type="submit" class="btn btn--primary">카테고리 저장</button>
    </form>

    <!-- 2. 활동 가능 지역 카드 -->
    <form action="/fixer/mypage/regions" method="post" id="regionForm" class="card">
        <%-- CSRF 토큰 (400 에러 방지) --%>
        <c:if test="${not empty _csrf}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </c:if>

        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
            <h3 style="font-size:18px; margin:0;">활동 가능 지역</h3>
            <span style="color:var(--g-500); font-size:14px;"><span id="regionCountUI">0</span> / 5</span>
        </div>

        <p style="font-size:15px; font-weight:500; margin-bottom:12px;">선택 가능한 지역 (최대 5개)</p>

        <div class="chip-row" style="margin-bottom:20px; gap:8px;">
            <c:forEach var="region" items="${regionList}">
                <label>
                    <input type="checkbox" name="regions" value="${region.codeId}" class="chip-checkbox region-checkbox"
                           onchange="countRegionChecked(this)"
                           <c:if test="${fn:contains(myRegions, region.codeId)}">checked</c:if>>
                    <span class="chip-label"><c:out value="${region.codeName}"/></span>
                </label>
            </c:forEach>
        </div>

        <button type="submit" class="btn btn--primary">지역 저장</button>
    </form>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script>
    function countCatChecked() {
        const checkboxes = document.querySelectorAll('.cat-checkbox:checked');
        document.getElementById('catCount').innerText = checkboxes.length;
    }

    function countRegionChecked(target) {
        const checkboxes = document.querySelectorAll('.region-checkbox:checked');
        if (checkboxes.length > 5) {
            alert('활동 지역은 최대 5개까지만 선택할 수 있습니다.');
            target.checked = false;
            return;
        }
        document.getElementById('regionCountUI').innerText = checkboxes.length;
    }

    document.addEventListener("DOMContentLoaded", function() {
        countCatChecked();
        document.getElementById('regionCountUI').innerText = document.querySelectorAll('.region-checkbox:checked').length;
    });
</script>