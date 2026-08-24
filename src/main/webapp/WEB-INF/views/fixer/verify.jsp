<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>기사 인증 신청</title>
	<style>
		.region { display:inline-block; width:180px; }
	</style>
</head>
<body>

<h2>기사 인증 신청</h2>

<c:if test="${not empty message}"><p style="color:blue; font-weight:bold;"><c:out value="${message}"/></p></c:if>

<c:choose>

	<c:when test="${profile.approvalStatus eq 'PENDING'}">
		<p>심사 중입니다. 결과가 나올 때까지 기다려주세요.</p>
	</c:when>

	<c:when test="${profile.approvalStatus eq 'APPROVED'}">
		<p>인증이 완료된 기사입니다.</p>
		<p>
			<a href="/fixer/requests">내 주변 새 접수 보기</a> ·
			<a href="/fixer/jobs">내 작업 관리</a>
		</p>
	</c:when>

	<c:otherwise>

		<c:if test="${profile.approvalStatus eq 'REJECTED'}">
			<p style="color:red;">
				이전 신청이 거절되었습니다. 내용을 보완해서 다시 신청해주세요.
			</p>
		</c:if>

		<form action="/fixer/verify" method="post" enctype="multipart/form-data">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

			<h3>1. 기본 정보</h3>
			<p>
				자기소개<br>
				<textarea name="intro" rows="4" cols="60" maxlength="4000"><c:out value="${profile.intro}"/></textarea>
			</p>
			<p>
				경력 (년)<br>
				<input type="number" name="careerYears" min="0" max="70" required value="${profile.careerYears}">
			</p>

			<h3>2. 활동 지역 (1개 이상)</h3>
			<c:forEach var="region" items="${regionList}">
				<label class="region">
					<input type="checkbox" name="regionCodes" value="${region.codeId}">
					<c:out value="${region.codeName}"/>
				</label>
			</c:forEach>

			<h3>3. 수리 가능 분야 (1개 이상)</h3>
			<c:forEach var="category" items="${categoryList}">
				<label>
					<input type="checkbox" name="categoryCodes" value="${category.codeId}">
					<c:out value="${category.codeName}"/>
				</label><br>
			</c:forEach>

			<h3>4. 자격증 (1개 이상 · 증빙파일은 jpg/png/pdf)</h3>
			<c:forEach var="i" begin="1" end="3">
				<fieldset style="margin-bottom:8px;">
					<legend>자격증 ${i}</legend>
					자격증명 <input type="text" name="licenseNames" maxlength="100"><br>
					발급일 <input type="date" name="licenseIssuedAts"><br>
					증빙파일 <input type="file" name="licenseFiles" accept=".jpg,.jpeg,.png,.pdf">
				</fieldset>
			</c:forEach>

			<hr>
			<button type="submit">신청하기</button>
		</form>

	</c:otherwise>
</c:choose>

</body>
</html>
