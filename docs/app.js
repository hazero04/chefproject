/* 방구석 셰프 - GitHub Pages용 정적 PWA 버전
 * JSP 버전과 같은 화면/흐름을 브라우저(localStorage)에서 동작하도록 옮긴 것.
 * 데이터 시드는 data.js (tools/build_pages.py 가 SQL 파일에서 생성)
 */
(function () {
  'use strict';

  var DATA = window.CHEF_DATA || { foods: [], recipes: [] };
  var app = document.getElementById('app');
  var KEY = 'chef.state.v1';

  /* ---------- 상태 (localStorage, 실패해도 메모리로 동작) ---------- */
  function addDays(n) {
    var d = new Date(); d.setDate(d.getDate() + n);
    return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
  }
  function findSeed(name) { return DATA.foods.filter(function (f) { return f.name === name; })[0] || {}; }
  function seedFridgeItem(name, days, count) {
    var f = findSeed(name);
    return { name: name, description: f.description || '', price: f.price || 0, date: addDays(days), place: '온라인 배송', count: count, filename: f.filename || '' };
  }
  function freshState() {
    return {
      foods: JSON.parse(JSON.stringify(DATA.foods)),
      cart: [],               // [{name, qty}]
      checkout: [],           // 결제할 [{...food, qty}]
      shipping: null,
      lastOrder: null,
      // 처음 방문해도 냉장고/레시피 화면을 체험할 수 있도록 데모 재료 몇 개
      fridge: [seedFridgeItem('당근', 3, 2), seedFridgeItem('계란', 12, 1), seedFridgeItem('양파', 1, 3), seedFridgeItem('토마토', 25, 2)]
    };
  }
  var state;
  try { state = JSON.parse(localStorage.getItem(KEY)) || freshState(); } catch (e) { state = freshState(); }
  function save() { try { localStorage.setItem(KEY, JSON.stringify(state)); } catch (e) { /* 저장 불가: 메모리로만 동작 */ } }

  /* ---------- 유틸 ---------- */
  function esc(s) {
    return String(s == null ? '' : s).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
    });
  }
  function won(n) { return Number(n || 0).toLocaleString('ko-KR') + '원'; }
  function imgSrc(f) {
    if (!f) return '';
    return /^data:/.test(f) ? f : './assets/images/' + encodeURIComponent(f);
  }
  function img(f, alt, extra) {
    return '<img src="' + esc(imgSrc(f)) + '" alt="' + esc(alt) + '" loading="lazy" ' + (extra || '') +
      ' onerror="this.onerror=null;this.src=\'./assets/icons/logo.png\'">';
  }
  function food(name) { return state.foods.filter(function (f) { return f.name === name; })[0]; }
  function enc(s) { return encodeURIComponent(s); }
  function go(hash) { location.hash = hash; }
  function truncate(s, n) { s = s || ''; return s.length > n ? s.substring(0, n) + '...' : s; }
  function dday(dateStr) {
    var t = new Date(); t.setHours(0, 0, 0, 0);
    var d = new Date(dateStr + 'T00:00:00');
    return Math.round((d - t) / 86400000);
  }
  function footer() {
    return '<footer class="g-footer">&copy; <b>Chef_Project</b> 쩝쩝박사 · 방구석 셰프</footer>';
  }
  function pageHead(title, sub, back, right) {
    return '<div class="g-page-head"><div class="d-flex align-items-center">' +
      (back ? '<a href="' + back + '" class="g-back" aria-label="뒤로"><i class="bi bi-chevron-left"></i></a>' : '') +
      '<div><h1>' + title + '</h1><p>' + sub + '</p></div></div>' + (right || '') + '</div>';
  }

  /* ---------- 장바구니 ---------- */
  function addCart(name) {
    var item = state.cart.filter(function (c) { return c.name === name; })[0];
    if (item) item.qty += 1; else state.cart.push({ name: name, qty: 1 });
    save();
  }
  function cartItems() {
    return state.cart.map(function (c) {
      var f = food(c.name);
      return f ? Object.assign({}, f, { qty: c.qty }) : null;
    }).filter(Boolean);
  }
  function confirmAdd(name) {
    if (confirm('식재료를 장바구니에 추가하시겠습니까?')) { addCart(name); go('#/cart'); }
  }

  /* ---------- 화면들 ---------- */
  var views = {};
  var clockTimer = null;

  views.home = function () {
    var featured = state.foods.slice(0, 10).map(function (f) {
      return '<div class="g-card">' +
        '<a class="g-card-img" href="#/food/' + enc(f.name) + '">' + img(f.filename, f.name) + '</a>' +
        '<p class="g-card-title">' + esc(f.name) + '</p>' +
        '<div class="g-card-sub">' + esc(f.place) + '</div>' +
        '<div class="g-card-foot"><span class="g-price">' + won(f.price) + '</span>' +
        '<button class="g-add" data-add="' + esc(f.name) + '" aria-label="' + esc(f.name) + ' 담기"><i class="bi bi-plus-lg"></i></button></div>' +
        '</div>';
    }).join('');
    return '' +
      '<a href="#/list" class="g-search mt-3"><i class="bi bi-search"></i><span>식재료 마트에서 찾아보세요</span></a>' +
      '<section class="g-banner mt-3"><div class="g-banner-body">' +
      '<h1>안녕하세요🙌 <br>저는 레시피를 추천해드리는 당신만의 셰프입니다!</h1>' +
      '<p>Welcome to Chef\'s refrigerator! · The refrigerator of Chef</p>' +
      '<div class="g-clock"><i class="bi bi-clock-fill"></i> 현재 접속 시각 <span id="clock"></span></div>' +
      '<div class="g-dots"><span class="on"></span><span></span><span></span></div>' +
      '</div><div class="g-banner-veg" aria-hidden="true">🥬🥕🍅</div></section>' +
      '<div class="g-section-head"><h2>무엇을 해볼까요?</h2></div>' +
      '<div class="row g-3">' +
      cat('#/list', 'c1', '🛒', '식재료 마트', '신선한 재료 둘러보기') +
      cat('#/recipe', 'c2', '🍳', '레시피 추천', '재료로 요리 찾기') +
      cat('#/fridge', 'c6', '🧊', '나의 냉장고', '유통기한 관리') +
      cat('#/cart', 'c4', '🧺', '장바구니', '담은 재료 주문하기') +
      '</div>' +
      '<div class="g-section-head"><h2>오늘의 신선 식재료</h2><a href="#/list">전체보기</a></div>' +
      '<div class="g-hscroll">' + featured + '</div>' + footer();
  };
  views.home.after = function () {
    var el = document.getElementById('clock');
    function tick() {
      var d = new Date(), h = d.getHours(), ap = h < 12 ? 'AM' : 'PM';
      if (h >= 12) h -= 12;
      if (el) el.textContent = h + ':' + d.getMinutes() + ':' + d.getSeconds() + ' ' + ap;
    }
    tick(); clockTimer = setInterval(tick, 1000);
  };
  function cat(href, cls, ico, title, sub) {
    return '<div class="col-6 col-md-3"><a href="' + href + '" class="g-cat ' + cls + '"><span class="g-cat-ico">' + ico +
      '</span><b>' + title + '</b><small>' + sub + '</small></a></div>';
  }

  function productCard(f, footBtn) {
    return '<div class="col-6 col-md-4 col-lg-3" data-food="' + esc(f.name) + '"><div class="g-card">' +
      '<a class="g-card-img" href="#/food/' + enc(f.name) + '">' + img(f.filename, f.name) + '</a>' +
      '<p class="g-card-title"><a href="#/food/' + enc(f.name) + '">' + esc(f.name) + '</a></p>' +
      '<div class="g-card-sub">' + esc(f.place) + ' · 유통기한 ' + esc(f.date) + '</div>' +
      '<p class="g-card-desc">' + esc(truncate(f.description, 60)) + '</p>' +
      '<div class="g-card-foot"><span class="g-price">' + won(f.price) + '</span>' + footBtn + '</div>' +
      '</div></div>';
  }

  views.list = function () {
    var cards = state.foods.map(function (f) {
      return productCard(f, '<button class="g-add" data-add="' + esc(f.name) + '" aria-label="장바구니 담기"><i class="bi bi-plus-lg"></i></button>');
    }).join('');
    return pageHead('식재료 목록', 'FoodList · 신선한 식재료를 골라보세요') +
      '<label class="g-search mb-4"><i class="bi bi-search"></i><input type="search" id="foodSearch" placeholder="식재료 검색" autocomplete="off"></label>' +
      '<div class="row g-3">' + cards + '</div>' +
      '<div class="g-empty" id="noResult" hidden><div class="g-empty-ico">🔍</div><b>검색 결과가 없어요</b>다른 식재료 이름으로 찾아보세요.</div>' +
      footer();
  };
  views.list.after = function () {
    var input = document.getElementById('foodSearch');
    input.addEventListener('input', function () {
      var k = input.value.trim(), shown = 0;
      document.querySelectorAll('[data-food]').forEach(function (el) {
        var on = el.getAttribute('data-food').indexOf(k) > -1;
        el.style.display = on ? '' : 'none';
        if (on) shown++;
      });
      document.getElementById('noResult').hidden = shown > 0;
    });
  };

  views.food = function (name) {
    var f = food(name);
    if (!f) return views.error(name);
    return pageHead('식재료 정보', 'FoodInfo', '#/list') +
      '<div class="row g-4 g-lg-5 g-detail">' +
      '<div class="col-lg-6"><div class="g-detail-img">' + img(f.filename, f.name) + '</div></div>' +
      '<div class="col-lg-6">' +
      '<div class="d-flex justify-content-between align-items-start"><div><h1>' + esc(f.name) + '</h1>' +
      '<span class="g-chip green">재고 ' + esc(f.stock) + '개</span></div><span class="g-big-price">' + won(f.price) + '</span></div>' +
      '<div class="mt-4">' +
      '<div class="g-info-row d-block"><div class="mb-2">상세 설명</div><span class="d-block lh-lg">' + esc(f.description) + '</span></div>' +
      '<div class="g-info-row">가격 <span>' + won(f.price) + '</span></div>' +
      '<div class="g-info-row">유통기한 <span>' + esc(f.date) + '</span></div>' +
      '<div class="g-info-row">구입처 <span>' + esc(f.place) + '</span></div>' +
      '<div class="g-info-row">재고수 <span>' + esc(f.stock) + '개</span></div>' +
      '</div>' +
      '<div class="mt-4 d-grid gap-2">' +
      '<button class="g-btn block" data-add="' + esc(f.name) + '"><i class="bi bi-basket2-fill"></i> 식재료 주문 (장바구니 담기)</button>' +
      '<a href="#/list" class="g-btn ghost block">식재료 목록</a></div>' +
      '</div></div>' + footer();
  };

  views.cart = function () {
    var items = cartItems(), sum = 0;
    var rows = items.map(function (f) {
      var total = f.price * f.qty; sum += total;
      return '<div class="g-cart-row">' +
        '<input type="checkbox" class="g-check" name="checkedBox" value="' + esc(f.name) + '" checked aria-label="' + esc(f.name) + ' 선택">' +
        '<div class="g-cart-thumb">' + img(f.filename, f.name) + '</div>' +
        '<div class="g-cart-info"><b>' + esc(f.name) + '</b><small>' + won(f.price) + ' · 유통기한 <span class="text-nowrap">' + esc(f.date) + '</span></small>' +
        '<div class="g-qty"><button type="button" class="g-icon-btn" style="width:36px;height:36px;font-size:16px" data-qty="-1" data-name="' + esc(f.name) + '" aria-label="빼기"><i class="bi bi-dash-lg"></i></button>' +
        '<span>' + f.qty + '개</span>' +
        '<button type="button" class="g-icon-btn" style="width:36px;height:36px;font-size:16px;color:var(--g-primary)" data-qty="1" data-name="' + esc(f.name) + '" aria-label="더하기"><i class="bi bi-plus-lg"></i></button></div></div>' +
        '<div class="g-cart-right"><button type="button" class="g-x border-0 bg-transparent p-0" data-del-cart="' + esc(f.name) + '" aria-label="삭제"><i class="bi bi-x-lg"></i></button>' +
        '<span class="g-price">' + won(total) + '</span></div></div>';
    }).join('');
    var empty = '<div class="g-empty"><div class="g-empty-ico">🧺</div><b>장바구니가 비어 있어요</b>식재료 마트에서 맛있는 재료를 담아보세요!</div>';
    return pageHead('장바구니', 'FoodCart · 주문할 식재료를 선택하세요') +
      '<form id="cartForm"><div class="row g-4"><div class="col-lg-8">' + (items.length ? rows : empty) +
      '<a href="#/list" class="g-btn ghost sm mt-4"><i class="bi bi-chevron-left"></i> 쇼핑 계속하기</a></div>' +
      '<div class="col-lg-4"><div class="g-summary">' +
      '<div class="g-summary-row"><span>담은 식재료</span><span>' + items.length + '종류</span></div>' +
      '<div class="g-summary-row"><span>배송비</span><span>무료</span></div>' +
      '<div class="g-summary-row total"><span>총금액</span><span>' + won(sum) + '</span></div>' +
      '<button type="submit" class="g-btn block mt-3">주문하기 <span class="g-btn-tag">' + won(sum) + '</span></button>' +
      '</div></div></div></form>' + footer();
  };
  views.cart.after = function () {
    document.getElementById('cartForm').addEventListener('submit', function (e) {
      e.preventDefault();
      var names = Array.prototype.map.call(document.querySelectorAll('[name=checkedBox]:checked'), function (c) { return c.value; });
      if (!names.length) { alert('주문할 식재료를 선택해 주세요.'); return; }
      state.checkout = cartItems().filter(function (f) { return names.indexOf(f.name) > -1; });
      save(); go('#/delivery');
    });
  };

  views.delivery = function () {
    if (!state.checkout.length) { go('#/cart'); return ''; }
    var s = state.shipping || {};
    function field(id, label, type, ph, col) {
      return '<div class="' + (col || '') + ' g-field"><label for="' + id + '">' + label + '</label>' +
        '<input type="' + (type || 'text') + '" id="' + id + '" name="' + id + '" class="form-control" required value="' + esc(s[id] || '') + '"' + (ph ? ' placeholder="' + ph + '"' : '') + '></div>';
    }
    return pageHead('배송 정보', 'Shipping Info', '#/cart') +
      '<form id="shipForm" class="g-form-card">' +
      field('name', '성명') +
      field('shippingDate', '배송일', 'date') +
      '<div class="row">' + field('country', '국가명', 'text', '', 'col-sm-6') + field('zipCode', '우편번호', 'text', '', 'col-sm-6') + '</div>' +
      field('addressName', '주소') +
      '<div class="d-flex gap-2 mt-2"><a href="#/cart" class="g-btn ghost">이전</a><button type="submit" class="g-btn flex-grow-1">등록</button></div>' +
      '</form>' + footer();
  };
  views.delivery.after = function () {
    var form = document.getElementById('shipForm');
    if (!form) return;
    if (!form.shippingDate.value) form.shippingDate.value = addDays(2);
    form.addEventListener('submit', function (e) {
      e.preventDefault();
      state.shipping = {};
      ['name', 'shippingDate', 'country', 'zipCode', 'addressName'].forEach(function (k) { state.shipping[k] = form[k].value.trim(); });
      save(); go('#/payment');
    });
  };

  views.payment = function () {
    if (!state.checkout.length || !state.shipping) { go('#/cart'); return ''; }
    var s = state.shipping, sum = 0;
    var rows = state.checkout.map(function (f) {
      var total = f.price * f.qty; sum += total;
      return '<tr><td>' + esc(f.name) + '</td><td class="text-end">' + won(f.price) + '</td><td class="text-center">' + f.qty + '개</td><td class="text-end">' + won(total) + '</td></tr>';
    }).join('');
    return pageHead('주문 정보', 'Order Info', '#/delivery') +
      '<div class="row g-4"><div class="col-lg-8"><div class="g-receipt">' +
      '<div class="d-flex justify-content-between align-items-center mb-3 gap-2"><h2 class="fs-4 fw-bold m-0"><i class="bi bi-receipt text-success me-1"></i> 영수증</h2>' +
      '<span class="g-chip green">배송일 ' + esc(s.shippingDate) + '</span></div>' +
      '<table><thead><tr><th>식재료명</th><th class="text-end">가격</th><th class="text-center">수량</th><th class="text-end">합계</th></tr></thead>' +
      '<tbody>' + rows + '</tbody><tfoot><tr><td colspan="3">총 금액</td><td class="text-end text-success">' + won(sum) + '</td></tr></tfoot></table>' +
      '</div></div><div class="col-lg-4"><div class="g-summary">' +
      '<h3 class="fs-5 fw-bold mb-2"><i class="bi bi-geo-alt-fill text-success"></i> 배송 주소</h3>' +
      '<div class="g-summary-row"><span>성명</span><span>' + esc(s.name) + '</span></div>' +
      '<div class="g-summary-row"><span>우편번호</span><span>' + esc(s.zipCode) + '</span></div>' +
      '<div class="g-summary-row"><span>주소</span><span class="text-end">' + esc(s.addressName) + ' (' + esc(s.country) + ')</span></div>' +
      '<div class="g-summary-row"><span>배송일</span><span>' + esc(s.shippingDate) + '</span></div>' +
      '<div class="g-summary-row total"><span>결제 금액</span><span>' + won(sum) + '</span></div>' +
      '<button type="button" class="g-btn block mt-3" id="completeOrder">주문 완료</button>' +
      '<a href="#/delivery" class="g-btn ghost block mt-2">이전</a>' +
      '</div></div></div>' + footer();
  };
  views.payment.after = function () {
    var btn = document.getElementById('completeOrder');
    if (!btn) return;
    btn.addEventListener('click', function () {
      // 결제한 식재료를 나의 냉장고에 저장 (JSP 버전의 thankCust.jsp 와 동일)
      state.checkout.forEach(function (f) {
        state.fridge.push({ name: f.name, description: f.description, price: f.price, date: f.date, place: '온라인 배송', count: f.qty, filename: f.filename });
      });
      state.lastOrder = { date: state.shipping.shippingDate, id: 'CHEF-' + Date.now().toString(36).toUpperCase() };
      state.cart = []; state.checkout = []; state.shipping = null;
      save(); go('#/thanks');
    });
  };

  views.thanks = function () {
    var o = state.lastOrder;
    if (!o) { go('#/'); return ''; }
    return '<div class="g-success"><div class="g-success-ico"><i class="bi bi-check-lg"></i></div>' +
      '<h1>🎁주문해주셔서 감사합니다🎁</h1>' +
      '<p class="mt-3">주문은 <b class="text-success">' + esc(o.date) + '</b>에 배송될 예정입니다!</p>' +
      '<p class="small">주문번호: ' + esc(o.id) + '</p>' +
      '<p class="small">결제한 식재료는 <b>나의 냉장고</b>에 저장됩니다.</p>' +
      '<div class="d-grid gap-2 mt-4"><a href="#/fridge" class="g-btn block">나의 냉장고 보기</a>' +
      '<a href="#/list" class="g-btn ghost block">&laquo; 식재료 목록</a></div></div>' + footer();
  };

  var picked = [];
  views.recipe = function () {
    var names = [];
    state.fridge.forEach(function (f) { if (names.indexOf(f.name) < 0) names.push(f.name); });
    picked = picked.filter(function (p) { return names.indexOf(p) > -1; });
    var chips = names.map(function (n) {
      return '<div class="col-6 col-md-3"><label class="g-pick"><input type="checkbox" name="selectFood" value="' + esc(n) + '"' +
        (picked.indexOf(n) > -1 ? ' checked' : '') + '><span>' + esc(n) + '</span></label></div>';
    }).join('');
    var html = '<section class="g-banner mt-3"><div class="g-banner-body"><h1>🎉 레시피 추천 🎉</h1>' +
      '<p>사용하고 싶은 식재료를 선택하시면 레시피를 추천해드립니다.</p></div>' +
      '<div class="g-banner-veg" aria-hidden="true">🍳🥘</div></section>' +
      '<form id="recipeForm"><div class="g-section-head"><h2>🥬 어떤 식재료를 사용하고 싶은가요?</h2>' +
      '<span class="g-chip green">복수 선택 가능</span></div>' +
      (names.length ? '<div class="row g-2">' + chips + '</div>' :
        '<div class="g-empty"><div class="g-empty-ico">🧊</div><b>냉장고가 비어 있어요</b>식재료를 주문하면 냉장고 재료로 레시피를 추천해 드려요.</div>') +
      '<div class="text-center mt-4"><button type="submit" class="g-btn px-5">레시피 추천받기 ✨</button></div></form>';

    if (picked.length) {
      // JSP: FIND_IN_SET(재료) OR ... LIMIT 2 와 같은 규칙
      var found = DATA.recipes.filter(function (r) {
        var ing = r.ingredients.split(',');
        return picked.some(function (p) { return ing.indexOf(p) > -1; });
      }).slice(0, 2);
      html += '<div class="g-section-head mt-5" id="recipeResult"><h2>💡 레시피를 추천해드릴게요!!</h2></div><div class="row g-3">' +
        (found.length ? found.map(function (r, i) {
          return '<div class="col-md-6"><div class="g-recipe"><div class="g-recipe-head"><span class="g-chip">추천 요리 ' + (i + 1) + '</span>' +
            '<h3>' + esc(r.name) + '</h3></div><div class="g-recipe-body">' +
            '<p class="mb-3"><b>필요한 재료:</b> ' + esc(r.ingredients) + '</p><h5>🍳 조리 순서</h5>' +
            '<p class="mb-0">' + esc(r.manual).replace(/&lt;br&gt;/g, '<br>') + '</p></div></div></div>';
        }).join('') :
          '<div class="col-12"><div class="g-empty"><div class="g-empty-ico">🥕</div><b>추천 레시피가 없어요</b>선택하신 식재료가 포함된 추천 레시피가 없습니다. 다른 재료를 조합해 보세요!</div></div>') +
        '</div>';
    }
    return html + footer();
  };
  views.recipe.after = function () {
    document.getElementById('recipeForm').addEventListener('submit', function (e) {
      e.preventDefault();
      picked = Array.prototype.map.call(document.querySelectorAll('[name=selectFood]:checked'), function (c) { return c.value; });
      if (!picked.length) { alert('식재료를 하나 이상 선택해 주세요.'); return; }
      render();
      var r = document.getElementById('recipeResult');
      if (r) r.scrollIntoView({ behavior: 'smooth', block: 'start' });
    });
  };

  views.fridge = function () {
    var warn = state.fridge.filter(function (f) { var d = dday(f.date); return d >= 0 && d <= 7; });
    var html = pageHead('나의 냉장고', 'My Refrigerator · 구매한 식재료와 유통기한을 확인하세요');
    if (warn.length) {
      html += '<div class="g-alert" role="alert"><h4><i class="bi bi-exclamation-triangle-fill"></i> 경고 : 유통기한 임박 식재료 알림!</h4>' +
        '<div class="g-alert-items">' + warn.map(function (f) {
          return '<span class="g-alert-item">' + esc(f.name) + '<em>D-' + dday(f.date) + '</em></span>';
        }).join('') + '</div><p class="mt-3 mb-0 text-muted" style="font-size: 0.9rem;">빨리 요리해서 냉장고를 비워볼까요? 😋</p></div>';
    }
    if (!state.fridge.length) {
      return html + '<div class="g-empty"><div class="g-empty-ico">🧊</div><b>냉장고가 텅~ 비어 있습니다!</b>' +
        '장바구니에 맛있는 재료를 담아 채워보세요~~ 🛒<div class="mt-4"><a href="#/list" class="g-btn sm">식재료 마트 가기</a></div></div>' + footer();
    }
    html += '<div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-3">' + state.fridge.map(function (f, i) {
      var d = dday(f.date);
      var chip = d < 0 ? '<span class="g-chip red">기한 지남</span>' : d <= 7 ? '<span class="g-chip red">D-' + d + '</span>' : '';
      return '<div class="col"><div class="g-card">' +
        '<div class="g-card-img" style="aspect-ratio: 16 / 10;">' + img(f.filename, f.name) + '</div>' +
        '<div class="d-flex justify-content-between align-items-start gap-2"><p class="g-card-title fs-5">' + esc(f.name) + ' ' + chip + '</p>' +
        '<span class="g-chip green flex-shrink-0">현재 수량: ' + esc(f.count) + '개</span></div>' +
        '<p class="g-card-desc">' + esc(f.description || '등록된 상세 설명이 없습니다.') + '</p>' +
        '<div class="mb-3"><div class="g-info-row py-2 fs-6">유통기한 <span>' + esc(f.date) + '</span></div>' +
        '<div class="g-info-row py-2 fs-6">구매처 <span>' + esc(f.place || '미지정') + '</span></div></div>' +
        '<div class="g-card-foot"><span class="g-price">' + won(f.price) + '</span>' +
        '<button class="g-add danger" data-del-fridge="' + i + '" aria-label="삭제"><i class="bi bi-trash3"></i></button></div>' +
        '</div></div>';
    }).join('') + '</div>';
    return html + footer();
  };

  /* ---------- 관리자: 식재료 등록 / 수정 ---------- */
  function foodForm(f, isEdit) {
    f = f || {};
    function field(id, label, value, col, extra) {
      return '<div class="' + (col || '') + ' g-field"><label for="' + id + '">' + label + '</label>' +
        '<input type="text" id="' + id + '" name="' + id + '" class="form-control" value="' + esc(value == null ? '' : value) + '" ' + (extra || '') + '></div>';
    }
    return '<form id="foodForm" class="g-form-card">' +
      field('f_foodname', '식재료명', f.name) +
      '<div class="g-field"><label for="f_description">상세 설명</label><textarea id="f_description" name="f_description" rows="3" class="form-control" placeholder="10자 이상 적어주세요">' + esc(f.description || '') + '</textarea></div>' +
      '<div class="row">' + field('f_price', '가격', f.price, 'col-sm-6', 'inputmode="numeric"') + field('f_date', '유통기한', f.date, 'col-sm-6', 'placeholder="YYYY-MM-DD"') + '</div>' +
      '<div class="row">' + field('f_place', '구입처', f.place, 'col-sm-6') + field('unitsInStock', '재고 수량', f.stock, 'col-sm-6', 'inputmode="numeric"') + '</div>' +
      '<div class="g-field"><label for="f_filename">이미지 파일</label><input type="file" id="f_filename" accept="image/*" class="form-control"></div>' +
      '<button type="submit" class="g-btn block">' + (isEdit ? '수정 완료' : '등록') + '</button></form>';
  }
  // resources/js/validation.js 의 CheckAddFood() 와 같은 규칙
  function validate(form) {
    function fail(el, msg) { alert(msg); el.focus(); return false; }
    var n = form.f_foodname, d = form.f_description, p = form.f_price, s = form.unitsInStock, dt = form.f_date;
    if (n.value.length < 1 || n.value.length > 20) return fail(n, '[식재료명]\n최소 1자에서 최대 20자까지 입력하세요');
    if (d.value.length < 10) return fail(d, '[상세설명]\n최소 10자 이상 입력하세요');
    if (p.value.length === 0 || isNaN(p.value)) return fail(p, '[가격]\n숫자만 입력하세요');
    if (p.value < 0) return fail(p, '[가격]\n음수를 입력할 수 없습니다');
    if (isNaN(s.value)) return fail(s, '[재고 수]\n숫자만 입력하세요');
    if (!/^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$/.test(dt.value)) return fail(dt, '[유통기한]\n올바른 날짜 형식(YYYY-MM-DD)으로 입력하세요.\n');
    if (dday(dt.value) < 0) return fail(dt, '[유통기한]\n이미 지난 날짜는 입력할 수 없습니다.\n오늘 이후의 날짜를 입력해 주세요.');
    return true;
  }
  function readImage(input) {
    // 업로드 이미지를 400px 로 줄여 dataURL 로 저장 (localStorage 용량 절약)
    return new Promise(function (resolve) {
      var file = input.files && input.files[0];
      if (!file) return resolve(null);
      var reader = new FileReader();
      reader.onload = function () {
        var im = new Image();
        im.onload = function () {
          var scale = Math.min(1, 400 / Math.max(im.width, im.height));
          var c = document.createElement('canvas');
          c.width = Math.round(im.width * scale); c.height = Math.round(im.height * scale);
          c.getContext('2d').drawImage(im, 0, 0, c.width, c.height);
          resolve(c.toDataURL('image/jpeg', 0.85));
        };
        im.onerror = function () { resolve(null); };
        im.src = reader.result;
      };
      reader.readAsDataURL(file);
    });
  }
  function bindFoodForm(oldName) {
    var form = document.getElementById('foodForm');
    form.addEventListener('submit', function (e) {
      e.preventDefault();
      if (!validate(form)) return;
      var name = form.f_foodname.value.trim();
      if (name !== oldName && food(name)) { alert('이미 같은 이름의 식재료가 있습니다.'); return; }
      readImage(form.f_filename).then(function (dataUrl) {
        var f = oldName ? food(oldName) : {};
        f.name = name;
        f.description = form.f_description.value;
        f.price = parseInt(form.f_price.value, 10) || 0;
        f.date = form.f_date.value;
        f.place = form.f_place.value;
        f.stock = parseInt(form.unitsInStock.value, 10) || 0;
        if (dataUrl) f.filename = dataUrl;
        if (!oldName) state.foods.push(f);
        else state.cart.forEach(function (c) { if (c.name === oldName) c.name = name; });
        save();
        go(oldName ? '#/admin/edit' : '#/list');
      });
    });
  }
  views['admin-add'] = function () {
    return pageHead('식재료 추가', 'Ingredient Addition') + foodForm(null, false) + footer();
  };
  views['admin-add'].after = function () { bindFoodForm(null); };

  views['admin-edit'] = function (name) {
    if (name) {
      var f = food(name);
      if (!f) return views.error(name);
      return pageHead('식재료 수정', 'Food Change', '#/admin/edit') +
        '<div class="row g-4"><div class="col-lg-5"><div class="g-detail-img">' + img(f.filename, f.name) + '</div></div>' +
        '<div class="col-lg-7">' + foodForm(f, true) + '</div></div>' + footer();
    }
    return pageHead('식재료 수정', 'FoodEditing · 수정할 식재료를 선택하세요') +
      '<div class="row g-3">' + state.foods.map(function (f) {
        return productCard(f, '<a href="#/admin/edit/' + enc(f.name) + '" class="g-add" aria-label="수정"><i class="bi bi-pencil"></i></a>');
      }).join('') + '</div>' + footer();
  };
  views['admin-edit'].after = function (name) { if (name && document.getElementById('foodForm')) bindFoodForm(name); };

  views.error = function (name) {
    return '<div class="g-empty"><div class="g-empty-ico">🥲</div><b>해당 식재료가 존재하지 않습니다.</b>' +
      '<p class="small text-break mt-2">' + esc(name || location.hash) + '</p>' +
      '<a href="#/list" class="g-btn mt-3">식재료마트 목록 &raquo;</a></div>' + footer();
  };

  /* ---------- 라우터 ---------- */
  function parse() {
    var parts = (location.hash.replace(/^#\/?/, '') || '').split('/').map(function (p) {
      try { return decodeURIComponent(p); } catch (e) { return p; }
    });
    var r = parts[0] || 'home';
    if (r === 'admin') {
      r = 'admin-' + (parts[1] || 'edit');
      parts.splice(1, 1);
    }
    return { route: r, arg: parts[1] };
  }
  function render() {
    if (clockTimer) { clearInterval(clockTimer); clockTimer = null; }
    var p = parse();
    if (p.route === 'reset') {
      if (confirm('장바구니, 냉장고, 등록한 식재료를 처음 상태로 되돌릴까요?')) { state = freshState(); save(); }
      go('#/'); return;
    }
    var view = views[p.route] || views.error;
    var html = view(p.arg);
    if (html === '') return; // go() 로 다른 화면으로 이동하는 중
    app.innerHTML = html;
    if (view.after) view.after(p.arg);

    // 메뉴 활성화 + 장바구니 배지
    document.querySelectorAll('[data-nav]').forEach(function (a) {
      a.classList.toggle('active', a.getAttribute('data-nav').split(' ').indexOf(p.route) > -1);
    });
    var count = state.cart.length;
    document.querySelectorAll('[data-cart-badge]').forEach(function (b) { b.textContent = count; b.hidden = count === 0; });
    closeMenu();
  }

  /* ---------- 공통 이벤트 ---------- */
  var menu = document.getElementById('adminMenu'), toggle = document.getElementById('adminToggle');
  function closeMenu() { menu.classList.remove('show'); toggle.setAttribute('aria-expanded', 'false'); }
  toggle.addEventListener('click', function (e) {
    e.stopPropagation();
    var open = !menu.classList.contains('show');
    menu.classList.toggle('show', open); toggle.setAttribute('aria-expanded', String(open));
  });
  document.addEventListener('click', function (e) {
    if (!e.target.closest('.g-menu')) closeMenu();
    var t;
    if ((t = e.target.closest('[data-add]'))) { e.preventDefault(); confirmAdd(t.getAttribute('data-add')); }
    else if ((t = e.target.closest('[data-del-cart]'))) {
      var n = t.getAttribute('data-del-cart');
      state.cart = state.cart.filter(function (c) { return c.name !== n; }); save(); render();
    } else if ((t = e.target.closest('[data-qty]'))) {
      var item = state.cart.filter(function (c) { return c.name === t.getAttribute('data-name'); })[0];
      if (item) { item.qty = Math.max(1, item.qty + parseInt(t.getAttribute('data-qty'), 10)); save(); render(); }
    } else if ((t = e.target.closest('[data-del-fridge]'))) {
      var i = parseInt(t.getAttribute('data-del-fridge'), 10), f = state.fridge[i];
      if (f && confirm(f.name + ' 항목을 냉장고에서 삭제하시겠습니까?')) { state.fridge.splice(i, 1); save(); render(); }
    }
  });
  window.addEventListener('hashchange', function () { render(); window.scrollTo(0, 0); });
  render();

  /* ---------- PWA ---------- */
  if ('serviceWorker' in navigator) {
    // 업데이트가 적용되면(이전 버전이 있던 경우에만) 한 번 새로고침해서 최신 화면 표시
    var hadController = !!navigator.serviceWorker.controller, reloaded = false;
    navigator.serviceWorker.addEventListener('controllerchange', function () {
      if (hadController && !reloaded) { reloaded = true; location.reload(); }
    });
    window.addEventListener('load', function () {
      navigator.serviceWorker.register('./sw.js', { updateViaCache: 'none' })
        .then(function (reg) { reg.update(); })
        .catch(function (e) { console.warn('SW 등록 실패', e); });
    });
  }
  var deferredPrompt = null;
  var installBtns = document.querySelectorAll('[data-pwa-install]');
  window.addEventListener('beforeinstallprompt', function (e) {
    e.preventDefault(); deferredPrompt = e;
    installBtns.forEach(function (b) { b.hidden = false; });
  });
  installBtns.forEach(function (b) {
    b.addEventListener('click', function () {
      if (!deferredPrompt) return;
      deferredPrompt.prompt();
      deferredPrompt.userChoice.finally(function () { deferredPrompt = null; installBtns.forEach(function (x) { x.hidden = true; }); });
    });
  });
  function updateOnline() { document.documentElement.classList.toggle('g-offline', !navigator.onLine); }
  window.addEventListener('online', updateOnline);
  window.addEventListener('offline', updateOnline);
  updateOnline();
})();
