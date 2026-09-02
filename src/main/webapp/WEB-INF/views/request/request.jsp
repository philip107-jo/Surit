<%@ page language="java"
         contentType="text/html;charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>


<!-- =====================================================
     아이콘
===================================================== -->
<svg width="0"
     height="0"
     style="position:absolute"
     aria-hidden="true">

    <defs>

        <!-- 도어락 -->
        <symbol id="i-lock" viewBox="0 0 24 24">
            <rect x="5" y="10" width="14" height="10" rx="2"/>
            <path d="M8 10V7a4 4 0 0 1 8 0v3"/>
            <circle cx="12"
                    cy="15"
                    r="1.4"
                    fill="currentColor"
                    stroke="none"/>
        </symbol>


        <!-- 냉장고 -->
        <symbol id="i-fridge" viewBox="0 0 24 24">
            <rect x="6" y="3" width="12" height="18" rx="2"/>
            <path d="M6 10h12"/>
            <path d="M9 6v2"/>
            <path d="M9 13v2.5"/>
        </symbol>


        <!-- PC -->
        <symbol id="i-pc" viewBox="0 0 24 24">
            <rect x="3" y="5" width="18" height="12" rx="2"/>
            <path d="M9 21h6"/>
            <path d="M12 17v4"/>
        </symbol>


        <!-- 배관 -->
        <symbol id="i-drop" viewBox="0 0 24 24">
            <path d="M12 3c4 4.5 6 7 6 9a6 6 0 0 1-12 0c0-2 2-4.5 6-9z"/>
        </symbol>


        <!-- 전기 -->
        <symbol id="i-bolt" viewBox="0 0 24 24">
            <path d="M13 2 5 14h6l-1 8 8-12h-6l1-8z"/>
        </symbol>


        <!-- 세탁기 -->
        <symbol id="i-washer" viewBox="0 0 24 24">
            <rect x="5" y="3" width="14" height="18" rx="2"/>
            <circle cx="12" cy="14" r="4"/>
            <path d="M8 6.5h2"/>
        </symbol>


        <!-- 에어컨 -->
        <symbol id="i-ac" viewBox="0 0 24 24">
            <rect x="3" y="5" width="18" height="7" rx="2"/>
            <path d="M8 15q2 2 0 4"/>
            <path d="M12 15q2 2 0 4"/>
            <path d="M16 15q2 2 0 4"/>
        </symbol>


        <!-- 가구 -->
        <symbol id="i-chair" viewBox="0 0 24 24">
            <rect x="6" y="3" width="12" height="8" rx="2"/>
            <path d="M5 13h14"/>
            <path d="M7 21v-4"/>
            <path d="M17 21v-4"/>
        </symbol>


        <!-- TV -->
        <symbol id="i-tv" viewBox="0 0 24 24">
            <rect x="3" y="5" width="18" height="12" rx="2"/>
            <path d="M9 21h6"/>
            <path d="M12 17v4"/>
        </symbol>


        <!-- 기타 -->
        <symbol id="i-dots" viewBox="0 0 24 24">
            <circle cx="5"
                    cy="12"
                    r="1.6"
                    fill="currentColor"
                    stroke="none"/>
            <circle cx="12"
                    cy="12"
                    r="1.6"
                    fill="currentColor"
                    stroke="none"/>
            <circle cx="19"
                    cy="12"
                    r="1.6"
                    fill="currentColor"
                    stroke="none"/>
        </symbol>


        <!-- 카메라 -->
        <symbol id="i-camera" viewBox="0 0 24 24">
            <path d="M4 8h3l1.5-2h7L17 8h3a1 1 0 0 1 1 1v9a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V9a1 1 0 0 1 1-1z"/>
            <circle cx="12" cy="13.5" r="3.6"/>
        </symbol>


        <!-- 방패 -->
        <symbol id="i-shield" viewBox="0 0 24 24">
            <path d="M12 3l7 3v5.5c0 4.4-3 8-7 9.5-4-1.5-7-5.1-7-9.5V6z"/>
            <path d="M9.2 12l2 2 3.6-3.8"/>
        </symbol>

    </defs>

</svg>


<main>

