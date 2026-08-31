<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>작업 상세</title>
	<style>
		table { border-collapse: collapse; width: 100%; max-width: 800px; }
		th, td { border: 1px solid #ccc; padding: 6px 8px; font-size: 14px; text-align: left; }
		th { background: #f5f5f5; width: 140px; }
	</style>
</head>
<body>

<h2>작업 상세</h2>

<c:if test="${not empty message}">
	<p style="color:blue; font-weight:bold;"><c:out value="${message}"/></p>
</c:if>

<h3>접수 정보</h3>
<table>
	<tr><th>접수번호</th><td>${job.requestId}</td></tr>
	<tr><th>제목</th>    <td><c:out value="${job.title}"/></td></tr>
	<tr><th>분야</th>    <td><c:out value="${job.categoryName}"/></td></tr>
	<tr><th>상태</th>    <td><c:out value="${job.statusName}"/></td></tr>
	<tr><th>접수일</th>  <td><fmt:formatDate value="${job.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td></tr>
	<tr>
		<th>증상</th>
		<td><pre style="white-space:pre-wrap; margin:0;"><c:out value="${job.content}"/></pre></td>
	</tr>
</table>

<h3>고객 / 방문지</h3>
<p><a href="/orders/${job.requestId}/chat"><b>고객과 채팅하기</b></a></p>
<table>
	<tr><th>고객명</th>  <td><c:out value="${job.customerName}"/></td></tr>
	<tr><th>연락처</th>  <td><c:out value="${job.customerPhone}"/></td></tr>
	<tr><th>방문 주소</th><td><c:out value="${job.serviceAddress}"/></td></tr>
</table>

<h3>내 견적</h3>
<table>
	<tr><th>견적번호</th>     <td>${job.estimateId}</td></tr>
	<tr><th>금액</th>         <td><fmt:formatNumber value="${job.estimatedPrice}" pattern="#,##0"/> 원</td></tr>
	<tr><th>예상 소요 시간</th><td>${job.estimatedDuration} 분</td></tr>
	<tr>
		<th>견적 설명</th>
		<td><pre style="white-space:pre-wrap; margin:0;"><c:out value="${job.estimateContent}"/></pre></td>
	</tr>
</table>

<hr>

<c:choose>
	<c:when test="${job.statusCode eq 'REQ_03'}">
		<%--
			상태를 바꾸는 건 POST 로 보낸다.
			<a href> 링크(GET)로 만들면 클릭 한 번, 심하면 크롤러가 긁기만 해도
			상태가 바뀌어버린다.
		--%>
		<form action="/fixer/jobs/${job.requestId}/complete" method="post"
		      onsubmit="return confirm('수리 완료로 변경할까요? 되돌릴 수 없습니다.');">
			<c:if test="${not empty _csrf}">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
			</c:if>
			<button type="submit">수리 완료 처리</button>
		</form>
	</c:when>

	<c:when test="${job.statusCode eq 'REQ_04'}">
		<p>수리가 완료된 작업입니다.</p>
	</c:when>

	<c:otherwise>
		<p>아직 완료 처리를 할 수 있는 단계가 아닙니다.</p>
	</c:otherwise>
</c:choose>

<p><a href="/fixer/jobs">← 목록으로</a></p>

</body>
</html>
