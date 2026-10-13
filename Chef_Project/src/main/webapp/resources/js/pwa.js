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

	// 오프라인 안내 바
	function updateOnline() { document.documentElement.classList.toggle('g-offline', !navigator.onLine); }
	window.addEventListener('online', updateOnline);
	window.addEventListener('offline', updateOnline);
	updateOnline();
})();
