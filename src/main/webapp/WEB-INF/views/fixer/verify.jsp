<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="container">
    <div class="page-head">
        <h1>기사 인증 신청</h1>
        <p>자격증과 활동 정보를 등록하면 관리자 심사 후 기사로 활동하실 수 있어요.</p>
    </div>

    <c:if test="${ not empty message }">
        <div class="note note--blue">
            <svg viewBox="0 0 24 24"><path d="M12 8v4M12 16h.01M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0z"/></svg>
            <p><c:out value="${ message }"/></p>
        </div>
    </c:if>

    <c:choose>

        <c:when test="${ profile.approvalStatus eq 'PENDING' }">
            <div class="note note--warn">
                <svg viewBox="0 0 24 24"><path d="M12 8v4M12 16h.01M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0z"/></svg>
                <p>심사 중입니다. 결과가 나올 때까지 기다려주세요.</p>
            </div>
        </c:when>

        <c:when test="${ profile.approvalStatus eq 'APPROVED' }">
            <div class="note note--ok">
                <svg viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>
                <p>인증이 완료된 기사입니다.</p>
            </div>
            <div class="btn-row" style="margin-top:16px">
                <a href="/fixer/requests" class="btn btn--primary">내 주변 새 접수 보기</a>
                <a href="/fixer/jobs" class="btn btn--ghost">내 작업 관리</a>
            </div>
        </c:when>

        <c:otherwise>

            <c:if test="${ profile.approvalStatus eq 'REJECTED' }">
                <div class="note note--warn">
                    <svg viewBox="0 0 24 24"><path d="M12 9v4M12 17h.01M10.29 3.86l-8.18 14.14A2 2 0 0 0 3.82 21h16.36a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/></svg>
                    <p>이전 신청이 거절되었습니다. 내용을 보완해서 다시 신청해주세요.</p>
                </div>
            </c:if>

            <form id="fixer-verify-form" action="/fixer/verify" method="post" enctype="multipart/form-data">

                <div class="form-sec">
                    <div class="form-sec__head">
                        <div class="form-sec__no">1</div>
                        <div>
                            <div class="form-sec__title">기본 정보</div>
                            <div class="form-sec__desc">고객에게 보여질 소개와 경력이에요</div>
                        </div>
                    </div>

                    <div class="field">
                        <label class="field__label" for="intro">자기소개</label>
                        <textarea id="intro" name="intro" class="textarea" maxlength="4000"><c:out value="${ profile.intro }"/></textarea>
                    </div>

                    <div class="field">
                        <label class="field__label" for="career-years">경력 (년)<span class="req">*</span></label>
                        <input type="number" id="career-years" name="careerYears" class="input"
                            min="0" max="70" required value="${ profile.careerYears }">
                    </div>
                </div>

                <div class="form-sec">
                    <div class="form-sec__head">
                        <div class="form-sec__no">2</div>
                        <div>
                            <div class="form-sec__title">활동 지역</div>
                            <div class="form-sec__desc">최소 1개 이상 선택해주세요</div>
                        </div>
                    </div>

                    <div class="chip-row">
                        <c:forEach var="region" items="${ regionList }">
                            <label class="check">
                                <input type="checkbox" name="regionCodes" value="${ region.codeId }">
                                <c:out value="${ region.codeName }"/>
                            </label>
                        </c:forEach>
                    </div>
                </div>

                <div class="form-sec">
                    <div class="form-sec__head">
                        <div class="form-sec__no">3</div>
                        <div>
                            <div class="form-sec__title">수리 가능 분야</div>
                            <div class="form-sec__desc">최소 1개 이상 선택해주세요</div>
                        </div>
                    </div>

                    <div class="chip-row">
                        <c:forEach var="category" items="${ categoryList }">
                            <label class="check">
                                <input type="checkbox" name="categoryCodes" value="${ category.codeId }">
                                <c:out value="${ category.codeName }"/>
                            </label>
                        </c:forEach>
                    </div>
                </div>

                <div class="form-sec">
                    <div class="form-sec__head">
                        <div class="form-sec__no">4</div>
                        <div>
                            <div class="form-sec__title">자격증</div>
                            <div class="form-sec__desc">최소 1개 이상 등록해주세요 (증빙파일은 jpg·png·pdf)</div>
                        </div>
                    </div>

                    <c:forEach var="i" begin="1" end="3">
                        <div class="card card--sm">
                            <div class="card__title" style="font-size:16px;margin-bottom:14px">자격증 ${ i }</div>

                            <div class="field">
                                <label class="field__label">자격증명</label>
                                <input type="text" name="licenseNames" class="input" maxlength="100">
                            </div>

                            <div class="field-row">
                                <div class="field">
                                    <label class="field__label">발급일</label>
                                    <input type="date" name="licenseIssuedAts" class="input">
                                </div>
                                <div class="field">
                                    <label class="field__label">증빙파일</label>
                                    <input type="file" name="licenseFiles" class="input" accept=".jpg,.jpeg,.png,.pdf">
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <button type="submit" class="btn btn--primary btn--xl btn--block">신청하기</button>
            </form>

        </c:otherwise>
    </c:choose>
</div>

<script src="/js/common.js"></script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>