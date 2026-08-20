<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>메인 | 수릿 Surit</title>
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/pages.css">

</head>
<body>
<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs><symbol id="i-tools" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol><symbol id="i-lock" viewBox="0 0 24 24"><rect x="5" y="10" width="14" height="10" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/><circle cx="12" cy="15" r="1.4" fill="currentColor" stroke="none"/></symbol><symbol id="i-fridge" viewBox="0 0 24 24"><rect x="6" y="3" width="12" height="18" rx="2"/><path d="M6 10h12"/><path d="M9 6v2"/><path d="M9 13v2.5"/></symbol><symbol id="i-pc" viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="12" rx="2"/><path d="M9 21h6"/><path d="M12 17v4"/></symbol><symbol id="i-drop" viewBox="0 0 24 24"><path d="M12 3c4 4.5 6 7 6 9a6 6 0 0 1-12 0c0-2 2-4.5 6-9z"/></symbol><symbol id="i-bolt" viewBox="0 0 24 24"><path d="M13 2 5 14h6l-1 8 8-12h-6l1-8z"/></symbol><symbol id="i-washer" viewBox="0 0 24 24"><rect x="5" y="3" width="14" height="18" rx="2"/><circle cx="12" cy="14" r="4"/><path d="M8 6.5h2"/></symbol><symbol id="i-ac" viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="7" rx="2"/><path d="M8 15q2 2 0 4"/><path d="M12 15q2 2 0 4"/><path d="M16 15q2 2 0 4"/></symbol><symbol id="i-chair" viewBox="0 0 24 24"><rect x="6" y="3" width="12" height="8" rx="2"/><path d="M5 13h14"/><path d="M7 21v-4"/><path d="M17 21v-4"/></symbol><symbol id="i-dots" viewBox="0 0 24 24"><circle cx="5" cy="12" r="1.6" fill="currentColor" stroke="none"/><circle cx="12" cy="12" r="1.6" fill="currentColor" stroke="none"/><circle cx="19" cy="12" r="1.6" fill="currentColor" stroke="none"/></symbol><symbol id="i-pin" viewBox="0 0 24 24"><path d="M12 21s7-6.2 7-11a7 7 0 1 0-14 0c0 4.8 7 11 7 11z"/><circle cx="12" cy="10" r="2.6"/></symbol><symbol id="i-clock" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3.5 2"/></symbol><symbol id="i-chat" viewBox="0 0 24 24"><path d="M4 6.5A2.5 2.5 0 0 1 6.5 4h11A2.5 2.5 0 0 1 20 6.5v8a2.5 2.5 0 0 1-2.5 2.5H9.5L4 21.5z"/></symbol><symbol id="i-shield" viewBox="0 0 24 24"><path d="M12 3l7 3v5.5c0 4.4-3 8-7 9.5-4-1.5-7-5.1-7-9.5V6z"/><path d="M9.2 12l2 2 3.6-3.8"/></symbol><symbol id="i-card" viewBox="0 0 24 24"><rect x="2.5" y="5.5" width="19" height="13" rx="2.5"/><path d="M2.5 10h19"/></symbol><symbol id="i-search" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="M16.2 16.2 21 21"/></symbol><symbol id="i-bell" viewBox="0 0 24 24"><path d="M18 15V10a6 6 0 1 0-12 0v5l-1.6 2.5h15.2z"/><path d="M10 20.5a2.2 2.2 0 0 0 4 0"/></symbol><symbol id="i-doc" viewBox="0 0 24 24"><path d="M14 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8z"/><path d="M14 3v5h5"/><path d="M9 13h6"/><path d="M9 17h6"/></symbol><symbol id="i-user" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></symbol><symbol id="i-users" viewBox="0 0 24 24"><circle cx="9" cy="8" r="3.6"/><path d="M2.5 20a6.5 6.5 0 0 1 13 0"/><path d="M16 5.2a3.6 3.6 0 0 1 0 6.4"/><path d="M18.5 20a5.6 5.6 0 0 0-3-4.5"/></symbol><symbol id="i-home" viewBox="0 0 24 24"><path d="M4 11.5 12 4l8 7.5"/><path d="M6.5 10.5V20h11v-9.5"/></symbol><symbol id="i-star" viewBox="0 0 24 24"><path d="M12 2.6l2.9 6 6.6.9-4.8 4.6 1.2 6.6L12 17.6 6.1 20.7l1.2-6.6L2.5 9.5l6.6-.9z"/></symbol><symbol id="i-check" viewBox="0 0 24 24"><path d="M4.5 12.5 9.5 17.5 19.5 6.5"/></symbol><symbol id="i-chevd" viewBox="0 0 24 24"><path d="M6 9.5 12 15.5 18 9.5"/></symbol><symbol id="i-chevr" viewBox="0 0 24 24"><path d="M9.5 6 15.5 12 9.5 18"/></symbol><symbol id="i-plus" viewBox="0 0 24 24"><path d="M12 5v14"/><path d="M5 12h14"/></symbol><symbol id="i-camera" viewBox="0 0 24 24"><path d="M4 8h3l1.5-2h7L17 8h3a1 1 0 0 1 1 1v9a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V9a1 1 0 0 1 1-1z"/><circle cx="12" cy="13.5" r="3.6"/></symbol><symbol id="i-image" viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="8.5" cy="10" r="1.6"/><path d="M4 17l5-5 4 4 3-2 4 4"/></symbol><symbol id="i-send" viewBox="0 0 24 24"><path d="M21 3 10.5 13.5"/><path d="M21 3l-7 18-3.5-7.5L3 10z"/></symbol><symbol id="i-refresh" viewBox="0 0 24 24"><path d="M20 11a8 8 0 0 0-13.7-5.3L3 9"/><path d="M4 13a8 8 0 0 0 13.7 5.3L21 15"/><path d="M3 4v5h5"/><path d="M21 20v-5h-5"/></symbol><symbol id="i-logout" viewBox="0 0 24 24"><path d="M14 4h4a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2h-4"/><path d="M10 8l-4 4 4 4"/><path d="M6 12h9"/></symbol><symbol id="i-edit" viewBox="0 0 24 24"><path d="M4 20h4L19 9l-4-4L4 16z"/><path d="M14.5 5.5l4 4"/></symbol><symbol id="i-trash" viewBox="0 0 24 24"><path d="M4 7h16"/><path d="M9 7V5h6v2"/><path d="M6 7l1 13h10l1-13"/></symbol><symbol id="i-alert" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 7.5v5.5"/><circle cx="12" cy="16.5" r="1.1" fill="currentColor" stroke="none"/></symbol><symbol id="i-x" viewBox="0 0 24 24"><path d="M6 6l12 12"/><path d="M18 6L6 18"/></symbol><symbol id="i-ban" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M5.6 5.6l12.8 12.8"/></symbol><symbol id="i-list" viewBox="0 0 24 24"><path d="M8 6h13"/><path d="M8 12h13"/><path d="M8 18h13"/><path d="M3.5 6h.01"/><path d="M3.5 12h.01"/><path d="M3.5 18h.01"/></symbol><symbol id="i-board" viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="16" rx="2"/><path d="M3 9h18"/><path d="M9 9v11"/></symbol><symbol id="i-wrench" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol><symbol id="i-money" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M9.5 9.5h5"/><path d="M9.5 12.5h5"/><path d="M12 7.5v9"/></symbol></defs></svg>
<!-- ▼ Thymeleaf 이식 시 : th:replace="~{fragments/header :: header}" -->
<header class="site-header">
  <div class="site-header__inner">
    <a class="logo" href="index.html">
      <span class="logo__mark"><svg><use href="#i-tools"/></svg></span>
      <span class="logo__text">수릿</span>
      <span class="logo__sub">Surit</span>
    </a>
    <nav class="gnb"><a href="request.html">수리접수</a></nav>
    <div class="header-right"><a class="btn btn--ghost btn--sm" href="login.html">로그인</a><a class="btn btn--primary btn--sm" href="signup.html">회원가입</a></div>
  </div>
