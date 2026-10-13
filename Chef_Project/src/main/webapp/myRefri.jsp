<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <title>나의 냉장고</title>
</head>
<body class="d-flex flex-column min-vh-100">

<div class="container py-4 flex-grow-1">
    <%@ include file="top.jsp" %>
    
    <div class="p-5 mb-4 bg-body-tertiary rounded-3">
        <div class="container-fluid py-5">
            <h1 class="display-5 fw-bold">나의 냉장고</h1>
            <p class="col-md-8 fs-4">My Refrigerator</p>
        </div>
    </div>

    <%@ include file="dbconnect.jsp" %>
    
    <%
        PreparedStatement pstmtWarn = null;
        ResultSet rsWarn = null;
        boolean hasWarning = false;
        
        try {
            // 유통기한이 0일~7일 남은 식재료 조회
            String warnSql = "SELECT f_foodname, DATEDIFF(f_date, CURDATE()) as d_day " +
                             "FROM my_refri " +
                             "WHERE DATEDIFF(f_date, CURDATE()) <= 7 " +
                             "AND DATEDIFF(f_date, CURDATE()) >= 0";
            
            pstmtWarn = connect.prepareStatement(warnSql);
            rsWarn = pstmtWarn.executeQuery();
            
            //유통기한이 임박한 재료 있는지 체크하기
            if (rsWarn.isBeforeFirst()) {
                hasWarning = true;
    %>
                <div class="alert alert-danger my-4 shadow-sm" role="alert">
                    <h4 class="alert-heading fw-bold mb-3">경고 : 유통기한 임박 식재료 알림!</h4>
                    <hr>
    <%
                while (rsWarn.next()) {
                    String warnFoodName = rsWarn.getString("f_foodname");
                    int dDay = rsWarn.getInt("d_day");
    %>
                    <p class="mb-2 fw-bold text-danger">
                        <%= warnFoodName %> <span class="badge bg-danger ms-1">D-<%= dDay %></span>
                    </p>
    <%
                }
    %>
                    <p class="mt-3 mb-0 text-muted" style="font-size: 0.9rem;">빨리 요리해서 냉장고를 비워볼까요? 😋</p>
                </div>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        } 
            if (rsWarn != null) rsWarn.close();
            if (pstmtWarn != null) pstmtWarn.close();
       
    %>

    <div class="row row-cols-1 row-cols-md-3 g-4 mt-2">
    <%
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            //냉장고에 저장된 내용들 불러오기
            String sql = "SELECT f_foodname, f_description, f_price, f_date, f_place, f_count, f_filename FROM my_refri";
            
            pstmt = connect.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            // 데이터가 하나도 없을 때 텅 비어있다는 메시지 출력
            if (!rs.isBeforeFirst()) {
    %>
                <div class="col-12 w-100 d-flex justify-content-center py-5 my-5">
                    <p class="fs-3 fw-bold text-secondary text-center">
                        🧊 냉장고가 텅~ 비어 있습니다! <br>
                        <span class="fs-4 fw-normal mt-2 d-block">장바구니에 맛있는 재료를 담아 채워보세요~~ 🛒</span>
                    </p>
                </div>
    <%
            }
            
            // 재료 데이터 불러오기
            while (rs.next()) {
                String foodName = rs.getString("f_foodname");
                String description = rs.getString("f_description");
                int price = rs.getInt("f_price");
                String rDate = rs.getString("f_date");
                String place = rs.getString("f_place");
                int count = rs.getInt("f_count");
                String fileName = rs.getString("f_filename");
                
            
                String imagePath = request.getContextPath() + "/resources/images/" + fileName;
    %>
           
   
            <div class="col">
                <div class="card h-100 shadow-sm border-secondary-subtle">
                    <img src="<%= imagePath %>" class="card-img-top" alt="<%= foodName %>" style="height: 220px; object-fit: cover;" onerror="this.src='https://placehold.co/300x220?text=No+Image';">
                    
                    <div class="card-body d-flex flex-column">
                        <h4 class="card-title fw-bold text-dark mb-2"><%= foodName %></h4>
                        
                        <p class="card-text text-muted mb-3" style="font-size: 0.95rem; min-height: 48px;">
                            <%= (description != null && !description.trim().isEmpty()) ? description : "등록된 상세 설명이 없습니다." %>
                        </p>
                        
                        <hr class="text-secondary-subtle my-2 mt-auto">
                        
                        <ul class="list-unstyled mb-3" style="font-size: 0.9rem;">
                            <li class="mb-1"><strong>가격:</strong> <%= price %>원</li>
                            <li class="mb-1"><strong>유통기한:</strong><%= rDate %></span></li>
                            <li class="mb-1"><strong>구매처:</strong> <%= (place != null && !place.trim().isEmpty()) ? place : "미지정" %></li>
                        </ul>
                        
                        <div class="d-flex justify-content-between align-items-center mt-2">
                           <span class="badge bg-success fs-6 p-2">현재 수량: <%= count %>개</span>
                            
                            <a href="deleteRefri.jsp?foodname=<%= java.net.URLEncoder.encode(foodName, "UTF-8") %>" 
                               class="btn btn-outline-danger btn-sm fw-bold" 
                               onclick="return confirm('<%= foodName %> 항목을 냉장고에서 삭제하시겠습니까?');">
                               삭제 
                            </a>
            </div>
           </div>
          </div>
         </div>
    <%
            } //반복문 종료
            
        } catch (Exception e) {
            e.printStackTrace();
        } 
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (connect != null) connect.close();
    %>
    </div>
</div> <footer class="mt-auto py-3 bg-light border-top">
    <div class="container text-center">
        <jsp:include page="footer.jsp" />
    </div>
</footer>

</body>
</html>