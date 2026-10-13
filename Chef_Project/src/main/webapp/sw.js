/* 방구석 셰프 Service Worker
 * - 화면(JSP) : 네트워크 우선, 오프라인이면 마지막으로 본 화면 → offline.html
 * - css/js : 네트워크 우선 (수정하면 바로 반영), 오프라인이면 저장본
 * - 이미지/폰트 : 캐시 우선 + 백그라운드 갱신
 */
const VERSION = 'chef-v3';
const STATIC_CACHE = VERSION + '-static';
const PAGE_CACHE = VERSION + '-pages';

const PRECACHE = [
  './offline.html',
  './manifest.json',
  './resources/css/bootstrap.min.css',
  './resources/css/grocery.css',
  './resources/vendor/bootstrap-icons/bootstrap-icons.min.css',
  './resources/vendor/bootstrap-icons/fonts/bootstrap-icons.woff2',
  './resources/js/bootstrap.bundle.min.js',
  './resources/js/pwa.js',
  './resources/icons/icon-192.png',
  './resources/icons/logo.png',
  './resources/icons/favicon-32.png'
];

// 장바구니 담기/삭제, 결제 처리처럼 상태를 바꾸는 화면은 캐시하지 않음
const NO_CACHE = /(addCart|deleteCart|deleteRefri|deleteFood|process\w*|logout|thankCust|login|j_security_check)/i;

self.addEventListener('install', (event) => {
  // cache: 'reload' → 브라우저 HTTP 캐시를 건너뛰고 최신 파일 저장
  event.waitUntil(
    caches.open(STATIC_CACHE)
      .then((c) => c.addAll(PRECACHE.map((u) => new Request(u, { cache: 'reload' }))))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys()
      .then((keys) => Promise.all(keys.filter((k) => !k.startsWith(VERSION)).map((k) => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  const req = event.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);

  if (req.mode === 'navigate') {
    event.respondWith(networkFirst(req, !NO_CACHE.test(url.pathname)));
    return;
  }
  if (url.origin === location.origin && /\.(css|js|json)$/i.test(url.pathname)) {
    event.respondWith(networkFirstStatic(req));
    return;
  }
  if (url.origin !== location.origin || /\.(png|jpe?g|gif|webp|svg|woff2?)$/i.test(url.pathname)) {
    event.respondWith(staleWhileRevalidate(req));
  }
});

async function networkFirst(req, cacheable) {
  try {
    const res = await fetch(req);
    if (cacheable && res.ok && !res.redirected) {
      const cache = await caches.open(PAGE_CACHE);
      cache.put(req, res.clone());
    }
    return res;
  } catch (e) {
    return (await caches.match(req)) || (await caches.match('./offline.html'));
  }
}

async function networkFirstStatic(req) {
  const cache = await caches.open(STATIC_CACHE);
  try {
    const res = await fetch(new Request(req.url, { cache: 'no-cache' }));
    if (res.ok) cache.put(req.url.split('?')[0], res.clone());
    return res;
  } catch (e) {
    return (await cache.match(req, { ignoreSearch: true })) || Response.error();
  }
}

async function staleWhileRevalidate(req) {
  const cache = await caches.open(STATIC_CACHE);
  const cached = await cache.match(req, { ignoreSearch: true });
  const network = fetch(req)
    .then((res) => {
      if (res && (res.ok || res.type === 'opaque')) cache.put(req, res.clone());
      return res;
    })
    .catch(() => cached);
  return cached || network;
}
