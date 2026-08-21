/* 수릿 공통 스크립트 — 프로토타입용 최소 동작만 */

/* 헤더 프로필 드롭다운 — 버튼 클릭 시 열고, 바깥을 누르면 닫힘 */
document.addEventListener('click', function (e) {
  var btn = e.target.closest('.profile__btn');
  document.querySelectorAll('.profile').forEach(function (p) {
    if (btn && p.contains(btn)) p.classList.toggle('is-open');
    else p.classList.remove('is-open');
  });
});

/* 접수 페이지 : 메인에서 넘어온 ?cat= 값으로 카테고리 미리 선택 */
(function () {
  var cat = (location.search.match(/[?&]cat=([^&]*)/) || [])[1];
  if (!cat) return;
  var target = document.querySelector('.cat[data-cat="' + decodeURIComponent(cat) + '"]');
  if (!target) return;
  document.querySelectorAll('.cat').forEach(function (c) { c.classList.remove('is-on'); });
  target.classList.add('is-on');
})();

/* 선택형 UI (카테고리 / 라디오 카드 / 칩) — 같은 그룹 안에서 하나만 선택 */
document.addEventListener('click', function (e) {
  var el = e.target.closest('[data-select]');
  if (!el) return;
  var group = el.getAttribute('data-select');
  document.querySelectorAll('[data-select="' + group + '"]').forEach(function (x) {
    x.classList.remove('is-on');
  });
  el.classList.add('is-on');
});

/* 다중 선택 칩 */
document.addEventListener('click', function (e) {
  var el = e.target.closest('[data-toggle]');
  if (!el) return;
  el.classList.toggle('chip--on');
});

/* 별점 입력 */
document.querySelectorAll('[data-star]').forEach(function (box) {
  var svgs = box.querySelectorAll('svg');
  svgs.forEach(function (s, i) {
    s.style.cursor = 'pointer';
    s.addEventListener('click', function () {
      svgs.forEach(function (t, j) { t.classList.toggle('off', j > i); });
      var out = document.querySelector(box.getAttribute('data-star'));
      if (out) out.textContent = (i + 1) + '.0';
    });
  });
});

/* FAQ 아코디언 */
document.addEventListener('click', function (e) {
  var q = e.target.closest('.faq__q');
  if (!q) return;
  q.parentElement.classList.toggle('is-open');
});
