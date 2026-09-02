<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>기사 인증 | 수릿 Surit</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
</head>
<body>

<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs><symbol id="i-tools" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol><symbol id="i-refresh" viewBox="0 0 24 24"><path d="M20 11a8 8 0 0 0-13.7-5.3L3 9"/><path d="M4 13a8 8 0 0 0 13.7 5.3L21 15"/><path d="M3 4v5h5"/><path d="M21 20v-5h-5"/></symbol><symbol id="i-user" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></symbol><symbol id="i-list" viewBox="0 0 24 24"><path d="M8 6h13"/><path d="M8 12h13"/><path d="M8 18h13"/><path d="M3.5 6h.01"/><path d="M3.5 12h.01"/><path d="M3.5 18h.01"/></symbol><symbol id="i-home" viewBox="0 0 24 24"><path d="M4 11.5 12 4l8 7.5"/><path d="M6.5 10.5V20h11v-9.5"/></symbol><symbol id="i-wrench" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol><symbol id="i-shield" viewBox="0 0 24 24"><path d="M12 3l7 3v5.5c0 4.4-3 8-7 9.5-4-1.5-7-5.1-7-9.5V6z"/><path d="M9.2 12l2 2 3.6-3.8"/></symbol><symbol id="i-chat" viewBox="0 0 24 24"><path d="M4 6.5A2.5 2.5 0 0 1 6.5 4h11A2.5 2.5 0 0 1 20 6.5v8a2.5 2.5 0 0 1-2.5 2.5H9.5L4 21.5z"/></symbol><symbol id="i-alert" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 7.5v5.5"/><circle cx="12" cy="16.5" r="1.1" fill="currentColor" stroke="none"/></symbol><symbol id="i-bell" viewBox="0 0 24 24"><path d="M18 15V10a6 6 0 1 0-12 0v5l-1.6 2.5h15.2z"/><path d="M10 20.5a2.2 2.2 0 0 0 4 0"/></symbol><symbol id="i-clock" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3.5 2"/></symbol><symbol id="i-check" viewBox="0 0 24 24"><path d="M4.5 12.5 9.5 17.5 19.5 6.5"/></symbol><symbol id="i-doc" viewBox="0 0 24 24"><path d="M14 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8z"/><path d="M14 3v5h5"/><path d="M9 13h6"/><path d="M9 17h6"/></symbol><symbol id="i-send" viewBox="0 0 24 24"><path d="M21 3 10.5 13.5"/><path d="M21 3l-7 18-3.5-7.5L3 10z"/></symbol></defs></svg>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<main>
	<div class="container">
		<div class="page-head page-head--plain">
			<h1>마이페이지</h1>
		</div>

		<div class="profile-box">
			<span class="avatar avatar--xl"><svg><use href="#i-user"/></svg></span>
			<div>
				<div class="profile-box__name"><c:out value="${user.name}"/> 기사님</div>
				<div class="profile-box__mail"><c:out value="${user.email}"/></div>
			</div>
			<div class="btn-row">
				<a class="btn btn--ghost" href="${pageContext.request.contextPath}/fixer/mypage/profile">내 정보 수정</a>
				<a class="btn btn--dark" href="${pageContext.request.contextPath}/user/mypage"><svg class="ico"><use href="#i-refresh"/></svg>고객으로 전환</a>
			</div>
		</div>

		<div class="with-side">
			<nav class="side-nav">
				<a href="${pageContext.request.contextPath}/fixer/jobs"><svg class="ico"><use href="#i-list"/></svg>내 작업</a>
				<a href="${pageContext.request.contextPath}/fixer/verify" class="is-active"><svg class="ico"><use href="#i-shield"/></svg>기사 인증</a>
				<a href="${pageContext.request.contextPath}/fixer/mypage"><svg class="ico"><use href="#i-wrench"/></svg>수리 정보 관리</a>
				<a href="${pageContext.request.contextPath}/fixer/mypage/address"><svg class="ico"><use href="#i-home"/></svg>주소 관리</a>
				<a href="${pageContext.request.contextPath}/fixer/mypage/profile"><svg class="ico"><use href="#i-user"/></svg>내 정보 수정</a>
				<a href="${pageContext.request.contextPath}/support"><svg class="ico"><use href="#i-chat"/></svg>고객센터</a>
			</nav>

			<div>
				<div class="sec-head sec-head--row" style="margin-bottom:20px">
					<div>
						<h2>기사 인증</h2>
						<p>자격증을 제출하면 관리자가 확인 후 승인합니다. 승인 전에는 견적을 보낼 수 없습니다.</p>
					</div>
				</div>

				<c:if test="${not empty message}">
					<c:choose>
						<c:when test="${messageType eq 'error'}">
							<div class="note note--warn" style="margin-bottom:24px">
								<svg><use href="#i-alert"/></svg>
								<span><b><c:out value="${message}"/></b><br><span class="muted">신청이 저장되지 않았습니다. 입력값을 다시 확인해주세요.</span></span>
							</div>
						</c:when>
						<c:otherwise>
							<div class="note note--blue" style="margin-bottom:24px">
								<svg><use href="#i-bell"/></svg>
								<span><c:out value="${message}"/></span>
							</div>
						</c:otherwise>
					</c:choose>
				</c:if>

				<c:choose>
					<c:when test="${profile.approvalStatus eq 'PENDING'}">
						<div class="note note--warn">
							<svg><use href="#i-clock"/></svg>
							<span><b>자격 심사가 진행 중입니다.</b> 보통 1~2일 걸립니다.<br>승인되면 알림을 보내드립니다.</span>
						</div>
					</c:when>
					<c:when test="${profile.approvalStatus eq 'APPROVED'}">
						<div class="note note--ok" style="margin-bottom:24px">
							<svg><use href="#i-check"/></svg>
							<span><b>인증이 완료된 기사입니다.</b> 이제 접수를 보고 견적을 보낼 수 있습니다.</span>
						</div>
					</c:when>
					<c:otherwise>
						<c:if test="${profile.approvalStatus eq 'REJECTED'}">
							<div class="note note--warn" style="margin-bottom:24px">
								<svg><use href="#i-alert"/></svg>
								<span><b>이전 신청이 거절되었습니다.</b> 내용을 보완해서 다시 신청해주세요.<br><br><b>거절 사유</b><br><span style="display:block; white-space:pre-wrap;"><c:out value="${profile.rejectReason}"/></span></span>
							</div>
						</c:if>

						<form action="${pageContext.request.contextPath}/fixer/verify" method="post" enctype="multipart/form-data" novalidate>
							<c:if test="${not empty _csrf}">
								<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
							</c:if>

							<div class="card">
								<div class="card__head"><h2 class="card__title">기본 정보</h2></div>
								<div class="field">
									<label class="field__label" for="intro">자기소개</label>
									<textarea class="textarea" id="intro" name="intro" rows="4"><c:out value="${profile.intro}"/></textarea>
									<div class="field__help">한글은 1자가 3바이트입니다.<b id="introCount" style="float:right"></b></div>
								</div>
								<div class="field" style="margin-bottom:0">
									<label class="field__label" for="careerYears">경력 (년)<span class="req">*</span></label>
									<input class="input" id="careerYears" type="number" name="careerYears" required value="${profile.careerYears}" style="max-width:220px">
								</div>
							</div>

							<div class="card">
								<div class="card__head"><h2 class="card__title">본인 확인용 사진<span class="req">*</span></h2></div>
								<div class="field" style="margin-bottom:0">
									<input class="input" type="file" name="photoFile" accept=".jpg,.jpeg,.png" required>
									<div class="field__help">고객에게 공개되는 사진입니다. (10MB 이하)</div>
								</div>
							</div>

							<div class="card">
								<div class="card__head"><h2 class="card__title">활동 지역<span class="req">*</span></h2></div>
								<div class="chip-row">
									<c:forEach var="region" items="${regionList}">
										<label class="check" style="min-width:190px">
											<input type="checkbox" name="regionCodes" value="${region.codeId}">
											<c:out value="${region.codeName}"/>
										</label>
									</c:forEach>
								</div>
							</div>

							<div class="card">
								<div class="card__head"><h2 class="card__title">수리 가능 분야<span class="req">*</span></h2></div>
								<div class="chip-row">
									<c:forEach var="category" items="${categoryList}">
										<label class="check" style="min-width:190px">
											<input type="checkbox" name="categoryCodes" value="${category.codeId}">
											<c:out value="${category.codeName}"/>
										</label>
									</c:forEach>
								</div>
							</div>

							<div class="card">
								<div class="card__head"><h2 class="card__title">자격증<span class="req">*</span></h2></div>
								<c:forEach var="i" begin="1" end="3">
									<div class="list-card" style="align-items:flex-start">
										<span class="tile tile--sm t-blue"><svg><use href="#i-doc"/></svg></span>
										<div class="list-card__body">
											<div class="field__label" style="margin-bottom:12px">자격증 ${i}</div>
											<div class="field-row">
												<div class="field">
													<label class="field__label">자격증명</label>
													<input class="input" type="text" name="licenseNames" maxlength="100">
												</div>
												<div class="field">
													<label class="field__label">발급일</label>
													<input class="input" type="date" name="licenseIssuedAts">
												</div>
											</div>
											<div class="field" style="margin-bottom:0">
												<label class="field__label">증빙파일</label>
												<input class="input" type="file" name="licenseFiles" accept=".jpg,.jpeg,.png,.pdf">
											</div>
										</div>
									</div>
								</c:forEach>
							</div>

							<div class="card card--flat">
								<div id="formAlert" class="note note--warn" style="display:none; margin-bottom:22px">
									<svg><use href="#i-alert"/></svg><span id="formAlertText"></span>
								</div>
								<button type="submit" class="btn btn--primary btn--xl btn--block">
									<svg class="ico"><use href="#i-send"/></svg>인증 신청하기
								</button>
							</div>
						</form>

						<!-- 검증 로직 JS 뼈대 -->
						<script>
							(function () {
								'use strict';
								var INTRO_MAX_BYTES = 4000;
								var intro = document.getElementById('intro');
								var introCount = document.getElementById('introCount');
								function byteLength(s) {
									if (!s) return 0;
									return new TextEncoder().encode(s).length;
								}
								function updateIntroCount() {
									if (!intro || !introCount) return;
									var n = byteLength(intro.value);
									introCount.textContent = n + ' / ' + INTRO_MAX_BYTES + ' 바이트';
									introCount.style.color = (n > INTRO_MAX_BYTES) ? '#b45309' : '';
								}
								if (intro) {
									intro.addEventListener('input', updateIntroCount);
									updateIntroCount();
								}
							})();
						</script>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
</body>
</html>