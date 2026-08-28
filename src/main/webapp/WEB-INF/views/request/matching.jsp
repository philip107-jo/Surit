<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>화면 목록 | 수릿 Surit</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main>
<div class="container">

  <div class="page-head">
    <h1>수릿 화면 목록</h1>
    <p>총 34개 화면 · 클릭하면 화면이 열립니다</p>
  </div>

  <%-- 전체 흐름도: 원본 파일의 .flow 스타일 그대로 유지 --%>
  <style>
  .flow{background:var(--g-900);color:#D1D5DB;padding:24px 26px;border-radius:16px;
    font-size:14px;line-height:1.9;white-space:pre;overflow-x:auto;
    font-family:ui-monospace,monospace;margin-bottom:44px}
  </style>
  <div class="flow">/  ─┬─▶ /request ─▶ /orders/{id}/matching ─▶ /orders/{id} ─▶ 리뷰 작성
    │                                            └─▶ /chat
    ├─▶ /user/mypage ─▶ /orders/{id}
    └─▶ /support ─▶ /chat (수릿 문의하기)

기사   /fixer/requests ─▶ /fixer/requests/{id} (예상 견적 제시)
            ─▶ 고객이 선택 ─▶ /fixer/jobs/{id} (매칭 확인 · 수락/취소)
            ─▶ /fixer/chat (방문 일정 확정 → 접수 정보에 저장)
            ─▶ /fixer/jobs/{id}/booking (예약 확정 · 취소 · 채팅)
            ─▶ 방문 · 수리 ─▶ 현장 결제
            ─▶ /fixer/jobs/{id}/complete (결제 금액으로 영수증 · 견적서 발행)

