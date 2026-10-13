<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
<%@ include file="head.jsp" %>
<script type="text/javascript" src="./resources/js/validation.js"></script>
<title>식재료 추가</title>
</head>
<body>
<fmt:setLocale value='<%=request.getParameter("language") %>' />
<fmt:bundle basename="bundle.message">
	<%@include file="top.jsp" %>
<main class="g-app">

	<div class="g-page-head">
		<div>
			<h1><fmt:message key="title" /></h1>
			<p>Ingredient Addition</p>
		</div>
		<div class="d-flex align-items-center gap-3 g-lang">
			<span><a href="?language=ko">Korean</a> | <a href="?language=en">English</a></span>
			<a href="logout.jsp" class="g-btn outline sm"><i class="bi bi-box-arrow-right"></i> logout</a>
		</div>
	</div>

	<form name="newFood" action="./processAddFood.jsp" class="g-form-card" method="post" enctype="multipart/form-data">
		<div class="g-field">
			<label for="f_foodname"><fmt:message key="f_foodname" /></label>
			<input type="text" id="f_foodname" name="f_foodname" class="form-control">
		</div>
		<div class="g-field">
			<label for="f_description"><fmt:message key="f_description" /></label>
			<input type="text" id="f_description" name="f_description" class="form-control">
		</div>
		<div class="row">
			<div class="col-sm-6 g-field">
				<label for="f_price"><fmt:message key="f_price" /></label>
				<input type="text" id="f_price" name="f_price" class="form-control">
			</div>
			<div class="col-sm-6 g-field">
				<label for="f_date"><fmt:message key="f_date" /></label>
				<input type="text" id="f_date" name="f_date" class="form-control" placeholder="YYYY-MM-DD">
			</div>
		</div>
		<div class="row">
			<div class="col-sm-6 g-field">
				<label for="f_place"><fmt:message key="f_place" /></label>
				<input type="text" id="f_place" name="f_place" class="form-control">
			</div>
			<div class="col-sm-6 g-field">
				<label for="unitsInStock"><fmt:message key="unitsInStock" /></label>
				<input type="text" id="unitsInStock" name="unitsInStock" class="form-control">
			</div>
		</div>
		<div class="g-field">
			<label for="f_filename"><fmt:message key="f_filename" /></label>
			<input type="file" id="f_filename" name="f_filename" class="form-control">
		</div>
		<input type="button" class="g-btn block" value="<fmt:message key="button" />" onclick="CheckAddFood()">
	</form>
	<jsp:include page="footer.jsp" />
</main>
</fmt:bundle>
</body>
</html>
