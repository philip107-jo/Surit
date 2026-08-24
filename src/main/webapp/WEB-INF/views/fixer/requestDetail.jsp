<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>접수 상세</title>
	<style>
		th, td { border: 1px solid #ccc; padding: 6px 8px; font-size: 14px; text-align: left; }
		table { border-collapse: collapse; width: 100%; max-width: 800px; }
		th { background: #f5f5f5; width: 130px; }
		.photo { max-width: 260px; margin: 4px; border: 1px solid #ddd; }
	</style>
</head>
<body>

<h2>접수 상세</h2>

<table>
	<tr><th>접수번호</th><td>${repair.requestId}</td></tr>
	<tr><th>제목</th>    <td><c:out value="${repair.title}"/></td></tr>
	<tr><th>분야</th>    <td><c:out value="${repair.categoryName}"/></td></tr>
	<tr><th>상태</th>    <td><c:out value="${repair.statusName}"/></td></tr>
	<tr><th>고객</th>    <td><c:out value="${repair.customerName}"/></td></tr>
	<tr><th>서비스 주소</th><td><c:out value="${repair.serviceAddress}"/></td></tr>
	<tr><th>접수일</th>  <td><fmt:formatDate value="${repair.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td></tr>
	<tr>
		<th>증상</th>
		<td><pre style="white-space:pre-wrap; margin:0;"><c:out value="${repair.content}"/></pre></td>
	</tr>
	<tr><th>받은 견적 수</th><td>${repair.estimateCount}</td></tr>
</table>

<h3>고장 사진</h3>
<c:choose>
	<c:when test="${empty repair.photos}">
		<p>등록된 사진이 없습니다.</p>
	</c:when>
	<c:otherwise>
		<c:forEach var="photo" items="${repair.photos}">
			<img class="photo" src="<c:out value='${photo.photoPath}'/>" alt="고장 사진">
		</c:forEach>
	</c:otherwise>
</c:choose>

<hr>

<c:choose>
	<c:when test="${not empty repair.myEstimateId}">
		<p>이미 견적을 제출한 접수입니다. <a href="/fixer/estimates">내 견적 보기</a></p>
	</c:when>
	<c:otherwise>
		<p><a href="/fixer/estimates/new?requestId=${repair.requestId}"><b>예상 견적 제시하기</b></a></p>
	</c:otherwise>
</c:choose>

<p><a href="/fixer/requests">← 목록으로</a></p>

</body>
</html>
