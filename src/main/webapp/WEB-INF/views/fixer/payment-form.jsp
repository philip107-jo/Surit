<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container">
    <h2>현장 수리 완료 및 결제</h2>

    <!-- 파일 업로드를 위해 enctype="multipart/form-data"는 무조건 필수입니다! -->
    <form id="paymentForm" action="/fixer/payment/complete" method="post" enctype="multipart/form-data">

        <!-- 백엔드로 넘겨줄 예약 번호 (숨김 처리) -->
        <input type="hidden" name="requestId" value="${booking.requestId}">

        <hr>
        <h3>1. 수리 전/후 사진 업로드</h3>
        <div style="display: flex; gap: 20px; margin-bottom: 20px;">
            <div>
                <label>수리 전 사진 <span style="color:red">*</span></label><br>
                <!-- accept="image/*" 로 모바일에서 갤러리나 카메라가 열리게 유도 -->
                <input type="file" name="beforePhoto" accept="image/*" required>
            </div>
            <div>
                <label>수리 후 사진 <span style="color:red">*</span></label><br>
                <input type="file" name="afterPhoto" accept="image/*" required>
            </div>
        </div>

        <hr>
        <h3>2. 영수증(결제 내역) 작성</h3>
        <table class="table" id="receiptTable">
            <thead>
            <tr>
                <th>항목명</th>
                <th>수량</th>
                <th>단가(원)</th>
                <th>금액</th>
                <th>삭제</th>
            </tr>
            </thead>
            <tbody id="receiptBody">
            <!-- 첫 번째 항목 (기본 1줄) -->
            <tr class="receipt-row">
                <!-- name="details[0].itemName" 형태로 백엔드 List<PaymentDetailDTO>에 매핑 -->
                <td><input type="text" name="details[0].itemName" placeholder="예: 부품 교체" required></td>
                <td><input type="number" name="details[0].quantity" class="qty input-sm" value="1" min="1" onchange="calcTotal()"></td>
                <td><input type="number" name="details[0].unitPrice" class="price input-sm" value="0" min="0" onchange="calcTotal()"></td>
                <td class="row-total">0</td>
                <td></td> <!-- 첫 줄은 삭제 불가 -->
            </tr>
            </tbody>
        </table>
        <button type="button" class="btn btn-secondary btn-sm" onclick="addRow()">+ 내역 추가</button>

        <hr>
        <div style="font-size: 20px; text-align: right;">
            <strong>총 결제 금액: <span id="displayTotal" style="color: blue;">0</span> 원</strong>
            <!-- 백엔드로 실제로 날아가는 총액 데이터 -->
            <input type="hidden" name="totalAmount" id="totalAmount" value="0">
        </div>

        <div style="margin-top: 15px;">
            <label>결제 수단</label>
            <select name="paymentMethod" class="form-select" style="width: 200px;">
                <option value="CARD">카드 결제</option>
                <option value="CASH">현금 결제</option>
                <option value="TRANSFER">계좌 이체</option>
            </select>
        </div>

        <div style="margin-top: 30px; text-align: center;">
            <button type="button" class="btn btn-primary btn-lg" onclick="submitPayment()">수리 완료 처리하기</button>
        </div>
    </form>
</div>

<!-- ========================================== -->
<!-- 🚀 자바스크립트 영역 (JS)                    -->
<!-- ========================================== -->
<script>
    // 항목이 추가될 때마다 백엔드 리스트 매핑용 인덱스를 1씩 증가시킵니다.
    let rowIndex = 1;

    // 1. 영수증 내역 추가 함수
    function addRow() {
        const tbody = document.getElementById('receiptBody');
        const tr = document.createElement('tr');
        tr.className = 'receipt-row';

        // 새로운 HTML 줄을 삽입 (백틱 ` 기호 사용)
        tr.innerHTML = `
            <td><input type="text" name="details[\${rowIndex}].itemName" placeholder="예: 출장비" required></td>
            <td><input type="number" name="details[\${rowIndex}].quantity" class="qty input-sm" value="1" min="1" onchange="calcTotal()"></td>
            <td><input type="number" name="details[\${rowIndex}].unitPrice" class="price input-sm" value="0" min="0" onchange="calcTotal()"></td>
            <td class="row-total">0</td>
            <td><button type="button" class="btn btn-danger btn-sm" onclick="removeRow(this)">X</button></td>
        `;

        tbody.appendChild(tr);
        rowIndex++;
        calcTotal(); // 항목이 추가되면 총액 다시 계산
    }

    // 2. 영수증 내역 삭제 함수
    function removeRow(btn) {
        const tr = btn.closest('tr');
        tr.remove(); // 해당 줄 삭제
        calcTotal(); // 삭제 후 총액 다시 계산
    }

    // 3. 수량과 단가를 곱해서 총 결제 금액을 계산하는 함수
    function calcTotal() {
        let total = 0;
        const rows = document.querySelectorAll('.receipt-row');

        rows.forEach(row => {
            // 빈 값이면 0으로 처리
            const qty = parseInt(row.querySelector('.qty').value) || 0;
            const price = parseInt(row.querySelector('.price').value) || 0;

            const rowTotal = qty * price;
            row.querySelector('.row-total').innerText = rowTotal.toLocaleString(); // 콤마 찍어서 표시

            total += rowTotal;
        });

        // 총액 화면 업데이트 및 hidden input 값 설정
        document.getElementById('displayTotal').innerText = total.toLocaleString();
        document.getElementById('totalAmount').value = total;
    }

    // 4. 최종 전송(Submit) 방어 코드
    function submitPayment() {
        const total = document.getElementById('totalAmount').value;

        if (total == 0) {
            alert("총 결제 금액이 0원입니다. 단가를 입력해 주세요.");
            return;
        }

        if(confirm("이대로 수리를 완료하고 결제를 진행하시겠습니까?\n(완료 후에는 취소할 수 없습니다.)")) {
            document.getElementById('paymentForm').submit();
        }
    }
</script>