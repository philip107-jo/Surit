<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>주소 관리 | 수릿 Surit</title>
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
      <a href="${pageContext.request.contextPath}/user/mypage/address" class="is-active">
        <svg class="ico"><use href="#i-home"/></svg>주소 관리
      </a>
      <a href="${pageContext.request.contextPath}/user/mypage/profile">
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
      <div class="sec-head sec-head--row" style="margin-bottom:20px">
        <h2>주소 관리</h2>
        <a class="btn btn--primary btn--sm" href="${pageContext.request.contextPath}/user/mypage/address/form">
          <svg class="ico"><use href="#i-plus"/></svg>주소 추가
        </a>
      </div>

      
      <c:choose>
        <c:when test="${empty addressList}">
          <div class="empty">
            <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><use href="#i-home"/></svg>
            <p>등록된 주소가 없습니다.</p>
          </div>
        </c:when>
        <c:otherwise>
          <c:forEach var="addr" items="${addressList}">
            <div class="list-card">
              <div class="list-card__body">
                <div class="list-card__title">
                  <c:out value="${addr.address}"/>
                  <c:if test="${addr.isDefault == 'Y'}">
                    <span class="badge badge--primary">기본 주소</span>
                  </c:if>
                </div>
                <div class="list-card__meta">
                  <c:out value="${addr.addressDetail}"/>
                </div>
              </div>
              <div class="btn-row">
                <a class="btn btn--ghost btn--sm" href="${pageContext.request.contextPath}/user/mypage/address/form?addressId=${addr.addressId}">수정</a>
                <form method="post" action="${pageContext.request.contextPath}/user/mypage/address/${addr.addressId}/delete" style="display:inline">
                  <button type="submit" class="btn btn--danger btn--sm">삭제</button>
                </form>
              </div>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

</div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
<script src="/js/common.js"></script>
</body>
</html>