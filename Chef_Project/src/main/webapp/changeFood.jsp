<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <title>식재료 수정</title>
</head>
<body>
<div class="container py-4">
	<%@ include file="top.jsp" %>
	
	<div class="p-5 mb-4 bg-body-tertiary rounded-3">
		<div class="container-fluid py-5">
			<h1 class="display-5 fw-bold">식재료 수정</h1>
			<p class="col-md-8 fs-4">Food Change</p>
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
	<div class="row align-items-md-stretch">
		<div class="col-md-5">
			<img src="./resources/images/<%=rs.getString("f_filename")%>" alt="image" style="width: 100%" />
		</div>
		<div class="col-md-7">
			<form name="newFood" action="./processchangeFood.jsp" method="post" enctype="multipart/form-data">
			
			<input type="hidden" name="old_foodname" value="<%=rs.getString("f_foodname")%>">
			
			<div class="mb-3 row">
				<label class="col-sm-2">식재료명</label>
				<div class="col-sm-5">
					<input type="text" name="f_foodname" id="f_foodname" class="form-control" value='<%=rs.getString("f_foodname")%>'>
					</div>
				</div>
				<div class="mb-3 row">
					<label class="col-sm-2">상세 설명</label>
					<div class="col-sm-5">
						<textarea name="f_description" id="f_description" cols="50" rows="2" class="form-control" placeholder="10자 이상 적어주세요"><%=rs.getString("f_description")%></textarea>
					</div>
				</div>
				<div class="mb-3 row">
					<label class="col-sm-2">가격</label>
					<div class="col-sm-5">
						<input type="text" name="f_price" id="f_price" class="form-control" value='<%=rs.getString("f_price")%>'>
					</div>
				</div>
				<div class="mb-3 row">
					<label class="col-sm-2">유통기한</label>
					<div class="col-sm-5">
						<input type="text" name="f_date" class="form-control" value='<%=rs.getString("f_date")%>'>
					</div>
				</div>
				<div class="mb-3 row">
					<label class="col-sm-2">구입처</label>
					<div class="col-sm-5">
					<input type="text" name="f_place" class="form-control" value='<%=rs.getString("f_place")%>'>
				</div>
			</div>
			<div class="mb-3 row"> 
				<label class="col-sm-2">재고 수량</label>
				<div class="col-sm-8">
					<input type="text" name="unitsInStock" id="unitsInStock" class="form-control" value='<%=rs.getString("f_unitsInStock")%>'>
				</div>
			</div>
			
				
			<div class="mb-3 row">
				<label class="col-sm-2">이미지 파일</label>
				<div class="col-sm-8">
					<input type="file" name="f_filename" class="form-control">
				</div>
			</div>
			<div class="mb-3 row">
				<div class="col-sm-offset-2 col-sm-10">
					<input type="submit" class="btn btn-primary" value="수정 완료">
				</div>
			</div>
		</form>
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
	</div>
	</body>
	</html>	