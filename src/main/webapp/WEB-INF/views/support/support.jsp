<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>고객센터 · 1:1 문의</title>
<link rel="stylesheet" href="/css/style.css">
<link rel="stylesheet" href="/css/pages.css">
<style>
	.sp-wrap { max-width:720px; margin:24px auto; }
	.sp-row  { display:flex; justify-content:space-between; align-items:center;
	           padding:14px 16px; border:1px solid #E5E7EB; border-radius:12px;
	           margin-bottom:10px; text-decoration:none; color:inherit; background:#fff; }
	.sp-row:hover { background:#F9FAFB; }
	.sp-row .last { font-size:13px; color:#6B7280; margin-top:4px;
	                max-width:420px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
	.sp-new  { display:flex; gap:8px; align-items:center; margin-bottom:20px; }
</style>
</head>
<body>

<div class="sp-wrap">

	<div class="page-head"><h1>1:1 문의</h1></div>

	<c:choose>
		<c:when test="${empty myNo}">
			<div class="card"><p class="empty"><c:out value="${msg}"/></p></div>
		</c:when>
		<c:otherwise>

			<%-- 새 문의 --%>
			<form class="sp-new" method="post" action="/support/new">
				<c:if test="${not empty testUserNo}">
					<input type="hidden" name="testUserNo" value="${testUserNo}">
				</c:if>
				<select name="categoryCode" class="input">
					<c:forEach var="t" items="${types}">
						<option value="${fn:escapeXml(t.codeId)}"><c:out value="${t.codeName}"/></option>
					</c:forEach>
				</select>
				<button type="submit" class="btn btn--primary">새 문의하기</button>
			</form>

			<%-- 내 문의 목록 --%>
			<c:choose>
				<c:when test="${empty rooms}">
					<div class="card"><p class="empty">아직 문의하신 내역이 없습니다.</p></div>
				</c:when>
				<c:otherwise>
					<c:forEach var="r" items="${rooms}">
						<a class="sp-row"
						   href="/support/${r.roomId}<c:if test='${not empty testUserNo}'>?testUserNo=${testUserNo}</c:if>">
							<div>
								<span class="badge badge--primary"><c:out value="${r.categoryName}"/></span>
								<div class="last">
									<c:choose>
										<c:when test="${empty r.lastMessage}">대화를 시작해 보세요</c:when>
										<c:otherwise><c:out value="${r.lastMessage}"/></c:otherwise>
									</c:choose>
								</div>
							</div>
							<div style="text-align:right;">
								<c:if test="${r.unreadCount > 0}">
									<span class="badge badge--danger">${r.unreadCount}</span>
								</c:if>
								<div class="muted" style="font-size:12px;">
									<c:out value="${empty r.lastSentAt ? r.createdAt : r.lastSentAt}"/>
								</div>
							</div>
						</a>
					</c:forEach>
				</c:otherwise>
			</c:choose>

		</c:otherwise>
	</c:choose>

</div>

</body>
</html>