<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<%@ include file="common/icons.jspf" %>
<c:set var="navActive" value="jobs"/>

<div class="container">

	<div class="page-head">
		<h1>내 작업</h1>
		<p>고객이 <b>내 견적을 선택한</b> 건만 보입니다.</p>
	</div>

	<%@ include file="common/fixernav.jspf" %>

	<c:if test="${not empty message}">
		<div class="note note--blue" style="margin-bottom:24px">
			<svg><use href="#i-bell"/></svg>
			<span><c:out value="${message}"/></span>
		</div>
	</c:if>

	<%--
		필터는 링크(GET)로 건다. 지금 눌린 게 뭔지는 컨트롤러가 다시 내려준
		statusCode 값으로 판단한다. 이 값이 없으면 "전체" 다.
	--%>
	<div class="chip-row" style="margin-bottom:26px">
		<a class="chip ${empty statusCode ? 'chip--dark' : ''}" href="/fixer/jobs">전체</a>
		<a class="chip ${statusCode eq 'REQ_03' ? 'chip--dark' : ''}" href="/fixer/jobs?statusCode=REQ_03">진행중</a>
		<a class="chip ${statusCode eq 'REQ_04' ? 'chip--dark' : ''}" href="/fixer/jobs?statusCode=REQ_04">완료</a>
	</div>

	<c:choose>
		<c:when test="${empty jobList}">
			<div class="card card--flat" style="text-align:center;padding:56px 24px">
				<b style="font-size:19px">해당하는 작업이 없습니다.</b>
				<p class="muted" style="margin-top:8px">고객이 내 견적을 선택하면 여기에 나타납니다.</p>
				<a class="btn btn--primary btn--lg" style="margin-top:18px" href="/fixer/requests">
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
							<th style="width:110px">고객</th>
							<th style="width:130px">금액</th>
							<th style="width:120px">상태</th>
							<th style="width:150px">접수일</th>
							<th style="width:110px"></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="job" items="${jobList}">
							<tr>
								<td class="num">${job.requestId}</td>
								<td>
									<div class="ttl">
										<a href="/fixer/jobs/${job.requestId}"><c:out value="${job.title}"/></a>
									</div>
									<div class="muted" style="font-size:14.5px;margin-top:4px">
										<c:out value="${job.serviceAddress}"/></div>
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
								<td class="num"><fmt:formatDate value="${job.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
								<td class="right">
									<div class="btn-row">
										<%-- 이 목록은 "내 견적이 채택된 건" 만 나오므로
										     채팅 상대(고객)가 항상 있다. --%>
										<a class="btn btn--primary btn--sm"
										   href="/orders/${job.requestId}/chat">채팅</a>
										<a class="btn btn--ghost btn--sm"
										   href="/fixer/jobs/${job.requestId}">상세 보기</a>
									</div>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>

			<p class="muted" style="margin-top:16px;font-size:14.5px">
				진행중(REQ_03) 건이 항상 위로 옵니다. 정렬은 SQL 에서 처리합니다.
			</p>
		</c:otherwise>
	</c:choose>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
