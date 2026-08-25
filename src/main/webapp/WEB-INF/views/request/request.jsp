<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs><symbol id="i-tools" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/></symbol><symbol id="i-camera" viewBox="0 0 24 24"><path d="M4 8h3l1.5-2h7L17 8h3a1 1 0 0 1 1 1v9a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V9a1 1 0 0 1 1-1z"/><circle cx="12" cy="13.5" r="3.6"/></symbol><symbol id="i-image" viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="8.5" cy="10" r="1.6"/><path d="M4 17l5-5 4 4 3-2 4 4"/></symbol><symbol id="i-plus" viewBox="0 0 24 24"><path d="M12 5v14"/><path d="M5 12h14"/></symbol><symbol id="i-shield" viewBox="0 0 24 24"><path d="M12 3l7 3v5.5c0 4.4-3 8-7 9.5-4-1.5-7-5.1-7-9.5V6z"/><path d="M9.2 12l2 2 3.6-3.8"/></symbol></defs></svg>

<main>
<div class="container">
    <div class="page-head">
        <h1>수리 접수</h1>
        <p>증상만 남겨주시면 주변 기사님이 직접 견적을 신청합니다.</p>
    </div>

    <div class="card" style="max-width:840px;margin:0 auto">
        <form id="request-form" action="/request" method="post">

            <div class="form-sec">
                <div class="form-sec__head">
                    <span class="form-sec__no">1</span>
                    <div><div class="form-sec__title">무엇이 고장났나요?</div></div>
                </div>

                <div class="cat-grid">
                    <c:forEach var="cat" items="${ categories }" varStatus="status">
                        <button type="button" class="cat${ status.first ? ' is-on' : '' }"
                                data-select="category" data-category-code="${ cat.codeId }">
                            <span class="tile tile--sm t-blue"><svg><use href="#i-tools"/></svg></span>
                            <span><c:out value="${ cat.codeName }"/></span>
                        </button>
                    </c:forEach>
                </div>
                <input type="hidden" id="category-code" name="categoryCode"
                    value="${ not empty categories ? categories[0].codeId : '' }" required>
            </div>

            <div class="form-sec">
                <div class="form-sec__head">
                    <span class="form-sec__no">2</span>
                    <div>
                        <div class="form-sec__title">어떤 증상인가요?</div>
                        <div class="form-sec__desc">자세히 적을수록 기사님이 빠르게 판단할 수 있어요</div>
                    </div>
                </div>

                <div class="field">
                    <label class="field__label" for="request-title">제목<span class="req">*</span></label>
                    <input type="text" id="request-title" name="title" class="input"
                        placeholder="예: 현관 도어락이 반응이 없어요" required>
                </div>

                <textarea id="request-content" name="content" class="textarea"
                    placeholder="예) 현관 도어락 버튼을 눌러도 반응이 없고 삐 소리만 납니다.&#10;건전지는 어제 새로 갈았습니다."></textarea>

                <div class="field__label" style="margin:26px 0 12px">
                    사진 첨부 <span class="muted" style="font-weight:400">(선택 · 최대 5장, 준비 중인 기능이에요)</span>
                </div>
                <div class="upload">
                    <button type="button" class="upload__add" disabled>
                        <svg><use href="#i-camera"/></svg>
                        <span>사진 추가</span>
                    </button>
                </div>
            </div>

            <div class="form-sec">
                <div class="form-sec__head">
                    <span class="form-sec__no">3</span>
                    <div><div class="form-sec__title">어디로 방문할까요?</div></div>
                </div>

                <div class="field">
                    <label class="field__label" for="service-address">방문 주소<span class="req">*</span></label>
                    <input type="text" id="service-address" name="serviceAddress" class="input"
                        placeholder="예: 서울 강남구 테헤란로 123, 101동 1502호" required>
                </div>
            </div>

            <div class="form-sec">
                <div class="form-sec__head">
                    <span class="form-sec__no">4</span>
                    <div><div class="form-sec__title">언제 방문할까요?</div></div>
                </div>

                <div class="opt-grid" id="when-select">
                    <button type="button" class="opt opt--accent is-on" data-select="when" data-use-yn="Y">
                        <span class="opt__radio"></span>
                        <span class="opt__body">
                            <span class="opt__title">지금 바로</span>
                            <span class="opt__desc">가장 먼저 신청한 기사님과 연결</span>
                        </span>
                    </button>
                    <button type="button" class="opt" data-select="when" data-use-yn="N">
                        <span class="opt__radio"></span>
                        <span class="opt__body">
                            <span class="opt__title">날짜 지정</span>
                            <span class="opt__desc">원하는 날짜와 시간대 선택</span>
                        </span>
                    </button>
                </div>
                <input type="hidden" id="request-use-yn" name="useYn" value="Y">

                <div class="field" id="visit-datetime-field" style="margin-top:16px;display:none">
                    <label class="field__label" for="visit-preferred-at">희망 방문 일시</label>
                    <input type="datetime-local" id="visit-preferred-at" name="visitPreferredAt" class="input">
                </div>
            </div>

            <div class="form-sec">
                <label class="check" style="margin-bottom:26px">
                    <input type="checkbox" id="agree-checkbox" required>
                    개인정보 제3자 제공 및 이용약관에 동의합니다. (필수)
                </label>

                <button type="submit" class="btn btn--primary btn--xl btn--block">접수하고 기사님 찾기</button>

                <div class="note note--gray" style="margin-top:20px">
                    <svg><use href="#i-shield"/></svg>
                    <p>기사님을 수락하기 전까지는 어떤 비용도 발생하지 않습니다.
                    수리비는 작업이 끝난 뒤 <b>현장에서 직접</b> 결제합니다.</p>
                </div>
            </div>

        </form>
    </div>
</div>
</main>

<script src="/js/common.js"></script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>