<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- 헤더 등 공통 영역 -->

<div class="container">
    <h2>확정된 예약</h2>
    <p>08.14 13:45 채팅에서 확정</p>

    <!-- 예약 상세 정보 (백엔드에서 넘겨준 DTO 데이터 출력) -->
    <table class="table">
        <tbody>
        <tr>
            <th>방문 일시</th>
            <td><strong>${booking.visitDate}</strong></td>
        </tr>
        <tr>
            <th>방문 주소</th>
            <td>${booking.visitAddress}</td>
        </tr>
        <tr>
            <th>고객</th>
            <td>${booking.customerName} 고객님</td>
        </tr>
        <tr>
            <th>연락</th>
            <td>채팅으로만 (번호 비공개)</td>
        </tr>
        </tbody>
    </table>

    <div class="btn-group" style="display: flex; gap: 10px; margin-top: 20px;">
        <!-- 예약 취소 폼 -->
        <form id="cancelForm" action="/fixer/bookings/${booking.requestId}/cancel" method="post">
            <button type="button" class="btn btn-outline-danger" onclick="confirmCancel()">
                ❌ 예약 취소
            </button>
        </form>

        <!-- 채팅하기 버튼 (단순 이동) -->
        <button type="button" class="btn btn-primary" onclick="location.href='/fixer/chat/${booking.requestId}'" style="flex: 1;">
            💬 고객과 채팅하기
        </button>
    </div>

    <div class="notice" style="margin-top: 15px; font-size: 12px; color: gray;">
        <p>✔️ 예약을 취소하면 고객에게 바로 알림이 가고 접수는 다시 매칭 상태로 돌아갑니다. 시간 변경이 필요하면 취소 대신 <strong>채팅</strong>에서 일정을 다시 확정해 주세요.</p>
    </div>
</div>

<!-- ========================================== -->
<!-- 🚀 자바스크립트 영역 (JS)                    -->
<!-- ========================================== -->
<script>
    // 예약 취소 버튼을 눌렀을 때 실행되는 함수
    function confirmCancel() {
        // JS 기본 함수인 confirm 창을 띄워 사용자에게 한 번 더 묻습니다.
        const isConfirmed = confirm("정말 예약을 취소하시겠습니까?\n고객에게 취소 알림이 발송되며, 매칭 상태로 돌아갑니다.");

        // '확인'을 누르면 폼을 전송하여 백엔드의 PostMapping('/cancel')을 호출합니다.
        if (isConfirmed) {
            document.getElementById('cancelForm').submit();
        }
    }
</script>