<div class="container">


    <!-- =====================================================
         페이지 제목
    ====================================================== -->

    <div class="page-head">

        <h1>
            <c:choose>

                <c:when test="${editMode}">
                    수리 접수 수정
                </c:when>

                <c:otherwise>
                    수리 접수
                </c:otherwise>

            </c:choose>
        </h1>


        <p>

            <c:choose>

                <c:when test="${editMode}">
                    접수한 내용을 수정할 수 있습니다.
                </c:when>

                <c:otherwise>
                    증상만 남겨주시면 주변 기사님이 직접 견적을 신청합니다.
                </c:otherwise>

            </c:choose>

        </p>

    </div>



    <div class="card"
         style="max-width:840px;margin:0 auto">


        <!-- =================================================
             신규 등록 / 수정 공용 FORM
        ================================================== -->

        <form id="request-form"

              action="<c:choose>
                          <c:when test='${editMode}'>
                              ${pageContext.request.contextPath}/request/${request.requestId}/edit
                          </c:when>
                          <c:otherwise>
                              ${pageContext.request.contextPath}/request/request
                          </c:otherwise>
                      </c:choose>"

              method="post"

              enctype="multipart/form-data">


            <!-- 수정 모드에서 requestId 유지 -->

            <c:if test="${editMode}">

                <input type="hidden"
                       name="requestId"
                       value="${request.requestId}">

            </c:if>



            <!-- =================================================
                 1. 카테고리
            ================================================== -->

            <div class="form-sec">

                <div class="form-sec__head">

                    <span class="form-sec__no">
                        1
                    </span>

                    <div>

                        <div class="form-sec__title">
                            무엇이 고장났나요?
                        </div>

                    </div>

                </div>



                <div class="cat-grid">


                    <c:forEach var="cat"
                               items="${categoryList}">


                        <button type="button"

                                class="cat${cat.codeId eq selectedCategoryCode
                                        ? ' is-on'
                                        : ''}"

                                data-select="category"

                                data-category-code="${cat.codeId}">


                            <c:choose>


                                <c:when test="${cat.codeId eq 'CAT_10'}">

                                    <span class="tile t-lock">
                                        <svg>
                                            <use href="#i-lock"/>
                                        </svg>
                                    </span>

                                    <span>
                                        도어락 · 잠금
                                    </span>

                                </c:when>



                                <c:when test="${cat.codeId eq 'CAT_02'}">

                                    <span class="tile t-fridge">
                                        <svg>
                                            <use href="#i-fridge"/>
                                        </svg>
                                    </span>

                                    <span>
                                        냉장고
                                    </span>

                                </c:when>



                                <c:when test="${cat.codeId eq 'CAT_01'}">

                                    <span class="tile t-pc">
                                        <svg>
                                            <use href="#i-pc"/>
                                        </svg>
                                    </span>

                                    <span>
                                        PC · 노트북
                                    </span>

                                </c:when>



                                <c:when test="${cat.codeId eq 'CAT_05'}">

                                    <span class="tile t-drop">
                                        <svg>
                                            <use href="#i-drop"/>
                                        </svg>
                                    </span>

                                    <span>
                                        배관 · 누수
                                    </span>

                                </c:when>



                                <c:when test="${cat.codeId eq 'CAT_06'}">

                                    <span class="tile t-bolt">
                                        <svg>
                                            <use href="#i-bolt"/>
                                        </svg>
                                    </span>

                                    <span>
                                        전기 · 조명
                                    </span>

                                </c:when>



                                <c:when test="${cat.codeId eq 'CAT_03'}">

                                    <span class="tile t-washer">
                                        <svg>
                                            <use href="#i-washer"/>
                                        </svg>
                                    </span>

                                    <span>
                                        세탁기 · 건조기
                                    </span>

                                </c:when>



                                <c:when test="${cat.codeId eq 'CAT_09'}">

                                    <span class="tile t-ac">
                                        <svg>
                                            <use href="#i-ac"/>
                                        </svg>
                                    </span>

                                    <span>
                                        에어컨 · 보일러
                                    </span>

                                </c:when>



                                <c:when test="${cat.codeId eq 'CAT_04'}">

                                    <span class="tile t-chair">
                                        <svg>
                                            <use href="#i-chair"/>
                                        </svg>
                                    </span>

                                    <span>
                                        가구 · 조립
                                    </span>

                                </c:when>



                                <c:when test="${cat.codeId eq 'CAT_08'}">

                                    <span class="tile t-tv">
                                        <svg>
                                            <use href="#i-tv"/>
                                        </svg>
                                    </span>

                                    <span>
                                        TV · 모니터
                                    </span>

                                </c:when>



                                <c:when test="${cat.codeId eq 'CAT_07'}">

                                    <span class="tile t-dots">
                                        <svg>
                                            <use href="#i-dots"/>
                                        </svg>
                                    </span>

                                    <span>
                                        기타
                                    </span>

                                </c:when>


                            </c:choose>


                        </button>


                    </c:forEach>


                </div>



                <!-- 실제 서버로 넘어가는 categoryCode -->

                <input type="hidden"

                       id="category-code"

                       name="categoryCode"

                       value="${selectedCategoryCode}">


            </div>



            <!-- =================================================
                 2. 증상
            ================================================== -->

            <div class="form-sec">


                <div class="form-sec__head">

                    <span class="form-sec__no">
                        2
                    </span>


                    <div>

                        <div class="form-sec__title">
                            어떤 증상인가요?
                        </div>

                        <div class="form-sec__desc">
                            자세히 적을수록 기사님이 빠르게 판단할 수 있어요
                        </div>

                    </div>

                </div>



                <div class="field">

                    <label class="field__label"
                           for="request-title">

                        제목

                        <span class="req">
                            *
                        </span>

                    </label>


                    <input type="text"

                           id="request-title"

                           name="title"

                           class="input"

                           value="<c:out value='${request.title}'/>"

                           placeholder="예: 현관 도어락이 반응이 없어요"

                           required>

                </div>



                <textarea id="request-content"

                          name="content"

                          class="textarea"

                          placeholder="예) 현관 도어락 버튼을 눌러도 반응이 없고 삐 소리만 납니다.&#10;건전지는 어제 새로 갈았습니다."

                          required><c:out value="${request.content}"/></textarea>



                <!-- =================================================
                     긴급 신청 (2026-09-02)

                     체크하면 접수가 REQ_99(긴급접수) 상태로 저장된다.
                     체크를 안 하면 파라미터 자체가 안 넘어와서 서버에서
                     null 이 되고, 그대로 REQ_01(접수대기)로 들어간다.

                     수정 화면에서는 보여주지 않는다. 이미 등록된 접수의
                     긴급 여부를 바꾸려면 상태 코드를 바꿔야 하는데,
                     견적이 들어와 REQ_02 로 넘어간 뒤라면 되돌릴 수가 없다.
                ================================================== -->

                <c:if test="${empty request.requestId}">
                    <label class="check"
                           style="display:flex; align-items:center; gap:8px; margin-top:18px">

                        <input type="checkbox"
                               name="urgentYn"
                               value="Y">

                        <span>
                            <b>긴급으로 신청합니다</b>
                            <span class="muted" style="display:block; font-size:13px">
                                기사님 목록에서 긴급 접수로 표시됩니다.
                            </span>
                        </span>

                    </label>
                </c:if>



                <!-- =================================================
                     사진
                ================================================== -->

                <div class="field__label"
                     style="margin:26px 0 12px">

                    사진 첨부

                    <span class="muted"
                          style="font-weight:400">

                        (선택 · 최대 5장)

                    </span>

                </div>



                <div class="upload">


                    <label for="request-photos"
                           class="upload__add">

                        <svg>
                            <use href="#i-camera"/>
                        </svg>

                        <span>
                            사진 추가
                        </span>

                    </label>



                    <input type="file"

                           id="request-photos"

                           name="photoFiles"

                           accept="image/*"

                           multiple

                           style="display:none;">



                    <div id="photo-preview"
                         class="photo-preview">

                    </div>


                </div>


            </div>



            <!-- =================================================
                 3. 방문 주소
            ================================================== -->

            <div class="form-sec">


                <div class="form-sec__head">

                    <span class="form-sec__no">
                        3
                    </span>


                    <div>

                        <div class="form-sec__title">
                            어디로 방문할까요?
                        </div>

                    </div>

                </div>



                <div class="address-list">


                    <c:forEach var="addr"
                               items="${addressList}"
                               end="2">


                        <c:set var="fullAddress"
                               value="${addr.address} ${addr.addressDetail}" />



                        <button type="button"

                                class="address-card
                                ${not empty request
                                    && request.serviceAddress eq fullAddress

                                    ? 'is-on'

                                    : (empty request
                                        && addr.isDefault eq 'Y'

                                        ? 'is-on'

                                        : '')}"

                                data-address="${fullAddress}">


                            <span class="address-radio">
                            </span>



                            <span class="address-card__body">


                                <!-- 주소 별칭 -->

                                <strong>

                                    <c:out value="${addr.addressName}" />

                                </strong>



                                <!-- 실제 주소 -->

                                <span class="address-card__text">

                                    <c:out value="${addr.address}" />


                                    <c:if test="${not empty addr.addressDetail}">

                                        <c:out value=" ${addr.addressDetail}" />

                                    </c:if>

                                </span>


                            </span>


                        </button>


                    </c:forEach>


                </div>



                <!-- 실제 서버로 넘어가는 주소 -->

                <input type="hidden"

                       id="service-address"

                       name="serviceAddress"

                       value="<c:out value='${request.serviceAddress}'/>">



                <button type="button"

                        class="address-add"

                        onclick="location.href='${pageContext.request.contextPath}/user/mypage/address'">

                    + 새 주소 추가하기

                </button>


            </div>



            <!-- =================================================
                 4. 방문 날짜 / 시간
            ================================================== -->

            <div class="form-sec">


                <div class="form-sec__head">

                    <span class="form-sec__no">
                        4
                    </span>


                    <div>

                        <div class="form-sec__title">
                            언제 방문할까요?
                        </div>

                    </div>

                </div>



                <!-- 지금 바로 / 날짜 지정 -->

                <div class="opt-grid"
                     id="when-select">


                    <!-- 지금 바로 -->

                    <button type="button"

                            class="opt opt--accent
                            ${empty request.visitDate
                                ? ' is-on'
                                : ''}"

                            data-use-yn="Y">


                        <span class="opt__radio">
                        </span>


                        <span class="opt__body">

                            <span class="opt__title">
                                지금 바로
                            </span>

                            <span class="opt__desc">
                                가장 먼저 신청한 기사님과 연결
                            </span>

                        </span>


                    </button>



                    <!-- 날짜 지정 -->

                    <button type="button"

                            class="opt
                            ${not empty request.visitDate
                                ? ' is-on'
                                : ''}"

                            data-use-yn="N">


                        <span class="opt__radio">
                        </span>


                        <span class="opt__body">

                            <span class="opt__title">
                                날짜 지정
                            </span>

                            <span class="opt__desc">
                                원하는 날짜와 시간대 선택
                            </span>

                        </span>


                    </button>


                </div>



                <!-- 날짜 지정 선택 시 표시 -->

                <div id="visit-option-area"

                     style="${not empty request.visitDate
                                ? 'display:block; margin-top:20px;'
                                : 'display:none; margin-top:20px;'}">


                    <!-- 방문 날짜 -->

                    <div class="field">


                        <label class="field__label"
                               for="visit-date">

                            희망 방문 날짜

                        </label>



                        <input type="date"

                               id="visit-date"

                               name="visitDate"

                               class="input"

                               value="${request.visitDate}">


                    </div>



                    <!-- 방문 시간 -->

                    <div class="field"
                         style="margin-top:20px;">


                        <label class="field__label"
                               for="visit-time-code">

                            희망 시간대

                        </label>



                        <div style="
                            position:relative;
                            width:100%;
                        ">


                            <select id="visit-time-code"

                                    name="visitTimeCode"

                                    class="input"

                                    style="
                                        width:100%;
                                        appearance:none;
                                        -webkit-appearance:none;
                                        -moz-appearance:none;
                                        padding-right:55px;
                                    ">


                                <option value="">
                                    시간대를 선택해주세요
                                </option>



                                <c:forEach var="time"
                                           items="${visitTimeList}">


                                    <option value="${time.codeId}"

                                            ${time.codeId eq request.visitTimeCode
                                                ? 'selected'
                                                : ''}>

                                        <c:out value="${time.codeName}" />

                                    </option>


                                </c:forEach>


                            </select>



                            <span style="
                                position:absolute;
                                right:20px;
                                top:50%;
                                transform:translateY(-50%);
                                pointer-events:none;
                                font-size:13px;
                                color:#222;
                            ">

                                ▼

                            </span>


                        </div>


                    </div>


                </div>


            </div>



            <!-- =================================================
                 동의 / 제출
            ================================================== -->

            <div class="form-sec">


                <label class="check"
                       style="margin-bottom:26px">


                    <input type="checkbox"
                           id="agree-checkbox"
                           required>


                    개인정보 제3자 제공 및 이용약관에 동의합니다.
                    (필수)


                </label>



                <button type="submit"

                        class="btn btn--primary btn--xl btn--block">


                    <c:choose>

                        <c:when test="${editMode}">
                            수정 완료
                        </c:when>

                        <c:otherwise>
                            접수하고 기사님 찾기
                        </c:otherwise>

                    </c:choose>


                </button>



                <div class="note note--gray"
                     style="margin-top:20px">


                    <svg>
                        <use href="#i-shield"/>
                    </svg>


                    <p>

                        기사님을 수락하기 전까지는 어떤 비용도 발생하지 않습니다.

                        수리비는 작업이 끝난 뒤

                        <b>
                            현장에서 직접
                        </b>

                        결제합니다.

                    </p>


                </div>


            </div>


        </form>


    </div>


</div>

</main>



<script src="${pageContext.request.contextPath}/js/common.js"></script>


<jsp:include page="/WEB-INF/views/common/footer.jsp"/>