</header>

<main>

<section class="hero">
  <div class="container">
    <span class="hero__eyebrow"><i></i>평균 32분 안에 기사님이 방문합니다</span>
    <h1>고장 났을 때<br><em>가장 빠른 방법.</em></h1>
    <p>증상만 남기면 가까운 수리 기사님이 직접 신청합니다.</p>
    <div class="hero__cta">
      <a class="btn btn--primary btn--xl" href="request.html">
        <svg class="ico"><use href="#i-wrench"/></svg>수리 접수하기</a>
      <div class="hero__stat">
        <span>누적 수리 <b>12,400건</b></span><i></i>
        <span>등록 기사 <b>860명</b></span><i></i>
        <span>평균 별점 <b>4.9</b></span>
      </div>
    </div>
  </div>
</section>

<div class="container">
  <nav class="cats"><a href="request.html?cat=lock"><span class="tile t-lock"><svg><use href="#i-lock"/></svg></span><span>도어락 · 잠금</span></a><a href="request.html?cat=fridge"><span class="tile t-frid"><svg><use href="#i-fridge"/></svg></span><span>냉장고 · 가전</span></a><a href="request.html?cat=pc"><span class="tile t-pc"><svg><use href="#i-pc"/></svg></span><span>PC · 노트북</span></a><a href="request.html?cat=pipe"><span class="tile t-drop"><svg><use href="#i-drop"/></svg></span><span>배관 · 누수</span></a><a href="request.html?cat=elec"><span class="tile t-bolt"><svg><use href="#i-bolt"/></svg></span><span>전기 · 조명</span></a><a href="request.html?cat=etc"><span class="tile t-tool"><svg><use href="#i-tools"/></svg></span><span>그 외 수리</span></a></nav>
