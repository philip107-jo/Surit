<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>내 정보 수정 | 수릿 Surit</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main>
<div class="container">

  <div class="page-head page-head--plain">
    <h1>마이페이지</h1>
  </div>

  <div class="with-side">
    <nav class="side-nav">
      <a href="${pageContext.request.contextPath}/user/mypage">
        <svg class="ico"><use href="#i-list"/></svg>나의 접수
      </a>
      <a href="${pageContext.request.contextPath}/user/mypage/address">
        <svg class="ico"><use href="#i-home"/></svg>주소 관리
      </a>
      <a href="${pageContext.request.contextPath}/user/mypage/profile" class="is-active">
        <svg class="ico"><use href="#i-user"/></svg>내 정보 수정
      </a>
      <a href="${pageContext.request.contextPath}/user/mypage/reviews">
        <svg class="ico"><use href="#i-star"/></svg>내가 쓴 리뷰
      </a>
      <a href="${pageContext.request.contextPath}/support">
        <svg class="ico"><use href="#i-chat"/></svg>고객센터
      </a>
    </nav>

    <div>
      <div class="sec-head" style="margin-bottom:20px"><h2>내 정보 수정</h2></div>

      <div class="card" style="max-width:560px">
        <form method="post" action="${pageContext.request.contextPath}/user/mypage/profile">

          <div class="field">
            <label class="field__label">아이디</label>
            <input type="text" class="input" value="${user.userId}" disabled>
          </div>

          <div class="field">
            <label class="field__label" for="p-name">이름<span class="req">*</span></label>
            <input type="text" id="p-name" name="name" class="input" value="${user.name}" required>
          </div>

          <div class="field">
            <label class="field__label" for="p-email">이메일<span class="req">*</span></label>
            <input type="email" id="p-email" name="email" class="input" value="${user.email}" required>
          </div>

          <div class="field">
            <label class="field__label" for="p-phone">전화번호</label>
            <input type="tel" id="p-phone" name="phone" class="input" value="${user.phone}" placeholder="010-0000-0000">
          </div>

          <hr style="border:0;border-top:1px solid var(--g-200);margin:28px 0">

          <div class="field">
            <label class="field__label" for="p-pwd">새 비밀번호</label>
            <input type="password" id="p-pwd" name="passWord" class="input" placeholder="변경할 때만 입력하세요">
            <div class="field__help">비밀번호를 바꾸지 않으려면 비워두세요.</div>
          </div>

          <div class="field">
            <label class="field__label" for="p-pwd-confirm">새 비밀번호 확인</label>
            <input type="password" id="p-pwd-confirm" name="passWordConfirm" class="input">
          </div>

          <button type="submit" class="btn btn--primary btn--block" style="margin-top:8px">저장</button>
        </form>
      </div>
    </div>
  </div>

</div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
<script src="/js/common.js"></script>
</body>
</html>