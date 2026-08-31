<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>접수 상세 | 수릿 Surit</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
</head>
<body>

<svg width="0" height="0" style="position:absolute" aria-hidden="true">
<defs>
<symbol id="i-user" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></symbol>
<symbol id="i-star" viewBox="0 0 24 24"><path d="M12 2.6l2.9 6 6.6.9-4.8 4.6 1.2 6.6L12 17.6 6.1 20.7l1.2-6.6L2.5 9.5l6.6-.9z"/></symbol>
<symbol id="i-check" viewBox="0 0 24 24"><path d="M4.5 12.5 9.5 17.5 19.5 6.5"/></symbol>
<symbol id="i-chat" viewBox="0 0 24 24"><path d="M4 6.5A2.5 2.5 0 0 1 6.5 4h11A2.5 2.5 0 0 1 20 6.5v8a2.5 2.5 0 0 1-2.5 2.5H9.5L4 21.5z"/></symbol>
<symbol id="i-shield" viewBox="0 0 24 24"><path d="M12 3l7 3v5.5c0 4.4-3 8-7 9.5-4-1.5-7-5.1-7-9.5V6z"/><path d="M9.2 12l2 2 3.6-3.8"/></symbol>
<symbol id="i-x" viewBox="0 0 24 24"><path d="M6 6l12 12"/><path d="M18 6L6 18"/></symbol>
</defs>
</svg>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main>
<div class="container">

  <div class="page-head page-head--plain">
    <h1>
      <c:out value="${request.title}"/>
      <span class="badge st-assigned"><c:out value="${request.statusName}"/></span>
    </h1>
    <p><fmt:formatDate value="${request.createdAt}" pattern="yyyy.MM.dd HH:mm"/> 접수</p>
  </div>

  <%-- 진행 단계: 매칭완료 단계 (아직 방문 전) --%>
  <div style="margin-bottom:40px">
    <div class="steps">
      <div class="steps__item done">
        <div class="steps__dot"><svg><use href="#i-check"/></svg></div>
        <div class="steps__label">접수 완료</div>
      </div>
      <div class="steps__item done">
        <div class="steps__dot"><svg><use href="#i-check"/></svg></div>
        <div class="steps__label">기사 매칭</div>
      </div>
      <div class="steps__item now">
        <div class="steps__dot">3</div>
        <div class="steps__label">방문 · 수리</div>
      </div>
      <div class="steps__item">
        <div class="steps__dot">4</div>
        <div class="steps__label">수리 완료</div>
      </div>
    </div>
  </div>

  <%-- 접수 정보 --%>
  <div class="summary" style="margin-bottom:24px">
    <div class="summary__body">
      <div class="summary__title">접수 정보</div>
      <div class="summary__meta">
        <span>카테고리 <b><c:out value="${request.categoryName}"/></b></span>
        <span>방문 주소 <b><c:out value="${request.serviceAddress}"/></b></span>
      </div>
    </div>
    <div class="summary__actions">
      <form method="post" action="${pageContext.request.contextPath}/request/${request.requestId}/cancel">
        <button type="submit" class="btn btn--danger btn--sm">
          <svg class="ico"><use href="#i-x"/></svg>접수 취소
        </button>
      </form>
    </div>
  </div>

  <%-- 담당 기사 (선택된 견적의 기사) --%>
  <c:if test="${not empty selectedEstimate}">
    <div class="card">
      <div class="card__head"><h2 class="card__title">담당 기사님</h2></div>
      <div style="display:flex;align-items:center;gap:20px">
        <span class="avatar avatar--lg"><svg><use href="#i-user"/></svg></span>
        <div>
          <div style="font-size:21px;font-weight:700"><c:out value="${selectedEstimate.fixerName}"/> 기사님</div>
        </div>
        <%-- ⚠ /chat 컨트롤러 아직 미확인 --%>
        <a class="btn btn--soft btn--lg" style="margin-left:auto"
           href="${pageContext.request.contextPath}/chat">
          <svg class="ico"><use href="#i-chat"/></svg>채팅으로 문의하기
        </a>
      </div>
    </div>

    <%-- 견적 요약 --%>
    <div class="card">
      <div class="card__head">
        <h2 class="card__title">기사님이 보낸 견적</h2>
        <span class="muted" style="font-size:15px">
          <fmt:formatDate value="${selectedEstimate.createdAt}" pattern="MM.dd HH:mm"/> 전송
        </span>
      </div>
      <c:if test="${not empty selectedEstimate.content}">
        <p style="font-size:16.5px;color:var(--g-700);line-height:1.7;margin-bottom:20px">
          <c:out value="${selectedEstimate.content}"/>
        </p>
      </c:if>
      <div style="display:flex;justify-content:space-between;align-items:center;
        padding-top:20px;border-top:2px solid var(--g-200)">
        <span style="font-size:18px;font-weight:700">예상 견적</span>
        <span style="font-size:32px;font-weight:800;letter-spacing:-1.4px">
          <fmt:formatNumber value="${selectedEstimate.estimatedPrice}" pattern="#,##0"/>원
        </span>
      </div>
      <c:if test="${not empty selectedEstimate.estimatedDuration}">
        <p class="muted" style="margin-top:10px">예상 소요 시간 약 ${selectedEstimate.estimatedDuration}분</p>
      </c:if>
      <div class="note note--blue" style="margin-top:22px">
        <svg><use href="#i-shield"/></svg>
        <span>현장 확인 후 금액이 달라질 수 있습니다. 달라지면 <b>수리 전에 기사님이 먼저 알려드리고</b>,
        최종 금액은 수리를 마친 뒤 영수증 겸 견적서로 받게 됩니다.</span>
      </div>
    </div>
  </c:if>

  <%-- 접수 내용 --%>
  <div class="card">
    <div class="card__head"><h2 class="card__title">접수 내용</h2></div>
    <p style="font-size:16.5px;color:var(--g-700)">
      <c:out value="${request.content}"/>
    </p>
  </div>

</div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
<script src="${pageContext.request.contextPath}/js/common.js"></script>
</body>
</html>