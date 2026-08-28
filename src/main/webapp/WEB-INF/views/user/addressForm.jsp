<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>주소 <c:out value="${empty address ? '추가' : '수정'}"/> | 수릿 Surit</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main>
<div class="container">

  <div class="page-head page-head--plain">
    <h1>주소 <c:out value="${empty address ? '추가' : '수정'}"/></h1>
  </div>

  <div class="card" style="max-width:640px;margin:0 auto">
    <%--
      ⚠ UserAddressDTO 실제 필드명 확인 필요. 아래는 추정치.
      신규 추가면 address 모델 attribute가 비어있다고 가정.
    --%>
    <form method="post"
          action="${pageContext.request.contextPath}/user/mypage/address${empty address ? '' : '/'.concat(address.addressId)}">

      <div class="field">
        <label class="field__label" for="addr-zip">우편번호</label>
        <input type="text" id="addr-zip" name="zipCode" class="input"
               value="${address.zipCode}" placeholder="예: 06134">
      </div>

      <div class="field">
        <label class="field__label" for="addr-address">주소<span class="req">*</span></label>
        <input type="text" id="addr-address" name="address" class="input"
               value="${address.address}" placeholder="예: 서울 강남구 테헤란로 123" required>
      </div>

      <div class="field">
        <label class="field__label" for="addr-detail">상세 주소</label>
        <input type="text" id="addr-detail" name="addressDetail" class="input"
               value="${address.addressDetail}" placeholder="예: 101동 1502호">
      </div>

      <div class="field">
        <label class="check">
          <input type="checkbox" id="is-default-checkbox"
                 ${address.isDefault == 'Y' ? 'checked' : ''}>
          기본 주소로 설정
        </label>
        <input type="hidden" id="is-default" name="isDefault" value="${address.isDefault == 'Y' ? 'Y' : 'N'}">
      </div>

      <div class="btn-row" style="margin-top:8px">
        <a class="btn btn--ghost btn--block" href="${pageContext.request.contextPath}/user/mypage/address">취소</a>
        <button type="submit" class="btn btn--primary btn--block">저장</button>
      </div>
    </form>
  </div>

</div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
<script src="/js/common.js"></script>
</body>
</html>