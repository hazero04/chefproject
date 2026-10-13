<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dto.Food" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>
<html>
<head>
 	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
   <title>주문 완료 및 감사창</title>
</head>
<body>
   <%
      String shipping_cartId="";
      String shipping_shippingDate="";
      
      Cookie[] cookies=request.getCookies();
      if(cookies!=null) {
         for(int i=0; i<cookies.length; i++) {
            Cookie thisCookie=cookies[i];
            String n=thisCookie.getName();
            
            if(n.equals("Shipping_cartId"))
               shipping_cartId=URLDecoder.decode((thisCookie.getValue()), "UTF-8");
            if (n.equals("Shipping_shippingDate"))
                    shipping_shippingDate = URLDecoder.decode(thisCookie.getValue(), "UTF-8");
         }
      }
   %>
   
   <div class="container py-4">
       <%@ include file="top.jsp" %>

        <div class="p-5 mb-4 bg-body-tertiary rounded-3">
            <div class="container-fluid py-5">
                <h1 class="display-5 fw-bold">주문 완료</h1>
                <p class="col-md-8 fs-4">Order Completed</p>
            </div>
        </div>
        
        <div class="row align-items-md-stretch">
           <h2 class="alert alert-danger">🎁주문해주셔서 감사합니다🎁</h2>
                <p> 주문은 <%out.println(shipping_shippingDate); %>에 배송될 예정입니다!
                <p> 주문번호: <%out.println(session.getId()); %> </p>
        </div>
        <div class="container">
            <p> <a href="./foodList.jsp" class="btn btn-secondary"> &laquo; 식재료 목록 </a>
        </div>
        <%@ include file="footer.jsp" %>
    </div>
</body>
</html>
<%
   //결제한 식재료를 나의냉장고에 저장
   ArrayList<Food> checkoutList = (ArrayList<Food>) session.getAttribute("CheckoutList");

   if (checkoutList != null) {
         PreparedStatement pstmt = null;
         String sql = "INSERT INTO my_refri (f_foodname, f_description, f_price, f_date, f_place, f_count, f_filename) VALUES(?,?,?,?,?,?,?)";
       pstmt = connect.prepareStatement(sql);

       for (Food food : checkoutList) {
           pstmt.setString(1, food.getFoodname());     // 식재료명
           pstmt.setString(2, food.getDescription());  // 상세 설명 (DTO 메서드명이 다르면 수정 필요)
           pstmt.setInt(3, food.getPrice());           // 가격
           pstmt.setString(4, food.getDate());          // 유통기한 (해결하신 date)
           pstmt.setString(5, "온라인 배송");           // 구입처
           pstmt.setLong(6, food.getQuantity());       // 수량(재고 수)
           pstmt.setString(7, food.getFilename());     // 이미지 파일명 (DTO 메서드명이 다르면 수정 필요)
           
           pstmt.executeUpdate();
       }
       
       if (pstmt != null)
          pstmt.close();
   }
   
   if (connect != null)
      connect.close(); //DB 연결 닫기

   session.invalidate();

   for(int i=0; i<cookies.length; i++) {
      Cookie thisCookie=cookies[i];
      String n=thisCookie.getName();
      
      if(n.equals("Shipping_cartId"))
         thisCookie.setMaxAge(0);
      if(n.equals("Shipping_name"))
         thisCookie.setMaxAge(0);
      if(n.equals("Shipping_shippingDate"))
         thisCookie.setMaxAge(0);
      if(n.equals("Shipping_country"))
         thisCookie.setMaxAge(0);
      if(n.equals("Shipping_zipCode"))
         thisCookie.setMaxAge(0);
      if(n.equals("Shipping_addressName"))
         thisCookie.setMaxAge(0);
      
      response.addCookie(thisCookie);
   }
%>