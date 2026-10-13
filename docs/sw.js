/* 방구석 셰프 (GitHub Pages) Service Worker
 * 앱 화면과 이미지를 미리 저장해 두어 오프라인에서도 전체 기능이 동작합니다.
 * 파일을 바꾼 뒤에는 VERSION 을 올려 주세요.
 */
const VERSION = 'chef-pages-v3';

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
  event.waitUntil(caches.open(VERSION).then((c) => c.addAll(PRECACHE)).then(() => self.skipWaiting()));
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
  // 화면 이동은 항상 앱 셸(index.html)
  const key = req.mode === 'navigate' ? './index.html' : req;
  event.respondWith(staleWhileRevalidate(req, key));
});

// 저장된 것을 바로 보여주고, 네트워크로 받은 최신 파일은 다음 실행 때 반영
async function staleWhileRevalidate(req, key) {
  const cache = await caches.open(VERSION);
  const cached = await cache.match(key, { ignoreSearch: true });
  const network = fetch(req)
    .then((res) => {
      if (res && (res.ok || res.type === 'opaque')) cache.put(key, res.clone());
      return res;
    })
    .catch(() => cached || Response.error());
  return cached || network;
}
