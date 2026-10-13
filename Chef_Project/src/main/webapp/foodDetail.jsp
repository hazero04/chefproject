<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="dto.Food" %>
<%@ page import="dao.FoodRepository" %>
<%@ page errorPage="errorFoodIN.jsp" %>

<html>
<head>
<%@ include file="head.jsp" %>
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
   <%@ include file="top.jsp" %>

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
<main class="g-app">
   <div class="g-page-head">
      <div class="d-flex align-items-center">
         <a href="./foodList.jsp" class="g-back" aria-label="목록으로"><i class="bi bi-chevron-left"></i></a>
         <div>
            <h1>식재료 정보</h1>
            <p>FoodInfo</p>
         </div>
      </div>
   </div>

   <div class="row g-4 g-lg-5 g-detail">
      <div class="col-lg-6">
         <div class="g-detail-img">
            <img src="./resources/images/<%=food.getFilename() %>" alt="<%=food.getFoodname() %>">
         </div>
      </div>

      <div class="col-lg-6">
         <div class="d-flex justify-content-between align-items-start">
            <div>
               <h1><%=food.getFoodname() %></h1>
               <span class="g-chip green">재고 <%=food.getUnitsInStock() %>개</span>
            </div>
            <span class="g-big-price"><%=food.getPrice() %>원</span>
         </div>

         <div class="mt-4">
            <div class="g-info-row d-block">
               <div class="mb-2">상세 설명</div>
               <span class="d-block lh-lg"><%=food.getDescription() %></span>
            </div>
            <div class="g-info-row">가격 <span><%=food.getPrice() %>원</span></div>
            <div class="g-info-row">유통기한 <span><%=food.getDate() %></span></div>
            <div class="g-info-row">재고수 <span><%=food.getUnitsInStock() %>개</span></div>
         </div>

         <form name="addForm" action="./addCart.jsp?foodname=<%=java.net.URLEncoder.encode(String.valueOf(food.getFoodname()), "UTF-8") %>" method="post" class="mt-4 d-grid gap-2">
            <a href="#" class="g-btn block" onclick="addToCart(); return false;"><i class="bi bi-basket2-fill"></i> 식재료 주문 (장바구니 담기)</a>
            <a href="./foodList.jsp" class="g-btn ghost block">식재료 목록</a>
         </form>
      </div>
   </div>
   <jsp:include page="footer.jsp" />
</main>
</body>
</html>
