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
</style>
<div class="toast" id="toast"><c:out value="${msg}"/></div>
<script>
	setTimeout(function () {
		var t = document.getElementById('toast');
		if (t) { t.classList.add('is-hide'); }
	}, 2500);
	setTimeout(function () {
		var t = document.getElementById('toast');
		if (t) { t.remove(); }
	}, 3000);
</script>
</c:if>
</body>
</html>