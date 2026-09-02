<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>내 작업 | 수릿 Surit</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
</head>
<body>

<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs><symbol id="i-tools" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol><symbol id="i-refresh" viewBox="0 0 24 24"><path d="M20 11a8 8 0 0 0-13.7-5.3L3 9"/><path d="M4 13a8 8 0 0 0 13.7 5.3L21 15"/><path d="M3 4v5h5"/><path d="M21 20v-5h-5"/></symbol><symbol id="i-user" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></symbol><symbol id="i-list" viewBox="0 0 24 24"><path d="M8 6h13"/><path d="M8 12h13"/><path d="M8 18h13"/><path d="M3.5 6h.01"/><path d="M3.5 12h.01"/><path d="M3.5 18h.01"/></symbol><symbol id="i-home" viewBox="0 0 24 24"><path d="M4 11.5 12 4l8 7.5"/><path d="M6.5 10.5V20h11v-9.5"/></symbol><symbol id="i-wrench" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol><symbol id="i-shield" viewBox="0 0 24 24"><path d="M12 3l7 3v5.5c0 4.4-3 8-7 9.5-4-1.5-7-5.1-7-9.5V6z"/><path d="M9.2 12l2 2 3.6-3.8"/></symbol><symbol id="i-chat" viewBox="0 0 24 24"><path d="M4 6.5A2.5 2.5 0 0 1 6.5 4h11A2.5 2.5 0 0 1 20 6.5v8a2.5 2.5 0 0 1-2.5 2.5H9.5L4 21.5z"/></symbol><symbol id="i-bell" viewBox="0 0 24 24"><path d="M18 15V10a6 6 0 1 0-12 0v5l-1.6 2.5h15.2z"/><path d="M10 20.5a2.2 2.2 0 0 0 4 0"/></symbol><symbol id="i-search" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="M16.2 16.2 21 21"/></symbol></defs></svg>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<main>
	<div class="container">
		<div class="page-head page-head--plain">
			<h1>마이페이지</h1>
		</div>

		<div class="profile-box">
			<span class="avatar avatar--xl"><svg><use href="#i-user"/></svg></span>
			<div>
				<div class="profile-box__name"><c:out value="${user.name}"/> 기사님</div>
				<div class="profile-box__mail"><c:out value="${user.email}"/></div>
			</div>
			<div class="btn-row">
				<a class="btn btn--ghost" href="${pageContext.request.contextPath}/fixer/mypage/profile">내 정보 수정</a>
				<a class="btn btn--dark" href="${pageContext.request.contextPath}/user/mypage"><svg class="ico"><use href="#i-refresh"/></svg>고객으로 전환</a>
			</div>
		</div>

		<div class="with-side">
			<nav class="side-nav">
				<a href="${pageContext.request.contextPath}/fixer/jobs" class="is-active"><svg class="ico"><use href="#i-list"/></svg>내 작업</a>
				<a href="${pageContext.request.contextPath}/fixer/verify"><svg class="ico"><use href="#i-shield"/></svg>기사 인증</a>
				<a href="${pageContext.request.contextPath}/fixer/mypage"><svg class="ico"><use href="#i-wrench"/></svg>수리 정보 관리</a>
				<a href="${pageContext.request.contextPath}/fixer/mypage/address"><svg class="ico"><use href="#i-home"/></svg>주소 관리</a>
				<a href="${pageContext.request.contextPath}/fixer/mypage/profile"><svg class="ico"><use href="#i-user"/></svg>내 정보 수정</a>
				<a href="${pageContext.request.contextPath}/support"><svg class="ico"><use href="#i-chat"/></svg>고객센터</a>
			</nav>

			<div>
				<div class="sec-head sec-head--row" style="margin-bottom:20px">
					<div>
						<h2>내 작업</h2>
						<p>고객이 <b>내 견적을 선택한</b> 건만 보입니다.</p>
					</div>
				</div>

				<c:if test="${not empty message}">
					<div class="note note--blue" style="margin-bottom:24px">
						<svg><use href="#i-bell"/></svg>
						<span><c:out value="${message}"/></span>
					</div>
				</c:if>

				<div class="chip-row" style="margin-bottom:26px">
					<a class="chip ${empty statusCode ? 'chip--dark' : ''}" href="${pageContext.request.contextPath}/fixer/jobs">전체</a>
					<a class="chip ${statusCode eq 'REQ_03' ? 'chip--dark' : ''}" href="${pageContext.request.contextPath}/fixer/jobs?statusCode=REQ_03">진행중</a>
					<a class="chip ${statusCode eq 'REQ_04' ? 'chip--dark' : ''}" href="${pageContext.request.contextPath}/fixer/jobs?statusCode=REQ_04">완료</a>
				</div>

				<c:choose>
					<c:when test="${empty jobList}">
						<div class="card card--flat" style="text-align:center;padding:56px 24px">
							<b style="font-size:19px">해당하는 작업이 없습니다.</b>
							<p class="muted" style="margin-top:8px">고객이 내 견적을 선택하면 여기에 나타납니다.</p>
							<a class="btn btn--primary btn--lg" style="margin-top:18px" href="${pageContext.request.contextPath}/fixer/requests">
								<svg class="ico"><use href="#i-search"/></svg>새 접수 보러가기</a>
						</div>
					</c:when>
					<c:otherwise>
						<div class="card card--sm">
							<table class="tbl">
								<thead>
								<tr>
									<th style="width:90px">접수번호</th>
									<th>수리 항목</th>
									<th style="width:120px">분야</th>
									<th style="width:100px">고객</th>
									<th style="width:120px">금액</th>
									<th style="width:100px">상태</th>
									<th style="width:100px"></th>
								</tr>
								</thead>
								<tbody>
								<c:forEach var="job" items="${jobList}">
									<tr>
										<td class="num">${job.requestId}</td>
										<td>
											<div class="ttl">
												<a href="${pageContext.request.contextPath}/fixer/jobs/${job.requestId}"><c:out value="${job.title}"/></a>
											</div>
											<div class="muted" style="font-size:14.5px;margin-top:4px"><c:out value="${job.serviceAddress}"/></div>
										</td>
										<td><c:out value="${job.categoryName}"/></td>
										<td><c:out value="${job.customerName}"/></td>
										<td class="num"><fmt:formatNumber value="${job.estimatedPrice}" pattern="#,##0"/> 원</td>
										<td>
											<c:choose>
												<c:when test="${job.statusCode eq 'REQ_04'}">
													<span class="badge st-done"><c:out value="${job.statusName}"/></span>
												</c:when>
												<c:otherwise>
													<span class="badge st-repairing"><c:out value="${job.statusName}"/></span>
												</c:otherwise>
											</c:choose>
										</td>
										<td class="right">
											<div class="btn-row">
												<a class="btn btn--primary btn--sm" href="/fixer/chat/${job.requestId}">채팅</a>
												<a class="btn btn--ghost btn--sm" href="${pageContext.request.contextPath}/fixer/jobs/${job.requestId}">상세</a>
											</div>
										</td>
									</tr>
								</c:forEach>
								</tbody>
							</table>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
</body>
</html>