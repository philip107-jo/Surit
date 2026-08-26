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
			<div style="border:1px solid #f0b8b8; background:#fff5f5; padding:12px 16px; margin-bottom:16px;">

				<p style="color:red; font-weight:bold; margin:0 0 8px;">
					이전 신청이 거절되었습니다. 내용을 보완해서 다시 신청해주세요.
				</p>

				<%-- 관리자가 REJECT_REASON 을 안 적었거나, 이 컬럼이 생기기 전에
				     거절된 건이면 null 이다. 그래서 반드시 empty 검사를 먼저 한다.
				     검사 없이 출력하면 빈 상자만 덩그러니 남는다. --%>
				<c:choose>
					<c:when test="${not empty profile.rejectReason}">
						<p style="margin:0 0 4px; font-weight:bold;">거절 사유</p>
						<%-- 관리자가 쓴 글이므로 반드시 c:out 으로 이스케이프한다.
						     pre + pre-wrap : 줄바꿈은 살리고 가로 스크롤은 안 생기게. --%>
						<pre style="white-space:pre-wrap; word-break:break-all;
						            margin:0; font-family:inherit; font-size:inherit;"><c:out value="${profile.rejectReason}"/></pre>
					</c:when>
					<c:otherwise>
						<p style="margin:0; color:#888;">
							등록된 거절 사유가 없습니다. 자격증과 사진을 다시 확인해주세요.
						</p>
					</c:otherwise>
				</c:choose>

			</div>
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

			<h3>2. 본인 확인용 사진 (필수 · jpg/png)</h3>
			<p>
				얼굴이 나온 사진 1장을 첨부해주세요. 고객이 기사님을 확인할 수 있도록 공개되는 사진입니다.<br>
				<input type="file" name="photoFile" accept=".jpg,.jpeg,.png" required>
			</p>

			<h3>3. 활동 지역 (1개 이상)</h3>
			<c:forEach var="region" items="${regionList}">
				<label class="region">
					<input type="checkbox" name="regionCodes" value="${region.codeId}">
					<c:out value="${region.codeName}"/>
				</label>
			</c:forEach>

			<h3>4. 수리 가능 분야 (1개 이상)</h3>
			<c:forEach var="category" items="${categoryList}">
				<label>
					<input type="checkbox" name="categoryCodes" value="${category.codeId}">
					<c:out value="${category.codeName}"/>
				</label><br>
			</c:forEach>

			<h3>5. 자격증 (1개 이상 · 증빙파일은 jpg/png/pdf)</h3>
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
