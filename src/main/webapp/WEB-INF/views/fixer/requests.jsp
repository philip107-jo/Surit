<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>내 주변 새 접수</title>
	<style>
		table { border-collapse: collapse; width: 100%; }
		th, td { border: 1px solid #ccc; padding: 6px 8px; font-size: 14px; }
		th { background: #f5f5f5; }
		.done { color: #888; }
	</style>
</head>
<body>

<h2>내 주변 새 접수</h2>
<p>내가 등록한 <b>수리 분야</b>와 <b>활동 지역</b>에 맞는 접수만 보입니다.</p>

<c:if test="${not empty message}">
	<p style="color:red; font-weight:bold;"><c:out value="${message}"/></p>
</c:if>

<form action="/fixer/requests" method="get">
	<select name="categoryCode">
		<option value="">분야 전체</option>
		<c:forEach var="category" items="${categoryList}">
			<option value="${category.codeId}"
				<c:if test="${categoryCode eq category.codeId}">selected</c:if>>
				<c:out value="${category.codeName}"/>
			</option>
		</c:forEach>
	</select>
	<input type="text" name="keyword" value="<c:out value='${keyword}'/>" placeholder="제목 · 내용 검색">
	<button type="submit">검색</button>
	<a href="/fixer/requests">초기화</a>
</form>

<hr>

<c:choose>
	<c:when test="${empty requestList}">
		<p>조건에 맞는 새 접수가 없습니다.</p>
	</c:when>

	<c:otherwise>
		<table>
			<tr>
				<th>번호</th>
				<th>분야</th>
				<th>제목</th>
				<th>지역</th>
				<th>상태</th>
				<th>견적</th>
				<th>접수일</th>
			</tr>

			<c:forEach var="request" items="${requestList}">
				<tr>
					<td>${request.requestId}</td>
					<td><c:out value="${request.categoryName}"/></td>
					<td>
						<a href="/fixer/requests/${request.requestId}">
							<c:out value="${request.title}"/>
						</a>
					</td>
					<td><c:out value="${request.serviceAddress}"/></td>
					<td><c:out value="${request.statusName}"/></td>
					<td>
						<c:choose>
							<c:when test="${not empty request.myEstimateId}">
								<span class="done">제출함</span>
							</c:when>
							<c:otherwise>
								<a href="/fixer/estimates/new?requestId=${request.requestId}">견적 내기</a>
							</c:otherwise>
						</c:choose>
						(${request.estimateCount})
					</td>
					<td><fmt:formatDate value="${request.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
				</tr>
			</c:forEach>
		</table>
	</c:otherwise>
</c:choose>

<p>
	<a href="/fixer/verify">인증 정보</a> ·
	<a href="/fixer/estimates">내 견적</a> ·
	<a href="/fixer/jobs">내 작업 관리</a>
</p>

</body>
</html>
