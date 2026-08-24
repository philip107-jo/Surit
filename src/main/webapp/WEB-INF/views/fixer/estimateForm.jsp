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
<%--
	onsubmit 에서 버튼을 막아도 이번 제출 자체는 그대로 나간다.
	브라우저는 onsubmit 이 true 를 돌려준 뒤에 폼을 전송하기 때문에,
	여기서 disabled 를 걸어도 지금 누른 제출은 막지 않고
	"같은 버튼을 한 번 더 누르는 것"만 막는다.

	다만 이건 실수로 두 번 클릭하는 걸 줄여주는 보조 수단일 뿐이고,
	진짜 중복 방지는 서버(DB의 UNIQUE 제약)가 한다.
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
		<button type="submit" id="submitBtn">견적 제출</button>
		<a href="/fixer/requests/${repair.requestId}">취소</a>
	</p>
</form>

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

</body>
</html>
