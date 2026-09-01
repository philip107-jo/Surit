</main>
<footer class="site-footer">
	<p>&copy; 2026 Surit. All rights reserved.</p>
</footer>
<script src="/js/common.js"></script>

<%-- ═══ 공통 토스트 알림 ═══ --%>
<c:if test="${not empty msg}">
<style>
	.toast {
		position: fixed; top: 96px; left: 50%; transform: translateX(-50%);
		background: #111827; color: #fff;
		padding: 12px 22px; border-radius: 10px;
		font-size: 14px; font-weight: 500; white-space: nowrap;
		box-shadow: 0 8px 24px rgba(0,0,0,.18);
		z-index: 9999; opacity: 1;
		transition: opacity .4s ease, transform .4s ease;
		animation: toastIn .25s ease-out;
	}
	.toast.is-hide { opacity: 0; transform: translate(-50%, -10px); }
	@keyframes toastIn {
		from { opacity: 0; transform: translate(-50%, -10px); }
		to   { opacity: 1; transform: translate(-50%, 0); }
	}

	/* 실패 알림은 빨간색 + 아이콘.
	   성공과 실패가 같은 검은 상자로 뜨면 무심코 지나치게 된다. */
	.toast--error { background: #DC2626; }
	.toast__ico   { margin-right: 8px; font-weight: 700; }
</style>

<%-- msgType 이 'error' 면 빨간 토스트. 안 넘어오면 기본(검정) --%>
<c:set var="isErr" value="${msgType eq 'error'}"/>

<div class="toast ${isErr ? 'toast--error' : ''}" id="toast">
	<c:if test="${isErr}"><span class="toast__ico">!</span></c:if>
	<c:out value="${msg}"/>
</div>
<script>
	// 실패 알림은 읽을 시간이 더 필요하므로 오래 띄운다
	var HOLD = ${isErr ? 4500 : 2500};

	setTimeout(function () {
		var t = document.getElementById('toast');
		if (t) { t.classList.add('is-hide'); }
	}, HOLD);
	setTimeout(function () {
		var t = document.getElementById('toast');
		if (t) { t.remove(); }
	}, HOLD + 500);
</script>
</c:if>
</body>
</html>