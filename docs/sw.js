/* 방구석 셰프 (GitHub Pages) Service Worker
 * - 화면/코드(html, js, css, json) : 네트워크 우선 → 배포하면 바로 반영, 오프라인이면 저장본
 * - 이미지/폰트 : 저장본 우선 (+ 백그라운드 갱신)
 * 처음 방문 때 전체를 미리 저장해 두어 오프라인에서도 모든 기능이 동작합니다.
 */
const VERSION = 'chef-pages-v6';

const FOOD_IMAGES = ['감자', '계란', '당근', '마늘', '버섯', '시금치', '양배추', '양파', '콩나물', '토마토']
  .map((n) => './assets/images/' + encodeURIComponent(n) + '.jpg');

const PRECACHE = [
  './',
  './index.html',
  './app.js',
  './data.js',
  './manifest.json',
  './assets/css/bootstrap.min.css',
  './assets/css/grocery.css',
  './assets/vendor/bootstrap-icons/bootstrap-icons.min.css',
  './assets/vendor/bootstrap-icons/fonts/bootstrap-icons.woff2',
  './assets/icons/icon-192.png',
  './assets/icons/logo.png',
  './assets/icons/favicon-32.png',
  ...FOOD_IMAGES
];

self.addEventListener('install', (event) => {
  // cache: 'reload' → 브라우저 HTTP 캐시(깃허브 10분 캐시)를 건너뛰고 최신 파일 저장
  event.waitUntil(
    caches.open(VERSION)
      .then((c) => c.addAll(PRECACHE.map((u) => new Request(u, { cache: 'reload' }))))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys()
      .then((keys) => Promise.all(keys.filter((k) => k !== VERSION).map((k) => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  const req = event.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  const sameOrigin = url.origin === location.origin;

  if (req.mode === 'navigate') {
    // 화면 이동은 항상 앱 셸(index.html)
    event.respondWith(networkFirst(new Request('./index.html', { cache: 'no-cache' }), './index.html'));
  } else if (sameOrigin && /\.(js|css|json|html)$/i.test(url.pathname)) {
    event.respondWith(networkFirst(new Request(req.url, { cache: 'no-cache' }), req.url));
  } else {
    event.respondWith(staleWhileRevalidate(req));
  }
});

async function networkFirst(req, key) {
  const cache = await caches.open(VERSION);
  try {
    const res = await fetch(req);
    if (res.ok) cache.put(key, res.clone());
    return res;
  } catch (e) {
    return (await cache.match(key, { ignoreSearch: true })) || Response.error();
  }
}

async function staleWhileRevalidate(req) {
  const cache = await caches.open(VERSION);
  const cached = await cache.match(req, { ignoreSearch: true });
  const network = fetch(req)
    .then((res) => {
      if (res && (res.ok || res.type === 'opaque')) cache.put(req, res.clone());
      return res;
    })
    .catch(() => cached || Response.error());
  return cached || network;
}
