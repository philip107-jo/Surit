<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>수릿 Surit</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/pages.css">
</head>
<body>

<header class="site-header">
    <div class="site-header__inner">

        <a href="/" class="logo">
            <div class="logo__mark">
                <svg viewBox="0 0 24 24"><path d="M8 12h8M8 8h8M8 16h5"/></svg>
            </div>
            <span class="logo__text">수릿</span>
        </a>

        <c:if test="${ not empty sessionScope.loginMember }">
            <nav class="gnb">
                <a href="/request">수리접수</a>
            </nav>
        </c:if>

        <div class="header-right">
            <c:choose>
                <c:when test="${ not empty sessionScope.loginMember }">
                    <div class="profile" id="profile">
                        <button type="button" class="profile__btn" id="profile-btn">
                            <span class="avatar avatar--sm">
                                <svg viewBox="0 0 24 24"><path d="M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM4 20a8 8 0 0 1 16 0"/></svg>
                            </span>
                            <span class="profile__who">${ sessionScope.loginMember.name }님</span>
                            <svg class="caret" viewBox="0 0 24 24"><path d="M6 9l6 6 6-6"/></svg>
                        </button>
                        <div class="profile__menu" id="profile-menu">
                            <div class="profile__name">${ sessionScope.loginMember.name }님</div>
                            <hr>
                            <a href="/user/mypage">
                                <svg viewBox="0 0 24 24"><path d="M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM4 20a8 8 0 0 1 16 0"/></svg>
                                마이페이지
                            </a>
                            <a href="/user/logout" class="logout">
                                <svg viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9"/></svg>
                                로그아웃
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="/user/login" class="btn btn--ghost btn--sm">로그인</a>
                    <a href="/user/sign" class="btn btn--primary btn--sm">회원가입</a>
                </c:otherwise>
            </c:choose>
        </div>

    </div>
</header>


<main>