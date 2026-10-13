<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dto.Food" %>
<%@ page import="dao.FoodRepository" %>

<jsp:useBean id="foodDAO" class="dao.FoodRepository" scope="session" />
<html>
<head>
<%@ include file="head.jsp" %>
<title>식재료 마트 목록</title>
<script type="text/javascript">
   // 상품 카드의 + 버튼 : 바로 장바구니에 담기
   function quickAdd(url) {
      if (confirm("식재료를 장바구니에 추가하시겠습니까?")) {
         location.href = url;
      }
   }
   // 검색창 : 식재료명으로 카드 필터링
   function filterFood(keyword) {
      keyword = keyword.trim();
      document.querySelectorAll("[data-food]").forEach(function (el) {
         el.style.display = el.getAttribute("data-food").indexOf(keyword) > -1 ? "" : "none";
      });
   }
</script>
</head>
<body>
   <%@ include file = "top.jsp" %>
<main class="g-app">

   <div class="g-page-head">
      <div>
         <h1>식재료 목록</h1>
         <p>FoodList · 신선한 식재료를 골라보세요</p>
      </div>
   </div>

   <label class="g-search mb-4">
      <i class="bi bi-search"></i>
      <input type="text" placeholder="식재료 검색" oninput="filterFood(this.value)">
   </label>

   <%@ include file="dbconnect.jsp" %>
   <div class="row g-3">
      <%
         PreparedStatement pstmt=null;
         ResultSet rs=null;
         String sql="SELECT * FROM food";
         pstmt=connect.prepareStatement(sql);
         rs=pstmt.executeQuery();
         while (rs.next()) {
            String encName = java.net.URLEncoder.encode(rs.getString("f_foodname"), "UTF-8");
      %>

      <div class="col-6 col-md-4 col-lg-3" data-food="<%=rs.getString("f_foodname") %>">
         <div class="g-card">
            <a class="g-card-img" href="./foodDetail.jsp?foodname=<%=encName %>">
               <img src="./resources/images/<%=rs.getString("f_filename") %>" alt="<%=rs.getString("f_foodname") %>" />
            </a>
            <p class="g-card-title"><a href="./foodDetail.jsp?foodname=<%=encName %>"><%=rs.getString("f_foodname") %></a></p>
            <div class="g-card-sub"><%=rs.getString("f_place") %> · 유통기한 <%=rs.getString("f_date") %></div>

            <%
                String desc = rs.getString("f_description");
                if (desc != null && desc.length() > 60) {  //상세 설명이 60자를 넘기면, 뒷 부분은 ...으로 표현
                    desc = desc.substring(0, 60) + "...";
                  }
               %>
            <p class="g-card-desc"><%=desc%></p>

            <div class="g-card-foot">
               <span class="g-price"><%=rs.getString("f_price") %>원</span>
               <a href="#" class="g-add" onclick="quickAdd('./addCart.jsp?foodname=<%=encName %>'); return false;" aria-label="장바구니 담기"><i class="bi bi-plus-lg"></i></a>
            </div>
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
</main>
</body>
</html>
