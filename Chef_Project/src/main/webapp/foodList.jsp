<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dto.Food" %>
<%@ page import="dao.FoodRepository" %>

<jsp:useBean id="foodDAO" class="dao.FoodRepository" scope="session" />
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />

<title>식재료 마트 목록</title>
</head>
<body>
   <div class="container py-4">
      <%@ include file = "top.jsp" %>
      
      <div class = "p-5 mb-4 bg-body-tertiary rounded-3">
         <div class = "container-fluid py-5">
         <h1 class = "display-5 fw-bold">식재료 목록</h1>
         <p class = "col-md-8 fs-4">FoodList</p>
         </div>
      </div>
      
      <%@ include file="dbconnect.jsp" %>
      <div class = "row align-items-md-stretch text-center">
         <%
            PreparedStatement pstmt=null;
            ResultSet rs=null;
            String sql="SELECT * FROM food";
            pstmt=connect.prepareStatement(sql);
            rs=pstmt.executeQuery();
            while (rs.next()) {
         %>
         
         <div class = "col-md-4">
            <div class = "h-100 p-2">
               <img src="./resources/images/<%=rs.getString("f_filename") %>" style="width: 250; height: 350" />
               <h5><b><%=rs.getString("f_foodname") %></b></h5>
               <br><%=rs.getString("f_place") %> | <%=rs.getString("f_price") %>원
               
               <%
                   String desc = rs.getString("f_description");
                   if (desc != null && desc.length() > 60) {  //상세 설명이 60자를 넘기면, 뒷 부분은 ...으로 표현
                       desc = desc.substring(0, 60) + "...";
                     }
                  %>
               <p> <%=desc%> </p>
               <p> <%=rs.getString("f_price") %>원
               <p> <a href="./foodDetail.jsp?foodname=<%=rs.getString("f_foodname") %>" class="btn btn-secondary" role="button"> 상세 정보 &raquo;></a>
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
      </div>
      <%@ include file = "footer.jsp" %>
   </div>
</body>
</html>