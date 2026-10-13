<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Date" %>
<html>
<head>
	<%@ include file="head.jsp" %>
	<title>방구석 셰프</title>
</head>
<body>
	<%@ include file="top.jsp" %>
	<%!String greeting = "안녕하세요🙌 <br>저는 레시피를 추천해드리는 당신만의 셰프입니다!";
	String tagline = "Welcome to Chef's refrigerator!";%>
	<%
		response.setIntHeader("Refresh", 1);
		Date day = new java.util.Date();
		String am_pm;
		int hour = day.getHours();
		int minute = day.getMinutes();
		int second = day.getSeconds();
		if (hour / 12 == 0) {
			am_pm = "AM";
		} else {
			am_pm = "PM";
			hour = hour - 12;
		}
		String CT = hour + ":" + minute + ":" + second + " " + am_pm;

		// 홈 화면에 보여줄 추천 식재료 (resources/images 에 있는 기본 식재료)
		String[] featured = {"시금치", "당근", "토마토", "양파", "버섯", "계란", "감자", "양배추", "마늘", "콩나물"};
	%>
<main class="g-app">

	<!-- 검색바 -->
	<a href="./foodList.jsp" class="g-search mt-3">
		<i class="bi bi-search"></i>
		<span>식재료 마트에서 찾아보세요</span>
	</a>

	<!-- 메인 배너 -->
	<section class="g-banner mt-3">
		<div class="g-banner-body">
			<h1><%=greeting%></h1>
			<p><%=tagline%> · The refrigerator of Chef</p>
			<div class="g-clock"><i class="bi bi-clock-fill"></i> 현재 접속 시각 <%=CT%></div>
			<div class="g-dots"><span class="on"></span><span></span><span></span></div>
		</div>
		<div class="g-banner-veg" aria-hidden="true">🥬🥕🍅</div>
	</section>

	<!-- 카테고리 -->
	<div class="g-section-head">
		<h2>무엇을 해볼까요?</h2>
	</div>
	<div class="row g-3">
		<div class="col-6 col-md-3">
			<a href="./foodList.jsp" class="g-cat c1"><span class="g-cat-ico">🛒</span><b>식재료 마트</b><small>신선한 재료 둘러보기</small></a>
		</div>
		<div class="col-6 col-md-3">
			<a href="./checkbox.jsp" class="g-cat c2"><span class="g-cat-ico">🍳</span><b>레시피 추천</b><small>재료로 요리 찾기</small></a>
		</div>
		<div class="col-6 col-md-3">
			<a href="./myRefri.jsp" class="g-cat c6"><span class="g-cat-ico">🧊</span><b>나의 냉장고</b><small>유통기한 관리</small></a>
		</div>
		<div class="col-6 col-md-3">
			<a href="./shippingCart.jsp" class="g-cat c4"><span class="g-cat-ico">🧺</span><b>장바구니</b><small>담은 재료 주문하기</small></a>
		</div>
	</div>

	<!-- 추천 식재료 -->
	<div class="g-section-head">
		<h2>오늘의 신선 식재료</h2>
		<a href="./foodList.jsp">전체보기</a>
	</div>
	<div class="g-hscroll">
	<% for (String name : featured) {
		String enc = java.net.URLEncoder.encode(name, "UTF-8"); %>
		<div class="g-card">
			<a class="g-card-img" href="./foodDetail.jsp?foodname=<%=enc%>">
				<img src="./resources/images/<%=name%>.jpg" alt="<%=name%>" onerror="this.src='https://placehold.co/300x300/F2F3F2/7C7C7C?text=Food';">
			</a>
			<p class="g-card-title"><%=name%></p>
			<div class="g-card-sub">신선 식재료</div>
			<div class="g-card-foot">
				<span class="g-chip green">Fresh</span>
				<a class="g-add" href="./foodDetail.jsp?foodname=<%=enc%>" aria-label="<%=name%> 상세 보기"><i class="bi bi-plus-lg"></i></a>
			</div>
		</div>
	<% } %>
	</div>

	<%@ include file="footer.jsp" %>
</main>
</body>
</html>
