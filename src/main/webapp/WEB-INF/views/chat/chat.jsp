<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>수릿 채팅</title>
<link rel="stylesheet" href="/css/style.css">
<link rel="stylesheet" href="/css/pages.css">
<style>
	.chat-wrap   { max-width: 720px; margin: 24px auto; }
	.chat-head   { display:flex; justify-content:space-between; align-items:center;
	               padding:14px 16px; border:1px solid #E5E7EB; border-radius:14px 14px 0 0;
	               background:#F9FAFB; }
	.chat-head h2{ font-size:16px; margin:0; }
	.chat-head .sub { font-size:12px; color:#6B7280; margin-top:2px; }
	.chat-head .right { display:flex; gap:8px; align-items:center; }
	.chat-body   { height:60vh; overflow-y:auto; padding:16px;
	               border:1px solid #E5E7EB; border-top:0; background:#fff; }
	.chat-foot   { display:flex; gap:8px; padding:12px 16px;
	               border:1px solid #E5E7EB; border-top:0; border-radius:0 0 14px 14px;
	               background:#F9FAFB; }
	.chat-foot input { flex:1; }

	/* ★ 기본은 왼쪽(상대), .mine 만 오른쪽(나) */
	.msg         { margin-bottom:14px; display:flex; flex-direction:column;
	               align-items:flex-start; }
	.msg .who    { font-size:12px; color:#6B7280; margin-bottom:4px; }
	.msg .bubble { max-width:70%; padding:10px 14px; border-radius:14px;
	               line-height:1.5; word-break:break-all; white-space:pre-wrap;
	               text-align:left; background:#F3F4F6; color:#111827; }
	.msg .time   { font-size:11px; color:#9CA3AF; margin-top:4px; }

	.msg.mine         { align-items:flex-end; }
	.msg.mine .bubble { background:#2F6BFF; color:#fff; }
</style>
</head>
<body>

<div class="chat-wrap">
<c:choose>

	<%-- 방이 없거나 권한이 없을 때 : 이유를 그대로 보여준다 --%>
	<c:when test="${empty room}">
		<div class="card">
			<p class="empty"><c:out value="${msg}"/></p>
			<c:if test="${not empty backUrl}">
				<a class="btn btn--ghost" href="${fn:escapeXml(backUrl)}">목록으로</a>
			</c:if>
		</div>
	</c:when>

	<%-- 정상 --%>
	<c:otherwise>

		<div class="chat-head">
			<div>
				<h2>
					<c:choose>
						<c:when test="${not empty roomTitle}">
							<c:out value="${roomTitle}"/>
						</c:when>
						<c:when test="${myNo == room.userNo}">
							<c:out value="${room.fixerName}"/> 기사님
						</c:when>
						<c:otherwise>
							<c:out value="${room.userName}"/> 고객님
						</c:otherwise>
					</c:choose>
				</h2>
				<div class="sub">
					<c:out value="${empty roomSub ? room.requestTitle : roomSub}"/>
				</div>
			</div>
			<div class="right">
				<c:if test="${not empty backUrl}">
					<a class="btn btn--ghost btn--sm" href="${fn:escapeXml(backUrl)}">목록</a>
				</c:if>
				<span class="badge badge--gray" id="connState">연결 중…</span>
			</div>
		</div>

		<div class="chat-body" id="chatBody">
			<c:forEach var="m" items="${history}">
				<div class="msg ${m.senderNo == myNo ? 'mine' : ''}">
					<span class="who"><c:out value="${m.senderName}"/></span>
					<%-- ★ ${m.content} 로 쓰면 XSS 로 뚫린다. 반드시 c:out --%>
					<span class="bubble"><c:out value="${m.content}"/></span>
					<span class="time"><c:out value="${m.sentAt}"/></span>
				</div>
			</c:forEach>
		</div>

		<div class="chat-foot">
			<input type="text" id="msgInput" class="input"
			       placeholder="메시지를 입력하세요" maxlength="1000" autocomplete="off">
			<button type="button" id="sendBtn" class="btn btn--primary">전송</button>
		</div>

		<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.6.1/dist/sockjs.min.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
		<script>
		(function () {

			var roomId = ${room.roomId};
			var myNo   = ${myNo};

			var body      = document.getElementById('chatBody');
			var input     = document.getElementById('msgInput');
			var sendBtn   = document.getElementById('sendBtn');
			var connState = document.getElementById('connState');

			var stomp = null;

			// ★ innerHTML 을 쓰면 상대가 <script> 를 보냈을 때 그대로 실행된다.
			//   반드시 textContent 로만 넣는다.
			function appendMessage(m) {
				var row = document.createElement('div');
				row.className = 'msg' + (Number(m.senderNo) === myNo ? ' mine' : '');

				var who = document.createElement('span');
				who.className = 'who';
				who.textContent = m.senderName || '';

				var bubble = document.createElement('span');
				bubble.className = 'bubble';
				bubble.textContent = m.content || '';

				var time = document.createElement('span');
				time.className = 'time';
				time.textContent = m.sentAt || '';

				row.appendChild(who);
				row.appendChild(bubble);
				row.appendChild(time);
				body.appendChild(row);

				body.scrollTop = body.scrollHeight;
			}

			function setState(text, cls) {
				connState.textContent = text;
				connState.className = 'badge ' + cls;
			}

			function connect() {
				var sock = new SockJS('/ws-chat');
				stomp = Stomp.over(sock);
				stomp.debug = null;

				stomp.connect({},
					function () {
						setState('연결됨', 'badge--ok');
						stomp.subscribe('/sub/chat/room/' + roomId, function (frame) {
							appendMessage(JSON.parse(frame.body));
						});
					},
					function () {
						setState('재연결 중…', 'badge--warn');
						setTimeout(connect, 3000);
					}
				);
			}

			function send() {
				var text = input.value.trim();
				if (text === '')                { return; }
				if (!stomp || !stomp.connected) { return; }

				stomp.send('/pub/chat/' + roomId, {}, JSON.stringify({ content: text }));
				input.value = '';
				input.focus();
			}

			sendBtn.addEventListener('click', send);
			input.addEventListener('keydown', function (e) {
				if (e.key === 'Enter' && !e.shiftKey) {
					e.preventDefault();
					send();
				}
			});

			connect();
			body.scrollTop = body.scrollHeight;
		})();
		</script>

	</c:otherwise>
</c:choose>
</div>

</body>
</html>