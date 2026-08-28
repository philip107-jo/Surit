<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>고객센터 | 수릿 Surit</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main>
<div class="container">

  <div class="page-head">
    <h1>고객센터</h1>
    <p>궁금한 점을 빠르게 확인하거나, 직접 문의해 주세요.</p>
  </div>

  <div class="kpis" style="margin-bottom:56px">
    <div class="kpi kpi--blue">
      <div class="kpi__label">전화 문의</div>
      <div class="kpi__value" style="font-size:26px">1600-0000</div>
      <div class="muted" style="margin-top:8px">평일 09:00 ~ 18:00</div>
    </div>
    <div class="kpi">
      <div class="kpi__label">이메일 문의</div>
      <div class="kpi__value" style="font-size:22px">help@surit.kr</div>
      <div class="muted" style="margin-top:8px">1~2 영업일 내 답변</div>
    </div>
    <div class="kpi kpi--accent">
      <div class="kpi__label">채팅 문의</div>
      <div class="kpi__value" style="font-size:22px">실시간 채팅</div>
      <a class="btn btn--accent btn--sm" style="margin-top:10px" href="${pageContext.request.contextPath}/chat">문의하기</a>
    </div>
  </div>

  <div class="sec-head"><h2>자주 묻는 질문</h2></div>

  <div class="faq">
    <div class="faq__item">
      <button class="faq__q" type="button">
        수리 접수 후 언제 기사님과 연결되나요?
        <svg class="ico"><use href="#i-chevd"/></svg>
      </button>
      <div class="faq__a">보통 접수 후 몇 분 안에 주변 기사님들이 견적을 보내드립니다. 마이페이지에서 실시간으로 견적 현황을 확인할 수 있어요.</div>
    </div>
    <div class="faq__item">
      <button class="faq__q" type="button">
        기사님을 선택하기 전에 비용이 발생하나요?
        <svg class="ico"><use href="#i-chevd"/></svg>
      </button>
      <div class="faq__a">아니요. 기사님을 선택하고 방문이 확정되기 전까지는 어떤 비용도 발생하지 않습니다. 수리비는 작업 완료 후 현장에서 결제합니다.</div>
    </div>
    <div class="faq__item">
      <button class="faq__q" type="button">
        접수를 취소하고 싶어요.
        <svg class="ico"><use href="#i-chevd"/></svg>
      </button>
      <div class="faq__a">마이페이지 &gt; 나의 접수에서 매칭 완료 전까지는 언제든 취소할 수 있습니다.</div>
    </div>
    <div class="faq__item">
      <button class="faq__q" type="button">
        수리 기사로 활동하고 싶어요.
        <svg class="ico"><use href="#i-chevd"/></svg>
      </button>
      <div class="faq__a">마이페이지 &gt; 기사로 전환에서 자격증/신분 인증을 거치면 기사로 활동을 시작할 수 있습니다.</div>
    </div>
  </div>

  <div class="note note--gray" style="margin-top:44px;justify-content:center">
    <svg class="ico"><use href="#i-shield"/></svg>
    <span>원하는 답을 못 찾으셨다면 위 채팅 문의를 이용해 주세요.</span>
  </div>

</div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

</body>
</html>