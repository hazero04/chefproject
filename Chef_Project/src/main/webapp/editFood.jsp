<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
<title>재료 수정</title>
<script type="text/javascript">
	function deleteConfirm(id) {
		if (confirm("선택하신 재료를 삭제합니다!!")==true)
			location.href="./deleteFood.jsp?id=" + id;
		else
			return;
	}
</script>
</head>
<%
	String edit=request.getParameter("edit");
%>
<body>
<div class="container py-4">
	<%@ include file="top.jsp" %>
	
	<div class="p-5 mb-4 bg-body-tertiary rounded-3">
		<div class="container-fluid py-5">
		<h1 class="display-5 fw-bold">식재료 수정</h1>
		<p class="col-md-8 fs-4">FoodEditing</p>
		</div>
	</div>
	<%@ include file="dbconnect.jsp" %> <div class="row align-items-md-stretch text-center">
	<%
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="SELECT * FROM food";
		pstmt=connect.prepareStatement(sql); 
		rs=pstmt.executeQuery();
		while (rs.next()) {
	%>
	<div class="col-md-4">
		<div class="h-100 p-2 round-3">
			<img src="./resources/images/<%=rs.getString("f_fileName")%>" style="width: 250px; height: 350px;" />
			<p> <h5><b><%=rs.getString("f_foodname") %></b></h5> 
			<br> <%=rs.getString("f_place") %> | <%=rs.getString("f_price") %>원
			<%
    			// 상세 설명 가져오기
    			String editDesc = rs.getString("f_description");
   			   // 60자보다 길 때만 그 뒷부분에 ...을 붙임
    			if (editDesc != null && editDesc.length() > 60) {
        			editDesc = editDesc.substring(0, 60) + "...";
    			}
			%>
			<p> <%=editDesc%> </p>
			
			<p> <%=rs.getString("f_price") %>원
			<p> <%
				if (edit.equals("change")) {
				%>
			<a href="./changeFood.jsp?id=<%=rs.getString("f_foodname") %>" class="btn btn-success" role="button"> 수정 &raquo;</a>
			<%
				} else if (edit.equals("delete")) {
			%>
			<a href="#" onclick="deleteConfirm('<%=rs.getString("f_id")%>')" class="btn btn-danger" role="button">삭제 &raquo;</a>
			<%
				}
			%>
			</div>
		</div>
		<%
			}
			if (rs!=null) rs.close();
			if (pstmt!=null) pstmt.close();
			if (connect!=null) connect.close();
		%>
	</div>
	<%@ include file="footer.jsp" %>
</div>
</body>
</html>