<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
<link rel = "stylesheet" href="./resources/css/bootstrap.min.css" />
<script type="text/javascript" src="./resources/js/validation.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
<title>식재료 추가</title>
</head>
<body>
<fmt:setLocale value='<%=request.getParameter("language") %>' />
<fmt:bundle basename="bundle.message">
<div class="container py-4">
	<%@include file="top.jsp" %>
	
	<div class="p-5 mb-4 bg-body-tertiary rounded-3">
		<div class="container-fluid py-5">
			<h1 class="display-5 fw bold"><fmt:message key="title" /></h1>
			<p class="col-md-8 fs-4">Ingredient Addition</p>
		</div>
	</div>
	
	<div class="row align-items-md-stretch">
		<div class="text-end">
			<a href="?language=ko">Korean</a>| <a href="?language=en">English</a>
			<a href="logout.jsp" class="btn btn-sm btn-success pull right">logout</a>
		</div>
		<form name="newFood" action="./processAddFood.jsp" class="form-horizontal" method="post" enctype="multipart/form-data">
				<div class="mb-3 row">
					<label class="col-sm-2"><fmt:message key="f_foodname" /></label>
					<div class="col-sm-3">
						<input type="text" id = "f_foodname" name="f_foodname" class="form-control">
						</div>
					</div>
					<div class="mb-3 row">
						<label class="col-sm-2"><fmt:message key="f_description" /></label>
						<div class="col-sm-3">
							<input type="text" id="f_description" name="f_description" class="form-control">
						</div>
					</div>
					<div class="mb-3 row">
						<label class="col-sm-2"><fmt:message key="f_price" /></label>
						<div class="col-sm-3">
							<input type="text" id="f_price" name="f_price" class="form-control">
						</div>
				    </div>
				    <div class="mb-3 row">
				    	<label class="col-sm-2"><fmt:message key="f_date" /></label>
				    	<div class="Col-sm-3">
				    		<input type="text" id="f_date" name="f_date" class="form-control" placeholder="YYYY-MM-DD">
				    	</div>
				    </div>
				    <div class="mb-3 row">
				    	<label class="col-sm-2"><fmt:message key="f_place" /></label>
				    	<div class="col-sm-3">
				    		<input type="text" id="f_place" name="f_place" class="form-control">
				    	</div>
				    </div>
				    
				    <div class="mb-3 row">
				    	<div class="mb-3 row">
				    		<label class="col-sm-2"><fmt:message key="unitsInStock" /></label>
				    		<div class="col-sm-3">
				    			<input type="text" id = "unitsInStock" name="unitsInStock" class="form-control">
				    		</div>
				    	</div>
				    	<div class="mb-3 row">
				    		<label class="col-sm-2"><fmt:message key="f_filename" /></label>
				    		<div class="col-sm-5">
				    			<input type="file" id = "f_filename" name="f_filename" class="form-control">
				    			</div>
				    		</div>
				    		<div class="col-sm-offset-2 col-sm-10">
				    			<input type="button" class="btn btn-primary" value="<fmt:message key="button" />" onclick = "CheckAddFood()">
				    		</div>
				    	</div>
				    </form>
				   </div>
				   <jsp:include page="footer.jsp" />
				</div>
				</fmt:bundle>
				</body>
				</html>