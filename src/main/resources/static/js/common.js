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

/* 회원가입 : 회원 유형(role) 선택 카드가 hidden input(userRole)에도 값을 반영 */
/* 카드 전환 자체는 위 [data-select] 핸들러가 처리, 여기서는 hidden input 동기화만 담당 */
document.addEventListener('click', function (e) {
  var el = e.target.closest('[data-select="role"]');
  if (!el) return;
  var roleInput = document.getElementById('user-role');
  if (roleInput) roleInput.value = el.dataset.role;
});

/* 회원가입 폼 유효성 검사 + 아이디 중복확인 */
(function () {
  var form = document.getElementById('sign-form');
  if (!form) return;

  var idChecked = false; // 중복확인 통과 여부 (true여야 제출 가능)

  var rules = [
    {
      inputId: 'user-id',
      resultId: 'check-id-result',
      validate: function (v) {
        if (!v.trim()) return '아이디를 입력해주세요';
        if (v.length < 4 || v.length > 20) return '아이디는 4~20자로 입력해주세요';
        if (!/^[a-zA-Z0-9]+$/.test(v)) return '아이디는 영문·숫자만 사용할 수 있어요';
        return null;
      }
    },
    {
      inputId: 'user-pwd',
      resultId: null,
      validate: function (v) {
        if (!v) return '비밀번호를 입력해주세요';
        if (v.length < 8) return '비밀번호는 8자 이상 입력해주세요';
        return null;
      }
    },
    {
      inputId: 'user-pwd-confirm',
      resultId: 'check-pwd-result',
      validate: function (v) {
        var pwd = document.getElementById('user-pwd').value;
        if (!v) return '비밀번호를 한 번 더 입력해주세요';
        if (v !== pwd) return '비밀번호가 일치하지 않습니다';
        return null;
      }
    },
    {
      inputId: 'user-name',
      resultId: 'check-name-result',
      validate: function (v) {
        if (!v.trim()) return '이름을 입력해주세요';
        return null;
      }
    },
    {
      inputId: 'user-email',
      resultId: 'check-email-result',
      validate: function (v) {
        if (!v) return '이메일을 입력해주세요'; // DB EMAIL 컬럼이 NOT NULL이라 필수로 변경
        var ok = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v);
        return ok ? null : '이메일 형식이 올바르지 않습니다';
      }
    }
  ];

  function showError(rule, message, colorVar) {
    var input = document.getElementById(rule.inputId);
    if (input) input.style.borderColor = message ? 'var(--danger)' : '';
    if (!rule.resultId) return;
    var out = document.getElementById(rule.resultId);
    if (!out) return;
    out.textContent = message || '';
    out.style.color = message ? (colorVar || 'var(--danger)') : '';
  }

  // 입력 중에는 실시간으로 에러 지우기
  rules.forEach(function (rule) {
    var input = document.getElementById(rule.inputId);
    if (!input) return;
    input.addEventListener('input', function () {
      var message = rule.validate(input.value);
      showError(rule, message);
      // 아이디를 다시 고치면 예전 중복확인 결과는 무효
      if (rule.inputId === 'user-id') idChecked = false;
    });
  });

  /* 아이디 중복확인 버튼 */
  var idRule = rules[0];
  var idInput = document.getElementById('user-id');
  var idResult = document.getElementById('check-id-result');
  var checkIdBtn = document.getElementById('check-id-btn');

  if (checkIdBtn && idInput && idResult) {
    checkIdBtn.addEventListener('click', function () {
      var value = idInput.value.trim();
      var formatMessage = idRule.validate(value);

      if (formatMessage) {
        showError(idRule, formatMessage);
        idChecked = false;
        return;
      }

      idResult.textContent = '확인 중...';
      idResult.style.color = '';
      idInput.style.borderColor = '';
      checkIdBtn.disabled = true;

      fetch('/user/checkId?userId=' + encodeURIComponent(value))
        .then(function (res) {
          if (!res.ok) throw new Error('request-failed');
          return res.json();
        })
        .then(function (result) {
          var isDuplicate = result.data; // true면 이미 사용중
          idChecked = !isDuplicate;
          idResult.textContent = result.message;
          idResult.style.color = isDuplicate ? 'var(--danger)' : 'var(--ok)';
          idInput.style.borderColor = isDuplicate ? 'var(--danger)' : '';
        })
        .catch(function () {
          idChecked = false;
          idResult.textContent = '중복확인 중 오류가 발생했습니다. 다시 시도해주세요';
          idResult.style.color = 'var(--danger)';
        })
        .finally(function () {
          checkIdBtn.disabled = false;
        });
    });
  }

  form.addEventListener('submit', function (e) {
    var firstInvalid = null;

    rules.forEach(function (rule) {
      var input = document.getElementById(rule.inputId);
      if (!input) return;
      var message = rule.validate(input.value);
      showError(rule, message);
      if (message && !firstInvalid) firstInvalid = input;
    });

    // 형식은 통과했어도 중복확인을 안 눌렀거나, 눌렀는데 이미 쓰는 아이디면 제출 차단
    if (!firstInvalid && !idChecked) {
      idResult.textContent = '아이디 중복확인을 해주세요';
      idResult.style.color = 'var(--danger)';
      idInput.style.borderColor = 'var(--danger)';
      firstInvalid = idInput;
    }

    if (firstInvalid) {
      e.preventDefault();
      firstInvalid.focus();
    }
  });
})();

/* 기본 주소 체크박스 -> hidden input(isDefault)에 Y/N 반영 */
(function () {
  var checkbox = document.getElementById('is-default-checkbox');
  var hidden = document.getElementById('is-default');
  if (!checkbox || !hidden) return;

  checkbox.addEventListener('change', function () {
    hidden.value = checkbox.checked ? 'Y' : 'N';
  });
})();

/* 수리 접수 : 카테고리 카드 선택 -> hidden input(categoryCode) 동기화 */
document.addEventListener('click', function (e) {
  var el = e.target.closest('[data-select="category"]');
  if (!el) return;
  var input = document.getElementById('category-code');
  if (input) input.value = el.dataset.categoryCode;
});

/* 수리 접수 : 긴급출동 체크박스 -> hidden input(useYn)에 Y/N 반영 */
(function () {
  var checkbox = document.getElementById('request-urgent-checkbox');
  var hidden = document.getElementById('request-urgent');
  if (!checkbox || !hidden) return;

  checkbox.addEventListener('change', function () {
    hidden.value = checkbox.checked ? 'Y' : 'N';
  });
})();