</div>

<section class="section">
  <div class="container">
    <div class="sec-head center"><h2>수릿은 이렇게 진행돼요</h2>
      <p>접수부터 수리까지 3단계면 끝납니다</p></div>
    <div class="steps3"><div class="card"><span class="num">1</span><span class="tile t-blue"><svg><use href="#i-chat"/></svg></span><h3>증상만 남기세요</h3><p>무엇이 어떻게 고장났는지 적고 사진을 올리면 접수가 끝납니다.</p></div><div class="card"><span class="num">2</span><span class="tile t-blue"><svg><use href="#i-user"/></svg></span><h3>기사님이 신청해요</h3><p>주변 기사님이 직접 신청합니다. 보고 마음에 드는 분을 고르세요.</p></div><div class="card"><span class="num">3</span><span class="tile t-blue"><svg><use href="#i-wrench"/></svg></span><h3>방문해서 고쳐요</h3><p>약속한 시간에 방문해 수리하고, 비용은 그 자리에서 직접 냅니다.</p></div></div>
  </div>
</section>

<section class="section section--gray">
  <div class="container">
    <div class="sec-head center"><h2>고객님이 남긴 후기</h2>
      <p>수릿이 직접 확인한 실제 수리 후기입니다</p></div>
    <div class="reviews"><div class="review"><div class="review__top"><span class="stars "><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg></span><span class="badge badge--primary">도어락 · 잠금</span></div><p class="review__text">밤 11시에 접수했는데 30분 만에 오셨어요. 문을 부수지 않고 열어주셔서 정말 감사합니다.</p><div class="review__foot"><span class="review__who">김＊연 고객님</span><span>2026.08.12</span></div></div><div class="review"><div class="review__top"><span class="stars "><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg></span><span class="badge badge--primary">냉장고 · 가전</span></div><p class="review__text">냉장실만 시원하지 않았는데 원인을 바로 찾아주셨어요. 부품 값도 미리 알려주셔서 믿음이 갔습니다.</p><div class="review__foot"><span class="review__who">이＊훈 고객님</span><span>2026.08.10</span></div></div><div class="review"><div class="review__top"><span class="stars "><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg><svg><use href="#i-star"/></svg></span><span class="badge badge--primary">PC · 노트북</span></div><p class="review__text">부팅이 안 되던 노트북을 살렸습니다. 자료도 그대로 남았고 설명을 천천히 해주셔서 좋았어요.</p><div class="review__foot"><span class="review__who">박＊아 고객님</span><span>2026.08.09</span></div></div></div>
  </div>
</section>

<section class="section--tight">
  <div class="container">
    <div class="join-banner">
      <div>
        <h2>고장은 갑자기, 수리는 수릿으로.</h2>
        <p>회원가입하고 지금 바로 접수해 보세요.</p>
      </div>
      <a class="btn btn--dark btn--lg" href="signup.html">회원가입하기</a>
    </div>
  </div>
</section>

</main>

<!-- ▼ Thymeleaf 이식 시 : th:replace="~{fragments/footer :: footer}" -->
<footer class="site-footer">
  <div class="site-footer__brand">
    <span class="site-footer__mark"><svg><use href="#i-tools"/></svg></span>
    <span>수릿 Surit</span>
  </div>
  <address>
    (주)수릿 | 대표 홍길동 | 사업자등록번호 000-00-00000<br>
    서울특별시 강남구 테헤란로 000 | 통신판매업신고 2026-서울강남-0000<br>
    고객센터 1600-0000 (평일 09:00~18:00) | help@surit.kr
  </address>
  <div class="site-footer__bottom">
    <span>&copy; 2026 Surit. All rights reserved.</span>
    <span><a href="support.html">고객센터</a> &middot; <a href="#">이용약관</a> &middot; <a href="#">개인정보처리방침</a></span>
  </div>
</footer>
<script src="js/common.js"></script>

</body>
</html>
