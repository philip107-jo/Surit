<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>내 작업 관리</title>
	<style>
		table { border-collapse: collapse; width: 100%; }
		th, td { border: 1px solid #ccc; padding: 6px 8px; font-size: 14px; }
		th { background: #f5f5f5; }
		.ing  { color: #d60; font-weight: bold; }
		.done { color: #888; }
	</style>
</head>
<body>

<h2>내 작업 관리</h2>
<p>고객이 <b>내 견적을 선택한</b> 건만 보입니다.</p>

<c:if test="${not empty message}">
	<p style="color:blue; font-weight:bold;"><c:out value="${message}"/></p>
</c:if>

<p>
	<a href="/fixer/jobs">전체</a> ·
	<a href="/fixer/jobs?statusCode=REQ_03">진행중</a> ·
	<a href="/fixer/jobs?statusCode=REQ_04">완료</a>
	<c:if test="${not empty statusCode}">
		<span>(현재 필터: <c:out value="${statusCode}"/>)</span>
	</c:if>
</p>

<c:choose>
	<c:when test="${empty jobList}">
		<p>해당하는 작업이 없습니다.</p>
	</c:when>

	<c:otherwise>
		<table>
			<tr>
				<th>접수번호</th>
				<th>제목</th>
				<th>분야</th>
				<th>고객</th>
				<th>주소</th>
				<th>금액</th>
				<th>상태</th>
				<th>접수일</th>
				<th>대화</th>
			</tr>

			<c:forEach var="job" items="${jobList}">
				<tr>
					<td>${job.requestId}</td>
					<td>
						<a href="/fixer/jobs/${job.requestId}">
							<c:out value="${job.title}"/>
						</a>
					</td>
					<td><c:out value="${job.categoryName}"/></td>
					<td><c:out value="${job.customerName}"/></td>
					<td><c:out value="${job.serviceAddress}"/></td>
					<td><fmt:formatNumber value="${job.estimatedPrice}" pattern="#,##0"/> 원</td>
					<td>
						<c:choose>
							<c:when test="${job.statusCode eq 'REQ_04'}">
								<span class="done"><c:out value="${job.statusName}"/></span>
							</c:when>
							<c:otherwise>
								<span class="ing"><c:out value="${job.statusName}"/></span>
							</c:otherwise>
						</c:choose>
					</td>
					<td><fmt:formatDate value="${job.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
					<%-- 여기 목록은 이미 "내 견적이 채택된 건"만 나오므로 항상 채팅이 가능하다 --%>
					<td><a href="/orders/${job.requestId}/chat">채팅</a></td>
				</tr>
			</c:forEach>
		</table>
	</c:otherwise>
</c:choose>

<p>
	<a href="/fixer/requests">내 주변 새 접수</a> ·
	<a href="/fixer/estimates">내 견적</a>
</p>

</body>
</html>
