<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <%@ include file="head.jsp" %>
    <title>식재료 수정</title>
</head>
<body>
	<%@ include file="top.jsp" %>
<main class="g-app">

	<div class="g-page-head">
		<div class="d-flex align-items-center">
			<a href="./editFood.jsp?edit=change" class="g-back" aria-label="목록으로"><i class="bi bi-chevron-left"></i></a>
			<div>
				<h1>식재료 수정</h1>
				<p>Food Change</p>
			</div>
		</div>
	</div>
	<%@ include file="dbconnect.jsp" %>
	<%
		String f_foodname=request.getParameter("id");
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="SELECT * FROM food WHERE f_foodname=?";
		pstmt=connect.prepareStatement(sql);
		pstmt.setString(1, f_foodname);
		rs=pstmt.executeQuery();
		if (rs.next()) {
	%>
	<div class="row g-4">
		<div class="col-lg-5">
			<div class="g-detail-img">
				<img src="./resources/images/<%=rs.getString("f_filename")%>" alt="image" />
			</div>
		</div>
		<div class="col-lg-7">
			<form name="newFood" action="./processchangeFood.jsp" method="post" enctype="multipart/form-data" class="g-form-card">

			<input type="hidden" name="old_foodname" value="<%=rs.getString("f_foodname")%>">

				<div class="g-field">
					<label for="f_foodname">식재료명</label>
					<input type="text" name="f_foodname" id="f_foodname" class="form-control" value='<%=rs.getString("f_foodname")%>'>
				</div>
				<div class="g-field">
					<label for="f_description">상세 설명</label>
					<textarea name="f_description" id="f_description" cols="50" rows="3" class="form-control" placeholder="10자 이상 적어주세요"><%=rs.getString("f_description")%></textarea>
				</div>
				<div class="row">
					<div class="col-sm-6 g-field">
						<label for="f_price">가격</label>
						<input type="text" name="f_price" id="f_price" class="form-control" value='<%=rs.getString("f_price")%>'>
					</div>
					<div class="col-sm-6 g-field">
						<label>유통기한</label>
						<input type="text" name="f_date" class="form-control" value='<%=rs.getString("f_date")%>'>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6 g-field">
						<label>구입처</label>
						<input type="text" name="f_place" class="form-control" value='<%=rs.getString("f_place")%>'>
					</div>
					<div class="col-sm-6 g-field">
						<label for="unitsInStock">재고 수량</label>
						<input type="text" name="unitsInStock" id="unitsInStock" class="form-control" value='<%=rs.getString("f_unitsInStock")%>'>
					</div>
				</div>
				<div class="g-field">
					<label>이미지 파일</label>
					<input type="file" name="f_filename" class="form-control">
				</div>
				<input type="submit" class="g-btn block" value="수정 완료">
			</form>
		</div>
	</div>
		<%
			}
			if (rs!=null)
				rs.close();
			if (pstmt!=null)
				pstmt.close();
			if (connect!=null)
				connect.close();
		%>
	<jsp:include page="footer.jsp" />
</main>
</body>
</html>
