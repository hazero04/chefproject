<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<html>
<head>
<%@ include file="head.jsp" %>
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
	<%@ include file="top.jsp" %>
<main class="g-app">

	<div class="g-page-head">
		<div>
			<h1>식재료 수정</h1>
			<p>FoodEditing · 수정할 식재료를 선택하세요</p>
		</div>
	</div>
	<%@ include file="dbconnect.jsp" %>
	<div class="row g-3">
	<%
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="SELECT * FROM food";
		pstmt=connect.prepareStatement(sql); 
		rs=pstmt.executeQuery();
		while (rs.next()) {
	%>
	<div class="col-6 col-md-4 col-lg-3">
		<div class="g-card">
			<div class="g-card-img">
				<img src="./resources/images/<%=rs.getString("f_fileName")%>" alt="<%=rs.getString("f_foodname") %>" />
			</div>
			<p class="g-card-title"><%=rs.getString("f_foodname") %></p>
			<div class="g-card-sub"><%=rs.getString("f_place") %> | <%=rs.getString("f_price") %>원</div>
			<%
    			// 상세 설명 가져오기
    			String editDesc = rs.getString("f_description");
   			   // 60자보다 길 때만 그 뒷부분에 ...을 붙임
    			if (editDesc != null && editDesc.length() > 60) {
        			editDesc = editDesc.substring(0, 60) + "...";
    			}
			%>
			<p class="g-card-desc"><%=editDesc%></p>

			<div class="g-card-foot">
				<span class="g-price"><%=rs.getString("f_price") %>원</span>
			<%
				if ("change".equals(edit)) {
				%>
				<a href="./changeFood.jsp?id=<%=java.net.URLEncoder.encode(rs.getString("f_foodname"), "UTF-8") %>" class="g-add" role="button" aria-label="수정"><i class="bi bi-pencil"></i></a>
			<%
				} else if ("delete".equals(edit)) {
			%>
				<a href="#" onclick="deleteConfirm('<%=rs.getString("f_id")%>')" class="g-add danger" role="button" aria-label="삭제"><i class="bi bi-trash3"></i></a>
			<%
				}
			%>
			</div>
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
</main>
</body>
</html>
