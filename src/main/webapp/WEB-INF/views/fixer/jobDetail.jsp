<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<%@ include file="common/icons.jspf" %>
<c:set var="navActive" value="jobs"/>

<div class="container" style="max-width:900px">

	<div class="page-head page-head--plain">
		<h1><c:out value="${job.title}"/>
			<c:choose>
				<c:when test="${job.statusCode eq 'REQ_04'}">
					<span class="badge st-done"><c:out value="${job.statusName}"/></span>
				</c:when>
				<c:otherwise>
					<span class="badge st-repairing"><c:out value="${job.statusName}"/></span>
				</c:otherwise>
			</c:choose>
		</h1>
		<p>접수번호 ${job.requestId} ·
			<fmt:formatDate value="${job.createdAt}" pattern="yyyy-MM-dd HH:mm"/> 접수</p>
	</div>

	<c:if test="${not empty message}">
		<div class="note note--blue" style="margin-bottom:24px">
			<svg><use href="#i-bell"/></svg>
			<span><c:out value="${message}"/></span>
		</div>
	</c:if>

	<!-- 접수 정보 -->
	<div class="card">
		<div class="card__head"><h2 class="card__title">접수 정보</h2></div>
		<dl class="dl--inline">
			<dt>분야</dt><dd><c:out value="${job.categoryName}"/></dd>
			<dt>상태</dt><dd><c:out value="${job.statusName}"/></dd>
		</dl>
		<div style="margin-top:20px;padding-top:20px;border-top:1px solid var(--g-100)">
			<div class="field__label" style="margin-bottom:8px">증상</div>
			<p style="font-size:16px;line-height:1.8;color:var(--g-700);white-space:pre-wrap;margin:0"><c:out value="${job.content}"/></p>
		</div>
	</div>

	<!-- 고객 / 방문지 -->
	<%--
		연락처와 방문 주소는 내 작업으로 확정된 뒤에만 보인다.
		접수 목록·상세(F-15)에는 고객 이름만 있고 전화번호가 없다.
	--%>
	<div class="card">
		<div class="card__head">
			<h2 class="card__title">고객 · 방문지</h2>
			<span class="muted" style="font-size:15px">매칭된 뒤에만 보입니다</span>
		</div>
		<div style="display:flex;align-items:center;gap:20px;margin-bottom:22px">
			<span class="avatar avatar--lg"><svg><use href="#i-user"/></svg></span>
			<div>
				<div style="font-size:21px;font-weight:700"><c:out value="${job.customerName}"/> 고객님</div>
				<div class="muted" style="font-size:16px;margin-top:4px"><c:out value="${job.customerPhone}"/></div>
			</div>
			<%-- 이 화면은 "내 견적이 채택된 건" 만 열리므로 채팅 상대가 항상 있다.
			     전화 대신 채팅으로 유도해야 번호가 덜 노출된다. --%>
			<a class="btn btn--primary" style="margin-left:auto"
			   href="/orders/${job.requestId}/chat">고객과 채팅</a>
		</div>
		<dl class="dl--inline">
			<dt>방문 주소</dt><dd><c:out value="${job.serviceAddress}"/></dd>
		</dl>
	</div>

	<!-- 내 견적 -->
	<div class="card">
		<div class="card__head">
			<h2 class="card__title">내가 보낸 예상 견적</h2>
			<span class="muted" style="font-size:15px">견적번호 ${job.estimateId}</span>
		</div>
		<div class="field__label" style="margin-bottom:8px">견적 설명</div>
		<p style="font-size:16px;line-height:1.8;color:var(--g-700);white-space:pre-wrap;margin:0 0 20px"><c:out value="${job.estimateContent}"/></p>

		<dl class="dl--inline">
			<dt>예상 소요 시간</dt><dd>${job.estimatedDuration} 분</dd>
		</dl>

		<div style="display:flex;justify-content:space-between;align-items:center;
			margin-top:20px;padding-top:20px;border-top:2px solid var(--g-200)">
			<span style="font-size:18px;font-weight:700">예상 금액</span>
			<span style="font-size:32px;font-weight:800;letter-spacing:-1.4px">
				<fmt:formatNumber value="${job.estimatedPrice}" pattern="#,##0"/>원</span>
		</div>
	</div>

	<!-- 완료 처리 -->
	<div class="card card--flat">
		<div class="card__head"><h2 class="card__title">수리 완료 처리</h2></div>

		<c:choose>
			<c:when test="${job.statusCode eq 'REQ_03'}">
				<%--
					상태를 바꾸는 건 POST 로 보낸다.
					<a href> 링크(GET)로 만들면 클릭 한 번, 심하면 크롤러가 긁기만 해도
					상태가 바뀌어버린다.

					여기서 버튼을 숨기는 건 안내일 뿐이고, 진짜 차단은
					completeJob 의 WHERE 절(상태 + 소유자 확인)이 한다.
				--%>
				<form action="/fixer/jobs/${job.requestId}/complete" method="post"
				      onsubmit="return confirm('수리 완료로 변경할까요? 되돌릴 수 없습니다.');">
					<c:if test="${not empty _csrf}">
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
					</c:if>
					<button type="submit" class="btn btn--ok btn--xl btn--block">
						<svg class="ico"><use href="#i-check"/></svg>수리 완료 처리</button>
				</form>
			</c:when>

			<c:when test="${job.statusCode eq 'REQ_04'}">
				<div class="note note--ok" style="margin-bottom:0">
					<svg><use href="#i-check"/></svg>
					<span><b>수리가 완료된 작업입니다.</b></span>
				</div>
			</c:when>

			<c:otherwise>
				<div class="note note--gray" style="margin-bottom:0">
					<svg><use href="#i-clock"/></svg>
					<span>아직 완료 처리를 할 수 있는 단계가 아닙니다.</span>
				</div>
			</c:otherwise>
		</c:choose>
	</div>

	<p style="margin-top:24px"><a href="/fixer/jobs">← 목록으로</a></p>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
