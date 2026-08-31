<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<%@ include file="common/icons.jspf" %>
<c:set var="navActive" value="requests"/>

<div class="container" style="max-width:900px">

	<div class="page-head page-head--plain">
		<h1>예상 견적 제시</h1>
		<p>보낸 견적은 고객의 기사 목록에 바로 노출됩니다.</p>
	</div>

	<c:if test="${not empty message}">
		<div class="note note--warn" style="margin-bottom:24px">
			<svg><use href="#i-alert"/></svg>
			<span><c:out value="${message}"/></span>
		</div>
	</c:if>

	<!-- 접수 내용 -->
	<div class="card">
		<div class="card__head"><h2 class="card__title">접수 내용</h2></div>
		<dl class="dl--inline">
			<dt>제목</dt><dd><c:out value="${repair.title}"/></dd>
			<dt>분야</dt><dd><c:out value="${repair.categoryName}"/></dd>
			<dt>주소</dt><dd><c:out value="${repair.serviceAddress}"/></dd>
		</dl>
		<div style="margin-top:20px;padding-top:20px;border-top:1px solid var(--g-100)">
			<div class="field__label" style="margin-bottom:8px">증상</div>
			<p style="font-size:16px;line-height:1.8;color:var(--g-700);white-space:pre-wrap;margin:0"><c:out value="${repair.content}"/></p>
		</div>
	</div>

	<%--
		onsubmit 에서 버튼을 막아도 이번 제출 자체는 그대로 나간다.
		브라우저는 onsubmit 이 true 를 돌려준 뒤에 폼을 전송하기 때문에,
		여기서 disabled 를 걸어도 지금 누른 제출은 막지 않고
		"같은 버튼을 한 번 더 누르는 것"만 막는다.

		다만 이건 실수로 두 번 클릭하는 걸 줄여주는 보조 수단일 뿐이고,
		진짜 중복 방지는 서버(INSERT 의 NOT EXISTS 조건)가 한다.
		자바스크립트가 꺼져 있거나 새로고침으로 다시 보내는 경우까지는 못 막는다.
	--%>
	<form action="/fixer/estimates" method="post" onsubmit="return handleSubmit(this);">

		<%-- CSRF 를 켜둔 프로젝트에서만 토큰이 만들어진다. 없으면 이 줄은 그냥 건너뛴다 --%>
		<c:if test="${not empty _csrf}">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
		</c:if>

		<%--
			requestId 는 화면에 보이지 않게 hidden 으로 넘긴다.
			단, 사용자가 이 값을 바꿔서 보낼 수 있으므로
			서버에서 "내가 볼 수 있는 접수인가" 를 다시 확인한다.
		--%>
		<input type="hidden" name="requestId" value="${repair.requestId}"/>

		<div class="card" style="border-color:var(--p-200)">
			<div class="card__head">
				<h2 class="card__title">견적 입력</h2>
				<span class="muted" style="font-size:15px">현장 확인 후 달라질 수 있는 참고 금액입니다</span>
			</div>

			<div class="field-row">
				<div class="field">
					<label class="field__label" for="estimatedPrice">예상 금액 (원)<span class="req">*</span></label>
					<input class="input" id="estimatedPrice" type="number" name="estimatedPrice"
					       min="0" step="1000" required placeholder="예) 75000">
					<div class="field__help">원 단위 정수로 입력합니다. 최대 1억 원.</div>
				</div>
				<div class="field">
					<label class="field__label" for="estimatedDuration">예상 소요 시간 (분)<span class="req">*</span></label>
					<input class="input" id="estimatedDuration" type="number" name="estimatedDuration"
					       min="1" max="43200" required placeholder="예) 90">
					<div class="field__help">90 = 1시간 30분</div>
				</div>
			</div>

			<div class="field">
				<label class="field__label" for="content">고객에게 한마디<span class="req">*</span></label>
				<textarea class="textarea" id="content" name="content" rows="6" maxlength="1000" required
					placeholder="어떤 작업을 하는지, 부품값이 포함인지 등을 적어주세요."></textarea>
			</div>

			<div class="note note--gray" style="margin-bottom:22px">
				<svg><use href="#i-alert"/></svg>
				<span>지금 보내는 금액은 <b>확정 금액이 아닙니다.</b> 고객이 회원님을 선택하면
				내 작업 화면에서 연락처와 방문 주소가 열립니다.</span>
			</div>

			<div class="btn-row">
				<a class="btn btn--ghost btn--lg" href="/fixer/requests/${repair.requestId}">취소</a>
				<button type="submit" id="submitBtn" class="btn btn--primary btn--xl" style="flex:1">
					<svg class="ico"><use href="#i-send"/></svg>견적 제출</button>
			</div>
		</div>

	</form>

</div>

<script>
function handleSubmit(form) {
	var btn = document.getElementById('submitBtn');

	// 이미 한 번 눌러서 비활성화된 상태면 더 이상 못 누르게 막는다
	if (btn.disabled) {
		return false;
	}

	btn.disabled = true;
	btn.textContent = '제출 중...';

	return true; // 폼은 그대로 전송한다
}
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