관리자 /admin ─┬─▶ /admin/members  ├─▶ /admin/blacklist
              ├─▶ /admin/reviews  └─▶ /admin/inquiries</div>

  <%-- ============================================================
       ⚠ "확인필요" 뱃지가 없는 항목만 실제 컨트롤러 매핑과 대조 확인됨.
       나머지는 아직 컨트롤러가 없거나(채팅/관리자/기사 작업 화면 등)
       naming이 다를 수 있어(partner → fixer 등) 확인 후 수정하세요.
       ============================================================ --%>

  <div class="sec-head"><h2>고객 화면</h2></div>
  <div style="margin-bottom:40px">
    <a class="list-card" href="${pageContext.request.contextPath}/">
      <div class="list-card__body">
        <div class="list-card__title">메인페이지</div>
        <div class="list-card__meta">
          <span class="badge badge--primary">/</span>
          <span class="muted">home/index.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/request/request">
      <div class="list-card__body">
        <div class="list-card__title">수리 접수</div>
        <div class="list-card__meta">
          <span class="badge badge--primary">/request/request</span>
          <span class="muted">request/request.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/orders/matching">
      <div class="list-card__body">
        <div class="list-card__title">기사 매칭 · 선택 <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/orders/{id}/matching</span>
          <span class="muted">matching.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/fixers">
      <div class="list-card__body">
        <div class="list-card__title">기사 프로필 (고객이 보는 화면) <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/fixers/{id}</span>
          <span class="muted">tech-profile.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/orders">
      <div class="list-card__body">
        <div class="list-card__title">접수 상세 · 진행 중 (예약 확정) <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/orders/{id}</span>
          <span class="muted">order-progress.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/orders">
      <div class="list-card__body">
        <div class="list-card__title">접수 상세 · 리뷰 작성 (완료) <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/orders/{id}</span>
          <span class="muted">order-detail.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/chat">
      <div class="list-card__body">
        <div class="list-card__title">채팅 (고객) <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/chat</span>
          <span class="muted">chat.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/support">
      <div class="list-card__body">
        <div class="list-card__title">고객센터 <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/support</span>
          <span class="muted">support.jsp</span>
        </div>
      </div>
    </a>
  </div>

  <div class="sec-head"><h2>마이페이지</h2></div>
  <div style="margin-bottom:40px">
    <a class="list-card" href="${pageContext.request.contextPath}/user/mypage">
      <div class="list-card__body">
        <div class="list-card__title">나의 접수</div>
        <div class="list-card__meta">
          <span class="badge badge--primary">/user/mypage</span>
          <span class="muted">user/mypage.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/user/mypage/address">
      <div class="list-card__body">
        <div class="list-card__title">주소 관리 <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/user/mypage/address</span>
          <span class="muted">mypage-address.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/user/mypage/address/form">
      <div class="list-card__body">
        <div class="list-card__title">주소 추가 · 수정 <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/user/mypage/address/form</span>
          <span class="muted">mypage-address-form.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/user/mypage/profile">
      <div class="list-card__body">
        <div class="list-card__title">내 정보 수정 <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/user/mypage/profile</span>
          <span class="muted">mypage-profile.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/user/mypage/reviews">
      <div class="list-card__body">
        <div class="list-card__title">내가 쓴 리뷰 <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/user/mypage/reviews</span>
          <span class="muted">mypage-reviews.jsp</span>
        </div>
      </div>
    </a>
  </div>

  <div class="sec-head"><h2>계정</h2></div>
  <div style="margin-bottom:40px">
    <a class="list-card" href="${pageContext.request.contextPath}/user/login">
      <div class="list-card__body">
        <div class="list-card__title">로그인</div>
        <div class="list-card__meta">
          <span class="badge badge--primary">/user/login</span>
          <span class="muted">user/login.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/user/sign">
      <div class="list-card__body">
        <div class="list-card__title">회원가입</div>
        <div class="list-card__meta">
          <span class="badge badge--primary">/user/sign</span>
          <span class="muted">user/sign.jsp</span>
        </div>
      </div>
    </a>
  </div>

  <div class="sec-head"><h2>수리 기사</h2></div>
  <div style="margin-bottom:40px">
    <a class="list-card" href="${pageContext.request.contextPath}/fixer/requests">
      <div class="list-card__body">
        <div class="list-card__title">접수 찾기</div>
        <div class="list-card__meta">
          <span class="badge badge--primary">/fixer/requests</span>
          <span class="muted">fixer/requests.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/fixer/requests">
      <div class="list-card__body">
        <div class="list-card__title">새 접수 상세 · 예상 견적 제시</div>
        <div class="list-card__meta">
          <span class="badge badge--primary">/fixer/requests/{requestId}</span>
          <span class="muted">fixer/requestDetail.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/fixer/jobs">
      <div class="list-card__body">
        <div class="list-card__title">내 작업 <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/fixer/jobs</span>
          <span class="muted">fixer/jobs.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/fixer/jobs">
      <div class="list-card__body">
        <div class="list-card__title">내 작업 상세 · 매칭 확인 <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/fixer/jobs/{id}</span>
          <span class="muted">fixer/jobDetail.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/fixer/jobs">
      <div class="list-card__body">
        <div class="list-card__title">예약 확정 · 취소 <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/fixer/jobs/{id}/booking</span>
          <span class="muted">partner-booking.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/fixer/jobs">
      <div class="list-card__body">
        <div class="list-card__title">현장 결제 · 수리 완료 처리 <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/fixer/jobs/{id}/complete</span>
          <span class="muted">partner-complete.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/fixer/chat">
      <div class="list-card__body">
        <div class="list-card__title">채팅 (기사) <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/fixer/chat</span>
          <span class="muted">partner-chat.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/fixer/blocked">
      <div class="list-card__body">
        <div class="list-card__title">차단 고객 <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/fixer/blocked</span>
          <span class="muted">partner-blocked.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/fixer/verify">
      <div class="list-card__body">
        <div class="list-card__title">기사 인증 · 자격증 제출</div>
        <div class="list-card__meta">
          <span class="badge badge--primary">/fixer/verify</span>
          <span class="muted">fixer/verify.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/fixer/mypage">
      <div class="list-card__body">
        <div class="list-card__title">기사 마이페이지 · 수리 정보 <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/fixer/mypage</span>
          <span class="muted">partner-mypage.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/fixer/mypage/address">
      <div class="list-card__body">
        <div class="list-card__title">기사 주소 관리 <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/fixer/mypage/address</span>
          <span class="muted">partner-mypage-address.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/fixer/mypage/address/form">
      <div class="list-card__body">
        <div class="list-card__title">기사 주소 추가 · 수정 <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/fixer/mypage/address/form</span>
          <span class="muted">partner-mypage-address-form.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/fixer/mypage/profile">
      <div class="list-card__body">
        <div class="list-card__title">기사 정보 수정 <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/fixer/mypage/profile</span>
          <span class="muted">partner-mypage-profile.jsp</span>
        </div>
      </div>
    </a>
  </div>

  <div class="sec-head"><h2>관리자</h2></div>
  <div style="margin-bottom:40px">
    <a class="list-card" href="${pageContext.request.contextPath}/admin">
      <div class="list-card__body">
        <div class="list-card__title">접수 현황 <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/admin</span>
          <span class="muted">admin.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/admin/members">
      <div class="list-card__body">
        <div class="list-card__title">회원 · 기사 관리 <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/admin/members</span>
          <span class="muted">admin-members.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/admin/members">
      <div class="list-card__body">
        <div class="list-card__title">기사 심사 상세 (자격증 확인) <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/admin/members/{id}</span>
          <span class="muted">admin-member-detail.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/admin/blacklist">
      <div class="list-card__body">
        <div class="list-card__title">블랙리스트 <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/admin/blacklist</span>
          <span class="muted">admin-blacklist.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/admin/reviews">
      <div class="list-card__body">
        <div class="list-card__title">리뷰 관리 <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/admin/reviews</span>
          <span class="muted">admin-reviews.jsp</span>
        </div>
      </div>
    </a>
    <a class="list-card" href="${pageContext.request.contextPath}/admin/inquiries">
      <div class="list-card__body">
        <div class="list-card__title">문의 응대 <span class="badge badge--warn">확인필요</span></div>
        <div class="list-card__meta">
          <span class="badge badge--gray">/admin/inquiries</span>
          <span class="muted">admin-inquiry.jsp</span>
        </div>
      </div>
    </a>
  </div>

</div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

</body>
</html>