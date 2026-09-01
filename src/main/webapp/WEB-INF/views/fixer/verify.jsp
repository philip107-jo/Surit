<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<%@ include file="common/icons.jspf" %>
<c:set var="navActive" value="verify"/>

<div class="container" style="max-width:900px">

	<div class="page-head page-head--plain">
		<h1>기사 인증</h1>
		<p>자격증을 제출하면 관리자가 확인 후 승인합니다. 승인 전에는 견적을 보낼 수 없습니다.</p>
	</div>

	<%@ include file="common/fixernav.jspf" %>

	<%--
		서비스가 던진 메시지가 flash 로 넘어온다 (한 번만 보이고 사라짐).

		성공은 파란 안내, 실패는 주황 경고로 색을 나눈다.
		둘 다 파란 안내로 두면 사용자가 오류인 줄 모르고 지나친다.

		그리고 실패해도 redirect 로 돌아오기 때문에 입력값이 유지되지 않는다.
		그 사실을 모르면 "왜 안 넘어가지" 하고 헤매게 되므로 안내를 함께 둔다.
		(성공만 redirect 하고 실패는 forward 로 바꾸면 입력값을 살릴 수 있는데,
		 파일 입력칸은 브라우저 보안상 어차피 복원되지 않는다.)
	--%>
	<c:if test="${not empty message}">
		<c:choose>

			<%-- 실패 : 주황 경고 + 다시 입력해야 한다는 안내 --%>
			<c:when test="${messageType eq 'error'}">
				<div class="note note--warn" style="margin-bottom:24px">
					<svg><use href="#i-alert"/></svg>
					<span>
						<b><c:out value="${message}"/></b><br>
						<span class="muted">신청이 저장되지 않았습니다.
						입력값 · 선택 항목 · 첨부 파일을 다시 입력해주세요.</span>
					</span>
				</div>
			</c:when>

			<%-- 성공 또는 일반 안내 : 기존 파란 박스 그대로 --%>
			<c:otherwise>
				<div class="note note--blue" style="margin-bottom:24px">
					<svg><use href="#i-bell"/></svg>
					<span><c:out value="${message}"/></span>
				</div>
			</c:otherwise>

		</c:choose>
	</c:if>

	<c:choose>

		<%-- ① 심사 중 : 신청 폼을 아예 안 보여준다 --%>
		<c:when test="${profile.approvalStatus eq 'PENDING'}">
			<div class="note note--warn">
				<svg><use href="#i-clock"/></svg>
				<span><b>자격 심사가 진행 중입니다.</b> 보통 1~2일 걸립니다.<br>
				승인되면 접수 찾기에서 예상 견적을 보낼 수 있습니다.</span>
			</div>
		</c:when>

		<%-- ② 승인 완료 --%>
		<c:when test="${profile.approvalStatus eq 'APPROVED'}">
			<div class="note note--ok" style="margin-bottom:24px">
				<svg><use href="#i-check"/></svg>
				<span><b>인증이 완료된 기사입니다.</b> 이제 접수를 보고 견적을 보낼 수 있습니다.</span>
			</div>
			<div class="btn-row">
				<a class="btn btn--primary btn--lg" href="/fixer/requests">
					<svg class="ico"><use href="#i-search"/></svg>내 주변 새 접수 보기</a>
				<a class="btn btn--ghost btn--lg" href="/fixer/jobs">
					<svg class="ico"><use href="#i-list"/></svg>내 작업 관리</a>
			</div>
		</c:when>

		<%-- ③ 신규(profile 이 null) 또는 거절 → 신청 폼 --%>
		<c:otherwise>

			<c:if test="${profile.approvalStatus eq 'REJECTED'}">
				<div class="note note--warn" style="margin-bottom:24px">
					<svg><use href="#i-alert"/></svg>
					<span>
						<b>이전 신청이 거절되었습니다.</b> 내용을 보완해서 다시 신청해주세요.
						<%--
							관리자가 REJECT_REASON 을 안 적었거나, 이 컬럼이 생기기 전에
							거절된 건이면 null 이다. 그래서 반드시 empty 검사를 먼저 한다.
							검사 없이 출력하면 빈 상자만 덩그러니 남는다.
						--%>
						<c:choose>
							<c:when test="${not empty profile.rejectReason}">
								<br><br><b>거절 사유</b><br>
								<%--
									관리자가 쓴 글이므로 반드시 c:out 으로 이스케이프한다. (XSS 차단)
									pre-wrap : 줄바꿈은 살리고 가로 스크롤은 안 생기게.
								--%>
								<span style="display:block; white-space:pre-wrap; word-break:break-all;"><c:out value="${profile.rejectReason}"/></span>
							</c:when>
							<c:otherwise>
								<br><br>등록된 거절 사유가 없습니다. 자격증과 사진을 다시 확인해주세요.
							</c:otherwise>
						</c:choose>
					</span>
				</div>
			</c:if>

			<%--
				enctype 이 없으면 파일은 이름만 넘어오고 내용은 오지 않는다.
				서버는 FixerVerifyRequest 의 필드 이름과 name 을 맞춰서 값을 담는다.
			--%>
			<form action="/fixer/verify" method="post" enctype="multipart/form-data">

				<%-- CSRF 를 켜둔 프로젝트에서만 토큰이 만들어진다. 없으면 이 줄은 건너뛴다 --%>
				<c:if test="${not empty _csrf}">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
				</c:if>

				<!-- 1. 기본 정보 -->
				<div class="card">
					<div class="card__head"><h2 class="card__title">기본 정보</h2></div>

					<div class="field">
						<label class="field__label" for="intro">자기소개</label>
						<textarea class="textarea" id="intro" name="intro" rows="4" maxlength="4000"
							placeholder="어떤 수리를 오래 해왔는지 짧게 적어주세요."><c:out value="${profile.intro}"/></textarea>
						<div class="field__help">최대 4000자. 고객이 기사 목록에서 보게 됩니다.</div>
					</div>

					<div class="field" style="margin-bottom:0">
						<label class="field__label" for="careerYears">경력 (년)<span class="req">*</span></label>
						<input class="input" id="careerYears" type="number" name="careerYears"
						       min="0" max="70" required value="${profile.careerYears}" style="max-width:220px">
					</div>
				</div>

				<!-- 2. 본인 확인용 사진 -->
				<div class="card">
					<div class="card__head">
						<h2 class="card__title">본인 확인용 사진<span class="req">*</span></h2>
						<span class="muted" style="font-size:15px">jpg · png · 10MB 이하</span>
					</div>
					<div class="field" style="margin-bottom:0">
						<input class="input" type="file" name="photoFile" accept=".jpg,.jpeg,.png" required>
						<%--
							required 는 브라우저 기능이라 개발자도구로 지우면 그냥 통과한다.
							DB 컬럼도 nullable 이라, 진짜 방어는 서비스의 validate() 가 한다.
						--%>
						<div class="field__help">얼굴이 나온 사진 1장. 고객이 기사님을 확인할 수 있도록 공개되는 사진입니다. <b>파일 1개당 10MB까지</b> 올릴 수 있습니다.</div>
					</div>
				</div>

				<!-- 3. 활동 지역 -->
				<div class="card">
					<div class="card__head">
						<h2 class="card__title">활동 지역<span class="req">*</span></h2>
						<span class="muted" style="font-size:15px">1개 이상</span>
					</div>
					<div class="chip-row">
						<%-- 체크박스는 같은 name 을 여러 번 보내고, 서버는 List&lt;String&gt; 으로 받는다 --%>
						<c:forEach var="region" items="${regionList}">
							<label class="check" style="min-width:190px">
								<input type="checkbox" name="regionCodes" value="${region.codeId}">
								<c:out value="${region.codeName}"/>
							</label>
						</c:forEach>
					</div>
					<div class="field__help" style="margin-top:12px">
						선택한 지역명이 접수 주소에 들어 있으면 그 접수가 내 목록에 보입니다.
					</div>
				</div>

				<!-- 4. 수리 가능 분야 -->
				<div class="card">
					<div class="card__head">
						<h2 class="card__title">수리 가능 분야<span class="req">*</span></h2>
						<span class="muted" style="font-size:15px">1개 이상</span>
					</div>
					<div class="chip-row">
						<c:forEach var="category" items="${categoryList}">
							<label class="check" style="min-width:190px">
								<input type="checkbox" name="categoryCodes" value="${category.codeId}">
								<c:out value="${category.codeName}"/>
							</label>
						</c:forEach>
					</div>
				</div>

				<!-- 5. 자격증 -->
				<div class="card">
					<div class="card__head">
						<h2 class="card__title">자격증<span class="req">*</span></h2>
						<span class="muted" style="font-size:15px">1개 이상 · 증빙파일 jpg · png · pdf · 각 10MB 이하</span>
					</div>

					<%--
						같은 name 이 3벌 만들어진다. 서버에서는
						licenseNames[i] / licenseIssuedAts[i] / licenseFiles[i] 를
						같은 index 끼리 묶어 한 건으로 조립한다.
						자격증명이 빈 칸이면 그 index 는 통째로 건너뛴다.
					--%>
					<c:forEach var="i" begin="1" end="3">
						<div class="list-card" style="align-items:flex-start">
							<span class="tile tile--sm t-blue"><svg><use href="#i-doc"/></svg></span>
							<div class="list-card__body">
								<div class="field__label" style="margin-bottom:12px">자격증 ${i}</div>
								<div class="field-row">
									<div class="field">
										<label class="field__label">자격증명</label>
										<input class="input" type="text" name="licenseNames" maxlength="100"
										       placeholder="예) 전기기능사">
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

					<div class="field__help" style="margin-top:14px">
						자격증명을 적은 칸만 저장됩니다. 3개를 다 채우지 않아도 됩니다.
						증빙파일은 <b>1개당 10MB까지</b> 올릴 수 있습니다.
					</div>
				</div>

				<div class="card card--flat">
					<%--
						용량 초과 파일은 여기서 먼저 막는다.
						서버까지 올라가면 멀티파트 파싱 단계에서 끊겨 413 이 뜨는데,
						그 단계는 컨트롤러 이전이라 예외 핸들러가 안내 화면으로 못 바꿔준다.
					--%>
					<div id="fileSizeAlert" class="note note--warn" style="display:none; margin-bottom:22px">
						<svg><use href="#i-alert"/></svg>
						<span id="fileSizeAlertText"></span>
					</div>
					<div class="note note--gray" style="margin-bottom:22px">
						<svg><use href="#i-shield"/></svg>
						<span>제출하신 자격증은 자격 확인 용도로만 사용하고 <b>고객에게 공개되지 않습니다.</b>
						본인 확인용 사진만 고객에게 보입니다.</span>
					</div>
					<button type="submit" class="btn btn--primary btn--xl btn--block">
						<svg class="ico"><use href="#i-send"/></svg>인증 신청하기</button>
				</div>

			</form>

			<script>
			(function () {
				// application.properties 의 spring.servlet.multipart.max-file-size 와 같은 값이어야 한다.
				var MAX_MB = 10;
				var MAX_BYTES = MAX_MB * 1024 * 1024;

				var form  = document.querySelector('form[action="/fixer/verify"]');
				var box   = document.getElementById('fileSizeAlert');
				var text  = document.getElementById('fileSizeAlertText');
				if (!form || !box || !text) return;

				function tooBig() {
					var over = [];
					var inputs = form.querySelectorAll('input[type=file]');
					for (var i = 0; i < inputs.length; i++) {
						var f = inputs[i].files && inputs[i].files[0];
						if (f && f.size > MAX_BYTES) {
							over.push(f.name + ' (' + (f.size / 1024 / 1024).toFixed(1) + 'MB)');
						}
					}
					return over;
				}

				function check() {
					var over = tooBig();
					if (over.length === 0) { box.style.display = 'none'; return true; }
					text.innerHTML = '<b>파일 1개당 ' + MAX_MB + 'MB까지</b> 올릴 수 있습니다. '
					               + '아래 파일을 빼거나 용량을 줄여주세요.<br>' + over.join('<br>');
					box.style.display = '';
					box.scrollIntoView({ behavior: 'smooth', block: 'center' });
					return false;
				}

				// 파일을 고르는 즉시 알려준다. 제출까지 기다리게 하지 않는다.
				form.addEventListener('change', function (e) {
					if (e.target && e.target.type === 'file') check();
				});

				form.addEventListener('submit', function (e) {
					if (!check()) e.preventDefault();
				});
			})();
			</script>

		</c:otherwise>
	</c:choose>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
