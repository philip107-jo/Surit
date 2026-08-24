<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>예상 견적 제시</title>
	<style>
		table { border-collapse: collapse; max-width: 700px; width: 100%; }
		th, td { border: 1px solid #ccc; padding: 6px 8px; font-size: 14px; text-align: left; }
		th { background: #f5f5f5; width: 130px; }
	</style>
</head>
<body>

<h2>예상 견적 제시</h2>

<c:if test="${not empty message}">
	<p style="color:red; font-weight:bold;"><c:out value="${message}"/></p>
</c:if>

<h3>접수 내용</h3>
<table>
	<tr><th>제목</th><td><c:out value="${repair.title}"/></td></tr>
	<tr><th>분야</th><td><c:out value="${repair.categoryName}"/></td></tr>
	<tr><th>주소</th><td><c:out value="${repair.serviceAddress}"/></td></tr>
	<tr>
		<th>증상</th>
		<td><pre style="white-space:pre-wrap; margin:0;"><c:out value="${repair.content}"/></pre></td>
	</tr>
</table>

<h3>견적 입력</h3>
<form action="/fixer/estimates" method="post">

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

	<table>
		<tr>
			<th>예상 금액(원)</th>
			<td><input type="number" name="estimatedPrice" min="0" step="1000" required style="width:200px;"></td>
		</tr>
		<tr>
			<th>예상 소요 시간(분)</th>
			<td><input type="number" name="estimatedDuration" min="1" max="43200" required style="width:200px;"> (예: 90 = 1시간 30분)</td>
		</tr>
		<tr>
			<th>견적 설명</th>
			<td><textarea name="content" rows="6" cols="60" maxlength="1000" required
				placeholder="어떤 작업을 하는지, 부품값이 포함인지 등을 적어주세요."></textarea></td>
		</tr>
	</table>

	<p>
		<button type="submit">견적 제출</button>
		<a href="/fixer/requests/${repair.requestId}">취소</a>
	</p>
</form>

</body>
</html>
