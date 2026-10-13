<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%
   //POST로 넘어온 한글 식재료명이 깨지지 않도록 설정
   request.setCharacterEncoding("UTF-8");
%>
<html>
<head>
   <%@ include file="head.jsp" %>
    <title>체크박스와 레시피추천</title>
</head>
<body>
   <%@ include file="top.jsp" %>
<main class="g-app">
   <section class="g-banner mt-3">
      <div class="g-banner-body">
         <h1>🎉 레시피 추천 🎉</h1>
         <p>사용하고 싶은 식재료를 선택하시면 레시피를 추천해드립니다.</p>
      </div>
      <div class="g-banner-veg" aria-hidden="true">🍳🥘</div>
   </section>
   
   <!-- 식재료 10개 체크박스 -->
   <form action="./checkbox.jsp" method="post">
      <div class="g-section-head">
         <h2>🥬 어떤 식재료를 사용하고 싶은가요?</h2>
         <span class="g-chip green">복수 선택 가능</span>
      </div>
      <div>
         <div class="row g-2">
         
         <%@ include file="dbconnect.jsp" %>
         <%
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try{
               //my_refri 테이블에 있는 식재료 이름 가져오기
               String sql = "SELECT DISTINCT f_foodname FROM my_refri";
               pstmt = connect.prepareStatement(sql);
               rs = pstmt.executeQuery();
               
               //rs바구니에 담긴 식재료 이름을 꺼내면서 체크박스 그리기
               while(rs.next()) {
                  String foodName = rs.getString("f_foodname");
         %>
            <div class="col-6 col-md-3">
               <label class="g-pick">
                  <input type="checkbox" name="selectFood" value="<%= foodName %>" id="<%= foodName %>">
                  <span><%= foodName %></span>
               </label>
            </div>
         <%
               }
            } catch(Exception e) {
               e.printStackTrace();
            }
            
            if (rs!=null)
               rs.close();
            if (pstmt!=null)
               pstmt.close();
         %>
         </div>
         
         <div class="text-center mt-4">
            <button type="submit" class="g-btn px-5">레시피 추천받기 ✨</button>
         </div>
      </div>
   </form>
   
   <!-- 사용자가 버튼 누르면, 체크박스 아래에 추천레시피 2개 생성 -->
   <%
      //사용자가 체크한 식재료 데이터배열 받기
      String[] selectFood = request.getParameterValues("selectFood");
   
      if (selectFood != null && selectFood.length > 0) {
   %>
      <div class="g-section-head mt-5">
         <h2>💡 레시피를 추천해드릴게요!!</h2>
      </div>
      <div class="row g-3">
   <%
         try {
            //사용자가 고른 재료 수만큼 SQL LIKE 쿼리를 동적으로 생성.
            String sql = "SELECT * FROM recipe WHERE ";
            for (int i=0; i<selectFood.length; i++) {
               //FIND_IN_SET()을 사용해서 완전히 일치하는 단어가 있을 때만 찾아줌.
               sql += "FIND_IN_SET(?, r_ingredients) > 0";
               if (i < selectFood.length-1) {
                  sql += " OR ";
               }
            }
            
            //레시피 2개만 추천해주도록 제한.
            sql += " LIMIT 2";
            pstmt = connect.prepareStatement(sql);
            
            //사용자가 고른 식재료 표시
            for (int i=0; i<selectFood.length; i++) {
               pstmt.setString(i + 1, selectFood[i]);
            }
            
            rs = pstmt.executeQuery();
            int count = 0;
            
            while (rs.next()) {
               count++;
   %>
            <div class="col-md-6">
               <div class="g-recipe">
                  <div class="g-recipe-head">
                     <span class="g-chip">추천 요리 <%= count %></span>
                     <h3><%= rs.getString("r_name") %></h3>
                  </div>
                  <div class="g-recipe-body">
                     <p class="mb-3"><b>필요한 재료:</b> <%= rs.getString("r_ingredients") %></p>
                     <h5>🍳 조리 순서</h5>
                     <p class="mb-0"><%= rs.getString("r_manual") %></p>
                  </div>
               </div>
            </div>
   <%
            } //while문 중괄호 닫기
            
            //매칭되는 레시피가 아예 없을 경우
            if (count == 0) {
               out.println("<div class='col-12'><div class='g-empty'><div class='g-empty-ico'>🥕</div><b>추천 레시피가 없어요</b>선택하신 식재료가 포함된 추천 레시피가 없습니다. 다른 재료를 조합해 보세요!</div></div>");
            }
         } catch(Exception e) {
            e.printStackTrace();
         }
   
         if (rs!=null)
            rs.close();
         if (pstmt!=null)
            pstmt.close();
         if (connect!=null)
            connect.close();
   %>
      </div>
   <%
      } //if문 중괄호 닫기
   %>
      
   <!-- 하단 -->   
   <%@ include file = "footer.jsp" %>
</main>
</body>
</html>