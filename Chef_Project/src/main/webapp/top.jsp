<%@ page contentType="text/html; charset=utf-8" %>
<%
	// 현재 페이지 이름으로 메뉴 활성화 표시
	String _navUri = request.getRequestURI();
	String _navPage = _navUri.substring(_navUri.lastIndexOf('/') + 1);
	if (_navPage.isEmpty()) _navPage = "mainhome.jsp";

	// 장바구니에 담긴 식재료 개수 (배지 표시용)
	java.util.List<?> _navCartList = (java.util.List<?>) session.getAttribute("FoodCartList");
	int _navCartCount = (_navCartList == null) ? 0 : _navCartList.size();
%>
<header class="g-topbar">
	<div class="g-topbar-inner">
		<a href="./mainhome.jsp" class="g-brand">
			<span class="g-brand-logo"><img src="./resources/icons/logo.png" alt="방구석 셰프 로고"></span>
			<span>
				<span class="g-brand-name d-block">방구석 셰프</span>
				<span class="g-brand-sub"><i class="bi bi-geo-alt-fill"></i> Chef's Refrigerator</span>
			</span>
		</a>

		<!-- 데스크톱 메뉴 -->
		<nav class="g-nav d-none d-lg-flex">
			<a href="./mainhome.jsp" class="<%= _navPage.equals("mainhome.jsp") ? "active" : "" %>">홈</a>
			<a href="./foodList.jsp" class="<%= _navPage.equals("foodList.jsp") || _navPage.equals("foodDetail.jsp") ? "active" : "" %>">식재료 마트</a>
			<a href="./checkbox.jsp" class="<%= _navPage.equals("checkbox.jsp") ? "active" : "" %>">레시피 추천</a>
			<a href="./myRefri.jsp" class="<%= _navPage.equals("myRefri.jsp") ? "active" : "" %>">나의 냉장고</a>
			<a href="./addFood.jsp" class="<%= _navPage.equals("addFood.jsp") ? "active" : "" %>">식재료 등록</a>
			<a href="./editFood.jsp?edit=change" class="<%= _navPage.equals("editFood.jsp") || _navPage.equals("changeFood.jsp") ? "active" : "" %>">식재료 수정</a>
		</nav>

		<div class="d-flex gap-2 ms-auto ms-lg-0">
			<!-- PWA: 설치 가능할 때만 표시 -->
			<button type="button" class="g-icon-btn g-install" data-pwa-install hidden aria-label="앱 설치" title="앱 설치">
				<i class="bi bi-download"></i>
			</button>
			<!-- 모바일: 관리자 메뉴 -->
			<div class="dropdown d-lg-none">
				<button class="g-icon-btn" type="button" data-bs-toggle="dropdown" aria-expanded="false" aria-label="관리 메뉴">
					<i class="bi bi-sliders"></i>
				</button>
				<ul class="dropdown-menu dropdown-menu-end shadow border-0 rounded-4 p-2">
					<li><a class="dropdown-item rounded-3 py-2" href="./addFood.jsp"><i class="bi bi-plus-circle me-2 text-success"></i>식재료 등록</a></li>
					<li><a class="dropdown-item rounded-3 py-2" href="./editFood.jsp?edit=change"><i class="bi bi-pencil-square me-2 text-success"></i>식재료 수정</a></li>
				</ul>
			</div>
			<a href="./shippingCart.jsp" class="g-icon-btn" aria-label="장바구니">
				<i class="bi bi-cart3"></i>
				<% if (_navCartCount > 0) { %><span class="g-badge"><%= _navCartCount %></span><% } %>
			</a>
		</div>
	</div>
</header>

<!-- 모바일 하단 탭바 -->
<nav class="g-tabbar d-lg-none">
	<a href="./mainhome.jsp" class="<%= _navPage.equals("mainhome.jsp") ? "active" : "" %>"><i class="bi bi-shop"></i>홈</a>
	<a href="./foodList.jsp" class="<%= _navPage.equals("foodList.jsp") || _navPage.equals("foodDetail.jsp") ? "active" : "" %>"><i class="bi bi-search"></i>마트</a>
	<a href="./checkbox.jsp" class="<%= _navPage.equals("checkbox.jsp") ? "active" : "" %>"><i class="bi bi-egg-fried"></i>레시피</a>
	<a href="./myRefri.jsp" class="<%= _navPage.equals("myRefri.jsp") ? "active" : "" %>"><i class="bi bi-snow2"></i>냉장고</a>
	<a href="./shippingCart.jsp" class="<%= _navPage.equals("shippingCart.jsp") ? "active" : "" %>"><i class="bi bi-cart3"><% if (_navCartCount > 0) { %><span class="g-badge"><%= _navCartCount %></span><% } %></i>장바구니</a>
</nav>
