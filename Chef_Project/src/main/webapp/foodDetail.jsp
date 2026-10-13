<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="dto.Food" %>
<%@ page import="dao.FoodRepository" %>
<%@ page errorPage="errorFoodIN.jsp" %>

<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />

<title>식재료마트 정보</title>
<script type="text/javascript">
   function addToCart() {
      if (confirm("식재료를 장바구니에 추가하시겠습니까?")) {
         document.addForm.submit();
      } else {
         document.addForm.reset();
      }
   }
</script>

</head>
<body>
<div class="container py-4">
   <%@ include file="top.jsp" %>
   
   <div class="p-5 mb-4 bg-body-tertiary rounded-3">
      <div class="container-fluid py-5">
         <h1 class="display-5 fw-bold">식재료 정보</h1>
         <p class="col-md-8 fs-4">FoodInfo></p>      
      </div>
   </div>
   
   <!-- 데이터베이스와 연결 -->
   <%@ include file="dbconnect.jsp" %>
   <%
      //식재료 세부정보에도 10개가 뜨기 위해 수정.
      String foodname = request.getParameter("foodname"); 
       PreparedStatement pstmt = null;
       ResultSet rs = null;
       
       //html 출력에서 에러방지를 위해 빈 객체 생성.
       dto.Food food = new dto.Food();
       
       try{
          String sql = "SELECT * FROM food WHERE f_foodname = ?";
            pstmt = connect.prepareStatement(sql);
            pstmt.setString(1, foodname);
            
            rs = pstmt.executeQuery();
            
            //데이터베이스에서 꺼내온 값을 food 객체에 매핑
            if (rs.next()) {
               food.setFoodname(rs.getString("f_foodname"));
               food.setDescription(rs.getString("f_description"));
               food.setPrice(rs.getInt("f_price"));
               food.setDate(rs.getString("f_date"));
               food.setUnitsInStock(rs.getInt("f_unitsInStock"));
               food.setFilename(rs.getString("f_filename"));
           }
       } catch(Exception e) {
            e.printStackTrace();
       }
       
       if (rs!=null)
         rs.close();
      if (pstmt!=null)
         pstmt.close();
   %>
   <div class="row align-items-md-stretch">
      <div class="col-md-5">
         <img src="./resources/images/<%=food.getFilename() %>" style="width: 70%">
      </div>
   
      <div class="col-md-12">
         <h3><b><%=food.getFoodname() %></b></h3>
         <p> <%=food.getDescription() %>
         <p> <b>가격</b> : <%=food.getPrice() %>
         <p> <b>유통기한</b> : <%=food.getDate() %>
         <p> <b>재고수</b> : <%=food.getUnitsInStock() %>
         <h4><%=food.getPrice() %>원</h4>
         <p> <form name="addForm" action="./addCart.jsp?foodname=<%=food.getFoodname() %>" method="post">
            <a href="#" class="btn btn-info" onclick="addToCart()">식재료 주문 &raquo;</a>
            <a href="./foodList.jsp" class="btn btn-secondary">식재료 목록 &raquo;</a>
         </form>
      </div>
   </div>
   <jsp:include page="footer.jsp" />
</div>
</body>
</html>