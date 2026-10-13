<%@ page contentType="text/html; charset=utf-8" %>
<%-- 모든 페이지 공통 <head> 리소스 : 그린 테마(Online Groceries 스타일) + PWA --%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#53B175">
<meta name="description" content="식재료 마트, 나의 냉장고, 레시피 추천 - 방구석 셰프">
<%-- PWA : 홈 화면에 추가 --%>
<link rel="manifest" href="./manifest.json">
<link rel="icon" type="image/png" sizes="32x32" href="./resources/icons/favicon-32.png">
<link rel="apple-touch-icon" href="./resources/icons/apple-touch-icon.png">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="default">
<meta name="apple-mobile-web-app-title" content="방구석 셰프">
<%-- 스타일 (오프라인에서도 동작하도록 로컬 파일 사용) --%>
<link href="./resources/css/bootstrap.min.css" rel="stylesheet">
<link href="./resources/vendor/bootstrap-icons/bootstrap-icons.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/variable/pretendardvariable-dynamic-subset.min.css" rel="stylesheet">
<link href="./resources/css/grocery.css" rel="stylesheet">
<script src="./resources/js/bootstrap.bundle.min.js" defer></script>
<script src="./resources/js/pwa.js" defer></script>
