<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="auth">

    <div class="auth__side">
        <h2>수릿과 함께<br>믿을 수 있는 수리를 시작하세요</h2>
        <p>검증된 기사님과 투명한 견적으로<br>안심하고 맡길 수 있어요.</p>
        <ul>
            <li>
                <svg viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>
                검증된 기사 매칭
            </li>
            <li>
                <svg viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>
                투명한 견적 비교
            </li>
            <li>
                <svg viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>
                실시간 채팅 상담
            </li>
        </ul>
    </div>

    <div class="auth__form">
        <div class="auth__form-inner">
            <h1>회원가입</h1>
            <p>수릿 계정을 만들고 서비스를 이용해보세요</p>

            <c:if test="${ error != null }">
                <div class="note note--warn">
                    <svg viewBox="0 0 24 24"><path d="M12 9v4M12 17h.01M10.29 3.86l-8.18 14.14A2 2 0 0 0 3.82 21h16.36a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/></svg>
                    <p>${ error }</p>
                </div>
            </c:if>

            <form id="sign-form" action="/user/join" method="post">

                <div class="form-sec">
                    <div class="form-sec__head">
                        <div class="form-sec__no">1</div>
                        <div>
                            <div class="form-sec__title">회원 정보</div>
                            <div class="form-sec__desc">로그인에 사용할 정보를 입력해주세요</div>
                        </div>
                    </div>

                    <div class="field">
                        <label class="field__label" for="user-id">아이디<span class="req">*</span></label>
                        <div class="field-row">
                            <input type="text" id="user-id" name="userId" class="input" required autocomplete="off">
                            <button type="button" id="check-id-btn" class="btn btn--ghost">중복확인</button>
                        </div>
                        <p id="check-id-result" class="field__help" aria-live="polite"></p>
                    </div>

                    <div class="field">
                        <label class="field__label" for="user-pwd">비밀번호<span class="req">*</span></label>
                        <input type="password" id="user-pwd" name="userPwd" class="input" required>
                    </div>

                    <div class="field">
                        <label class="field__label" for="user-pwd-confirm">비밀번호 확인<span class="req">*</span></label>
                        <input type="password" id="user-pwd-confirm" class="input" required>
                        <p id="check-pwd-result" class="field__help" aria-live="polite"></p>
                    </div>

                    <div class="field">
                        <label class="field__label" for="user-name">이름<span class="req">*</span></label>
                        <input type="text" id="user-name" name="userName" class="input" required>
                    </div>

                    <div class="field-row">
                        <div class="field">
                            <label class="field__label" for="user-pnumber">전화번호</label>
                            <input type="text" id="user-pnumber" name="userPnumber" class="input"
                                placeholder="01012345678" autocomplete="off">
                        </div>

                        <div class="field">
                            <label class="field__label" for="user-email">이메일</label>
                            <input type="email" id="user-email" name="userEmail" class="input" autocomplete="off">
                        </div>
                    </div>
                </div>

                <div class="form-sec">
                    <div class="form-sec__head">
                        <div class="form-sec__no">2</div>
                        <div>
                            <div class="form-sec__title">기본 주소</div>
                            <div class="form-sec__desc">수리 접수 시 방문지로 사용할 주소예요 (나중에 추가·변경 가능)</div>
                        </div>
                    </div>

                    <div class="field">
                        <label class="field__label" for="zipcode">우편번호</label>
                        <div class="field-row">
                            <input type="text" id="zipcode" name="zipcode" class="input" autocomplete="off">
                            <button type="button" id="search-zipcode-btn" class="btn btn--ghost">우편번호 검색</button>
                        </div>
                    </div>

                    <div class="field">
                        <label class="field__label" for="address-basic">기본주소</label>
                        <input type="text" id="address-basic" name="addressBasic" class="input" readonly>
                    </div>

                    <div class="field">
                        <label class="field__label" for="address-detail">상세주소</label>
                        <input type="text" id="address-detail" name="addressDetail" class="input" autocomplete="off">
                    </div>

                    <div class="field">
                        <label class="field__label" for="address-name">주소 별칭</label>
                        <input type="text" id="address-name" name="addressName" class="input"
                            placeholder="예: 집, 회사" autocomplete="off">
                    </div>

                    <label class="check">
                        <input type="checkbox" name="isDefault" value="1" checked>
                        기본 주소로 설정
                    </label>
                </div>

                <button type="submit" class="btn btn--primary btn--block btn--lg">가입하기</button>
            </form>

            <div class="auth__bottom">
                이미 계정이 있으신가요?
                <a href="/user/login">로그인</a>
            </div>
        </div>
    </div>

</div>

<script src="/js/common.js"></script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
