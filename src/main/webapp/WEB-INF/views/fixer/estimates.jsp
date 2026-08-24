<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>내 견적</title>
	<style>
		table { border-collapse: collapse; width: 100%; }
		th, td { border: 1px solid #ccc; padding: 6px 8px; font-size: 14px; }
		th { background: #f5f5f5; }
		.selected { color: #0a7; font-weight: bold; }
		.pending  { color: #888; }
	</style>
</head>
<body>

<h2>내 견적</h2>

<c:if test="${not empty message}">
	<p style="color:blue; font-weight:bold;"><c:out value="${message}"/></p>
</c:if>

<c:choose>
	<c:when test="${empty estimateList}">
		<p>아직 제출한 견적이 없습니다. <a href="/fixer/requests">새 접수 보러가기</a></p>
	</c:when>

	<c:otherwise>
		<table>
			<tr>
				<th>견적번호</th>
				<th>접수 제목</th>
				<th>분야</th>
				<th>고객</th>
				<th>예상 금액</th>
				<th>소요 시간</th>
				<th>내 견적 상태</th>
				<th>접수 상태</th>
				<th>제출일</th>
			</tr>

			<c:forEach var="estimate" items="${estimateList}">
				<tr>
					<td>${estimate.estimateId}</td>
					<td>
						<a href="/fixer/requests/${estimate.requestId}">
							<c:out value="${estimate.requestTitle}"/>
						</a>
					</td>
					<td><c:out value="${estimate.categoryName}"/></td>
					<td><c:out value="${estimate.customerName}"/></td>
					<td><fmt:formatNumber value="${estimate.estimatedPrice}" pattern="#,##0"/> 원</td>
					<td>${estimate.estimatedDuration} 분</td>
					<td>
						<c:choose>
							<c:when test="${estimate.status eq 'SELECTED'}">
								<span class="selected">선택됨</span>
							</c:when>
							<c:otherwise>
								<span class="pending">대기중</span>
							</c:otherwise>
						</c:choose>
					</td>
					<td><c:out value="${estimate.requestStatusName}"/></td>
					<td><fmt:formatDate value="${estimate.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
				</tr>
			</c:forEach>
		</table>
	</c:otherwise>
</c:choose>

<p>
	<a href="/fixer/requests">내 주변 새 접수</a> ·
	<a href="/fixer/jobs">내 작업 관리</a>
</p>

</body>
</html>
