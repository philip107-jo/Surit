<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>수릿 Surit</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
</head>
<body>

<!-- 공통 아이콘 스프라이트 정의 -->
<svg width="0" height="0" style="position:absolute" aria-hidden="true">
    <defs>
        <symbol id="i-tools" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol>
        <symbol id="i-user" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4.5 20.5a7.5 7.5 0 0 1 15 0"/></symbol>
        <symbol id="i-chevd" viewBox="0 0 24 24"><path d="M6 9.5 12 15.5 18 9.5"/></symbol>
        <symbol id="i-refresh" viewBox="0 0 24 24"><path d="M20 11a8 8 0 0 0-13.7-5.3L3 9"/><path d="M4 13a8 8 0 0 0 13.7 5.3L21 15"/><path d="M3 4v5h5"/><path d="M21 20v-5h-5"/></symbol>
        <symbol id="i-logout" viewBox="0 0 24 24"><path d="M14 4h4a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2h-4"/><path d="M10 8l-4 4 4 4"/><path d="M6 12h9"/></symbol>
    </defs>
</svg>

<header class="site-header">
    <div class="site-header__inner">

        <!-- 로고 (기사 권한인 경우 기사 뱃지 표시) -->
        <c:choose>
            <c:when test="${not empty sessionScope.loginMember && sessionScope.loginMember.userRole == 'FIXER'}">
                <a class="logo" href="${pageContext.request.contextPath}/fixer/requests">
                    <span class="logo__mark"><svg><use href="#i-tools"/></svg></span>
                    <span class="logo__text">수릿</span>
                    <span class="logo__badge logo__badge--tech">기사</span>
                </a>
            </c:when>
            <c:otherwise>
                <a class="logo" href="${pageContext.request.contextPath}/">
                    <span class="logo__mark"><svg><use href="#i-tools"/></svg></span>
                    <span class="logo__text">수릿</span>
                </a>
            </c:otherwise>
        </c:choose>

        <!-- 상단 네비게이션 바 (유저 / 기사 맞춤형 메뉴 분기) -->
        <nav class="gnb">
            <c:choose>
                <c:when test="${not empty sessionScope.loginMember && sessionScope.loginMember.userRole == 'FIXER'}">
                    <a href="${pageContext.request.contextPath}/fixer/requests">접수 찾기</a>
                    <a href="${pageContext.request.contextPath}/chat">채팅하기</a>
                    <a href="${pageContext.request.contextPath}/support">고객센터</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/request/request">수리 접수</a>
                    <a href="${pageContext.request.contextPath}/chat">채팅하기</a>
                    <a href="${pageContext.request.contextPath}/support">고객센터</a>
                </c:otherwise>
            </c:choose>
        </nav>

        <!-- 우측 프로필 영역 및 드롭다운 메뉴 -->
        <div class="header-right">
            <c:choose>
                <c:when test="${not empty sessionScope.loginMember}">
                    <div class="profile" id="profile">
                        <button class="profile__btn ${sessionScope.loginMember.userRole == 'FIXER' ? 'profile__btn--tech' : ''}" type="button">
                            <span class="avatar avatar--sm"><svg><use href="#i-user"/></svg></span>
                            <span class="profile__who"><c:out value="${sessionScope.loginMember.name}"/> ${sessionScope.loginMember.userRole == 'FIXER' ? '기사님' : '고객님'}</span>
                            <svg class="caret"><use href="#i-chevd"/></svg>
                        </button>
                        <div class="profile__menu">
                            <div class="profile__name"><c:out value="${sessionScope.loginMember.name}"/>님</div>
                            <hr>
                            <a href="${pageContext.request.contextPath}/user/mypage">
                                <svg class="ico"><use href="#i-user"/></svg>마이페이지
                            </a>
                            <c:choose>
                                <c:when test="${sessionScope.loginMember.userRole == 'FIXER'}">
                                    <a class="switch" href="${pageContext.request.contextPath}/user/mypage">
                                        <svg class="ico"><use href="#i-refresh"/></svg>고객으로 전환
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a class="switch" href="${pageContext.request.contextPath}/fixer/verify">
                                        <svg class="ico"><use href="#i-refresh"/></svg>기사로 전환
                                    </a>
                                </c:otherwise>
                            </c:choose>
                            <a class="logout" href="${pageContext.request.contextPath}/user/logout">
                                <svg class="ico"><use href="#i-logout"/></svg>로그아웃
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/user/login" class="btn btn--ghost btn--sm">로그인</a>
                    <a href="${pageContext.request.contextPath}/user/sign" class="btn btn--primary btn--sm">회원가입</a>
                </c:otherwise>
            </c:choose>
        </div>

    </div>
</header>

<main>