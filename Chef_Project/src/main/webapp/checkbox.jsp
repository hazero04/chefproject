<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<html>
<head>
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>체크박스와 레시피추천</title>
</head>
<body>
<div class="container py-4">
   <%@ include file="top.jsp" %>
   <div class="p-5 mb-4 bg-body-tertiary rounded-3">
      <div class="container-fluid py-5">
         <h1 class="display-5 fw-bold text-success">🎉 레시피 추천 🎉</h1>
         <p class="col-md-8 fs-4">사용하고 싶은 식재료를 선택하시면 레시피를 추천해드립니다.</p>
      </div>
   </div>
   
   <!-- 식재료 10개 체크박스 -->
   <form action="./checkbox.jsp" method="post">
      <div class="card p-4 mb-4 shadow-sm">
         <h5 class="mb-4 text-secondary">🥬 어떤 식재료를 사용하고 싶은가요? (복수 선택 가능)</h5>
         <div class="row">
         
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
            <div class="col-md-3 mb-3">
               <div class="form-check fs-5">
                  <input class="form-check-input" type="checkbox" name="selectFood" value="<%= foodName %>" id="<%= foodName %>">
                  <label class="form-check-label" for="<%= foodName %>"><%= foodName %></label>
               </div>
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
         
         <div class="text-center mt-3">
            <button type="submit" class="btn btn-success btn-lg px-5">레시피 추천받기 ✨</button>
         </div>
      </div>
   </form>
   
   <!-- 사용자가 버튼 누르면, 체크박스 아래에 추천레시피 2개 생성 -->
   <%
      //사용자가 체크한 식재료 데이터배열 받기
      String[] selectFood = request.getParameterValues("selectFood");
   
      if (selectFood != null && selectFood.length > 0) {
   %>
      <hr class="my-5">
      <h3 class="mb-4 text-dark">💡 레시피를 추천해드릴게요!! </h3>
      <div class="row">
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
            <div class="col-md-6 mb-4">
               <div class="card h-100 border-success shadow">
                  <div class="card-body p-4">
                     <span class="badge bg-success mb-2">추천 요리 <%= count %></span>
                     <h3 class="card-title text-success"><b><%= rs.getString("r_name") %></b></h3>
                     <p class="card-text text-muted mt-3"><b>필요한 재료:</b> <%= rs.getString("r_ingredients") %></p>
                     
                     <hr>
                     
                     <h5 class="text-dark mt-3"><b>🍳 조리 순서</b></h5>
                     <p class="card-text text-secondary" style="line-height: 1.6;">
                        <%= rs.getString("r_manual") %>
                     </p>
                  </div>
               </div>
            </div>
   <%
            } //while문 중괄호 닫기
            
            //매칭되는 레시피가 아예 없을 경우
            if (count == 0) {
               out.println("<div class='alert alert-light text-center w-100 border py-4'>선택하신 식재료가 포함된 추천 레시피가 없습니다. 다른 재료를 조합해 보세요!</div>");
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
</div>
</body>
</html>