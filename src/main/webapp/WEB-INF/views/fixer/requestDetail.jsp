<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<%@ include file="common/icons.jspf" %>
<c:set var="navActive" value="requests"/>

<div class="container" style="max-width:900px">

	<div class="page-head page-head--plain">
		<h1><c:out value="${repair.title}"/>
			<span class="badge st-matching"><c:out value="${repair.statusName}"/></span></h1>
		<p>접수번호 ${repair.requestId} ·
			<c:out value="${repair.customerName}"/> 고객님 ·
			<fmt:formatDate value="${repair.createdAt}" pattern="yyyy-MM-dd HH:mm"/> 접수</p>
	</div>

	<!-- 고객이 남긴 내용 -->
	<div class="card">
		<div class="card__head"><h2 class="card__title">고객이 남긴 내용</h2></div>

		<%-- 줄바꿈은 살리고, HTML 은 이스케이프한다 --%>
		<p style="font-size:17px;line-height:1.85;color:var(--g-700);white-space:pre-wrap;margin-bottom:22px"><c:out value="${repair.content}"/></p>

		<div class="field__label" style="margin-bottom:10px">고장 사진</div>
		<c:choose>
			<c:when test="${empty repair.photos}">
				<p class="muted">등록된 사진이 없습니다.</p>
			</c:when>
			<c:otherwise>
				<%--
					접수 1건에 사진은 여러 장(1:N)이라 접수 SELECT 한 방에 못 담는다.
					서비스가 selectPhotos 로 따로 조회해서 setPhotos 로 붙여준 목록이다.
				--%>
				<div class="upload">
					<c:forEach var="photo" items="${repair.photos}">
						<img src="<c:out value='${photo.photoPath}'/>" alt="고장 사진"
						     style="width:132px;height:132px;object-fit:cover;border-radius:12px;border:1px solid var(--g-200)">
					</c:forEach>
				</div>
			</c:otherwise>
		</c:choose>

		<div style="margin-top:26px;padding-top:24px;border-top:1px solid var(--g-100)">
			<dl class="dl--inline">
				<dt>분야</dt><dd><c:out value="${repair.categoryName}"/></dd>
				<dt>위치</dt><dd><c:out value="${repair.serviceAddress}"/></dd>
				<dt>상태</dt><dd><c:out value="${repair.statusName}"/></dd>
				<dt>받은 견적</dt><dd>${repair.estimateCount}건</dd>
			</dl>
		</div>

		<div class="note note--gray" style="margin-top:24px">
			<svg><use href="#i-lock"/></svg>
			<span>고객 연락처와 상세 주소는 <b>고객이 내 견적을 선택한 뒤</b>에 내 작업 화면에서 열립니다.</span>
		</div>
	</div>

	<!-- 견적 -->
	<c:choose>
		<c:when test="${not empty repair.myEstimateId}">
			<div class="card card--flat">
				<div class="note note--ok" style="margin-bottom:22px">
					<svg><use href="#i-check"/></svg>
					<span><b>이미 견적을 제출한 접수입니다.</b> 같은 접수에는 한 번만 낼 수 있습니다.</span>
				</div>
				<a class="btn btn--ghost btn--lg btn--block" href="/fixer/estimates">
					<svg class="ico"><use href="#i-doc"/></svg>내 견적 보기</a>
			</div>
		</c:when>
		<c:otherwise>
			<div class="card card--flat">
				<a class="btn btn--primary btn--xl btn--block"
				   href="/fixer/estimates/new?requestId=${repair.requestId}">
					<svg class="ico"><use href="#i-send"/></svg>예상 견적 제시하기</a>
			</div>
		</c:otherwise>
	</c:choose>

	<p style="margin-top:24px"><a href="/fixer/requests">← 목록으로</a></p>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
