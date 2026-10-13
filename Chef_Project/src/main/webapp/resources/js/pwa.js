/* PWA : 서비스워커 등록, 앱 설치 버튼, 오프라인 표시 */
(function () {
	if ('serviceWorker' in navigator) {
		window.addEventListener('load', function () {
			navigator.serviceWorker.register('./sw.js', { updateViaCache: 'none' }).catch(function (e) { console.warn('SW 등록 실패', e); });
		});
	}

	// 설치 가능할 때만 [data-pwa-install] 버튼 표시
	var deferredPrompt = null;
	window.addEventListener('beforeinstallprompt', function (e) {
		e.preventDefault();
		deferredPrompt = e;
		document.querySelectorAll('[data-pwa-install]').forEach(function (b) { b.hidden = false; });
	});
	document.addEventListener('click', function (e) {
		var btn = e.target.closest && e.target.closest('[data-pwa-install]');
		if (!btn || !deferredPrompt) return;
		deferredPrompt.prompt();
		deferredPrompt.userChoice.finally(function () {
			deferredPrompt = null;
			document.querySelectorAll('[data-pwa-install]').forEach(function (b) { b.hidden = true; });
		});
	});
	window.addEventListener('appinstalled', function () {
		document.querySelectorAll('[data-pwa-install]').forEach(function (b) { b.hidden = true; });
	});

	// 좁은 화면: 현재 메뉴가 보이도록 메뉴 줄을 가로로 이동
	(function () {
		var nav = document.querySelector('.g-nav'), a = nav && nav.querySelector('a.active');
		if (nav && a && nav.scrollWidth > nav.clientWidth) nav.scrollLeft = a.offsetLeft - (nav.clientWidth - a.offsetWidth) / 2;
	})();

	// 오프라인 안내 바
	function updateOnline() { document.documentElement.classList.toggle('g-offline', !navigator.onLine); }
	window.addEventListener('online', updateOnline);
	window.addEventListener('offline', updateOnline);
	updateOnline();
})();
