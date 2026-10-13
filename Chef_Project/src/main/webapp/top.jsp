<%@ page contentType="text/html; charset=utf-8" %>
<%
	// 현재 페이지 이름으로 메뉴 활성화 표시
	String _navUri = request.getRequestURI();
	String _navPage = _navUri.substring(_navUri.lastIndexOf('/') + 1);
	if (_navPage.isEmpty()) _navPage = "mainhome.jsp";

	// 장바구니에 담긴 식재료 개수 (배지 표시용)
	java.util.List<?> _navCartList = (java.util.List<?>) session.getAttribute("FoodCartList");
	int _navCartCount = (_navCartList == null) ? 0 : _navCartList.size();

	// 로그인한 관리자 아이디 (web.xml 의 FORM 로그인)
	String _navUser = request.getRemoteUser();
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

		<div class="d-flex gap-2 ms-auto align-items-center">
			<!-- PWA: 설치 가능할 때만 표시 -->
			<button type="button" class="g-icon-btn g-install" data-pwa-install hidden aria-label="앱 설치" title="앱 설치">
				<i class="bi bi-download"></i>
			</button>
			<!-- 로그인 / 로그아웃 (관리자 페이지로 가면 로그인 화면이 열림) -->
			<% if (_navUser == null) { %>
			<a href="./addFood.jsp" class="g-login" title="관리자 로그인"><i class="bi bi-person-circle"></i><span>로그인</span></a>
			<% } else { %>
			<a href="./logout.jsp" class="g-login on" title="<%= _navUser %> 로그아웃"><i class="bi bi-box-arrow-right"></i><span>로그아웃</span></a>
			<% } %>
			<a href="./shippingCart.jsp" class="g-icon-btn" aria-label="장바구니">
				<i class="bi bi-cart3"></i>
				<% if (_navCartCount > 0) { %><span class="g-badge"><%= _navCartCount %></span><% } %>
			</a>
		</div>
	</div>
</header>

<!-- 하단 탭바 (모든 화면 공통) -->
<%
	boolean _navAdmin = _navPage.equals("addFood.jsp") || _navPage.equals("editFood.jsp") || _navPage.equals("changeFood.jsp");
%>
<nav class="g-tabbar" aria-label="메뉴">
	<a href="./mainhome.jsp" class="<%= _navPage.equals("mainhome.jsp") ? "active" : "" %>"><i class="bi bi-shop"></i>홈</a>
	<a href="./foodList.jsp" class="<%= _navPage.equals("foodList.jsp") || _navPage.equals("foodDetail.jsp") ? "active" : "" %>"><i class="bi bi-search"></i>마트</a>
	<a href="./checkbox.jsp" class="<%= _navPage.equals("checkbox.jsp") ? "active" : "" %>"><i class="bi bi-egg-fried"></i>레시피</a>
	<a href="./myRefri.jsp" class="<%= _navPage.equals("myRefri.jsp") ? "active" : "" %>"><i class="bi bi-snow2"></i>냉장고</a>
	<a href="./shippingCart.jsp" class="<%= _navPage.equals("shippingCart.jsp") || _navPage.equals("deliveryIN.jsp") || _navPage.equals("payment.jsp") ? "active" : "" %>"><i class="bi bi-cart3"><% if (_navCartCount > 0) { %><span class="g-badge"><%= _navCartCount %></span><% } %></i>장바구니</a>
	<div class="g-tab-more">
		<button type="button" class="g-tab-btn <%= _navAdmin ? "active" : "" %>" data-tab-more aria-expanded="false" aria-haspopup="true"><i class="bi bi-sliders"></i>관리</button>
		<div class="g-tab-menu" hidden>
			<a href="./addFood.jsp" class="<%= _navPage.equals("addFood.jsp") ? "active" : "" %>"><i class="bi bi-plus-circle"></i>식재료 등록</a>
			<a href="./editFood.jsp?edit=change" class="<%= _navPage.equals("editFood.jsp") || _navPage.equals("changeFood.jsp") ? "active" : "" %>"><i class="bi bi-pencil-square"></i>식재료 수정</a>
		</div>
	</div>
</nav>
