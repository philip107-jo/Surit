<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

<svg width="0" height="0" style="position:absolute" aria-hidden="true">
<defs>
<symbol id="i-list" viewBox="0 0 24 24"><path d="M8 6h13"/><path d="M8 12h13"/><path d="M8 18h13"/><path d="M3.5 6h.01"/><path d="M3.5 12h.01"/><path d="M3.5 18h.01"/></symbol>
<symbol id="i-home" viewBox="0 0 24 24"><path d="M4 11.5 12 4l8 7.5"/><path d="M6.5 10.5V20h11v-9.5"/></symbol>
<symbol id="i-user" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></symbol>
<symbol id="i-star" viewBox="0 0 24 24"><path d="M12 2.6l2.9 6 6.6.9-4.8 4.6 1.2 6.6L12 17.6 6.1 20.7l1.2-6.6L2.5 9.5l6.6-.9z"/></symbol>
<symbol id="i-chat" viewBox="0 0 24 24"><path d="M4 6.5A2.5 2.5 0 0 1 6.5 4h11A2.5 2.5 0 0 1 20 6.5v8a2.5 2.5 0 0 1-2.5 2.5H9.5L4 21.5z"/></symbol>
<symbol id="i-chevd" viewBox="0 0 24 24"><path d="M6 9.5 12 15.5 18 9.5"/></symbol>
</defs>
</svg>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main>

<div class="container">
  <div class="page-head">
    <h1>고객센터</h1>
    <p>궁금한 점을 먼저 확인해 보세요. 해결되지 않으면 채팅으로 물어보시면 됩니다.</p>
  </div>

  <div class="with-side">
    <nav class="side-nav">
      <a href="${pageContext.request.contextPath}/user/mypage">
        <svg class="ico"><use href="#i-list"/></svg>나의 접수
      </a>
      <a href="${pageContext.request.contextPath}/user/mypage/address">
        <svg class="ico"><use href="#i-home"/></svg>주소 관리
      </a>
      <a href="${pageContext.request.contextPath}/user/mypage/profile">
        <svg class="ico"><use href="#i-user"/></svg>내 정보 수정
      </a>
      <a href="${pageContext.request.contextPath}/user/mypage/reviews">
        <svg class="ico"><use href="#i-star"/></svg>내가 쓴 리뷰
      </a>
      <a href="${pageContext.request.contextPath}/user/mypage/support" class="is-active">
        <svg class="ico"><use href="#i-chat"/></svg>고객센터
      </a>
    </nav>

    <div>
  <div class="faq">
    <div class="faq__item is-open">
      <button class="faq__q" type="button">
        수리 전에 들은 견적과 금액이 달라졌어요.
        <svg class="ico"><use href="#i-chevd"/></svg>
      </button>
      <div class="faq__a">
        기사님이 현장에서 확인 후 추가 작업이 필요한 경우, 반드시 고객님의 동의를 받고 견적서를 다시 보내야 합니다.
        수릿은 현장 직접 결제라 <b>결제 전에 견적서를 꼭 확인</b>해 주세요.
        동의 없이 금액을 요구받으셨다면 결제 전에 문의해 주시면 즉시 조치합니다.
      </div>
    </div>
    <div class="faq__item">
      <button class="faq__q" type="button">
        접수한 내용을 수정하거나 취소할 수 있나요?
        <svg class="ico"><use href="#i-chevd"/></svg>
      </button>
      <div class="faq__a">
        기사님을 수락하기 전에는 언제든 무료로 수정·취소할 수 있습니다.
        수락한 뒤에도 기사님이 방문하기 전까지는 취소가 가능합니다.
      </div>
    </div>
    <div class="faq__item">
      <button class="faq__q" type="button">
        기사님이 방문하기로 한 시간에 오지 않아요.
        <svg class="ico"><use href="#i-chevd"/></svg>
      </button>
      <div class="faq__a">
        먼저 채팅으로 연락해 보시고, 답이 없으면 고객센터로 문의해 주세요.
        반복되는 기사님은 활동이 정지됩니다.
      </div>
    </div>
    <div class="faq__item">
      <button class="faq__q" type="button">
        수리 후 문제가 다시 생기면 A/S를 받을 수 있나요?
        <svg class="ico"><use href="#i-chevd"/></svg>
      </button>
      <div class="faq__a">
        수리 완료일로부터 3개월 이내 동일 증상이 재발하면 같은 기사님께 무상 A/S를 요청할 수 있습니다.
      </div>
    </div>
    <div class="faq__item">
      <button class="faq__q" type="button">
        결제는 어떻게 하나요?
        <svg class="ico"><use href="#i-chevd"/></svg>
      </button>
      <div class="faq__a">
        수릿은 결제를 대행하지 않습니다. 수리가 끝나면 기사님이 보낸 견적서를 확인하고
        <b>현장에서 직접</b> 현금이나 카드로 결제하시면 됩니다.
      </div>
    </div>
    <div class="faq__item">
      <button class="faq__q" type="button">
        주소는 왜 3개까지만 등록되나요?
        <svg class="ico"><use href="#i-chevd"/></svg>
      </button>
      <div class="faq__a">
        집 · 사무실 · 부모님댁처럼 자주 쓰는 곳만 관리하도록 3개로 제한하고 있습니다.
        마이페이지 &gt; 주소 관리에서 언제든 바꿀 수 있습니다.
      </div>
    </div>
  </div>

  <div class="card" style="margin-top:44px;text-align:center;padding:44px">
    <span class="tile t-blue" style="margin:0 auto 20px"><svg><use href="#i-chat"/></svg></span>
    <h2 style="font-size:24px;font-weight:800">원하는 답을 찾지 못하셨나요?</h2>
    <p class="muted" style="font-size:17px;margin:12px 0 26px">
      채팅으로 문의하시면 평일 09:00~18:00 사이에 답변드립니다.
    </p>
    <%-- ⚠ /chat 컨트롤러 아직 미확인 --%>
    <a class="btn btn--primary btn--lg" href="${pageContext.request.contextPath}/chat">
      <svg class="ico"><use href="#i-chat"/></svg>1:1 문의하기
    </a>
  </div>
    </div>
  </div>
</div>

</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
<script src="${pageContext.request.contextPath}/js/common.js"></script>
</body>
</html>