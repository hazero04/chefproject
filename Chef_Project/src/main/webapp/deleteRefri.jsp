<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    String foodName = request.getParameter("foodname");

    //냉장고에 식재료가 있을 때에만 삭제하기
    if (foodName != null && !foodName.trim().isEmpty()) {
        PreparedStatement pstmt = null;
        try {
            //냉장고 DB 불러오기
            String sql = "DELETE FROM my_refri WHERE f_foodname = ?";
            pstmt = connect.prepareStatement(sql);
            pstmt.setString(1, foodName);
            
           
            pstmt.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        } 
            if (pstmt != null) pstmt.close();
            if (connect != null) connect.close();
       
    }
    
    //삭제 후 냉장고 화면으로 돌아가기
    response.sendRedirect("myRefri.jsp");
%>