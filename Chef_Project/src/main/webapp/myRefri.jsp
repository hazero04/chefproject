<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <%@ include file="head.jsp" %>
    <title>나의 냉장고</title>
</head>
<body>
    <%@ include file="top.jsp" %>
<main class="g-app">

    <div class="g-page-head">
        <div>
            <h1>나의 냉장고</h1>
            <p>My Refrigerator · 구매한 식재료와 유통기한을 확인하세요</p>
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
                <div class="g-alert" role="alert">
                    <h4><i class="bi bi-exclamation-triangle-fill"></i> 경고 : 유통기한 임박 식재료 알림!</h4>
                    <div class="g-alert-items">
    <%
                while (rsWarn.next()) {
                    String warnFoodName = rsWarn.getString("f_foodname");
                    int dDay = rsWarn.getInt("d_day");
    %>
                        <span class="g-alert-item"><%= warnFoodName %><em>D-<%= dDay %></em></span>
    <%
                }
    %>
                    </div>
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

    <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-3">
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
                <div class="col-12 w-100">
                    <div class="g-empty">
                        <div class="g-empty-ico">🧊</div>
                        <b>냉장고가 텅~ 비어 있습니다!</b>
                        장바구니에 맛있는 재료를 담아 채워보세요~~ 🛒
                        <div class="mt-4"><a href="./foodList.jsp" class="g-btn sm">식재료 마트 가기</a></div>
                    </div>
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
                <div class="g-card">
                    <div class="g-card-img" style="aspect-ratio: 16 / 10;">
                        <img src="<%= imagePath %>" alt="<%= foodName %>" onerror="this.src='https://placehold.co/300x220/F2F3F2/7C7C7C?text=No+Image';">
                    </div>

                    <div class="d-flex justify-content-between align-items-start gap-2">
                        <p class="g-card-title fs-5"><%= foodName %></p>
                        <span class="g-chip green flex-shrink-0">현재 수량: <%= count %>개</span>
                    </div>

                    <p class="g-card-desc">
                        <%= (description != null && !description.trim().isEmpty()) ? description : "등록된 상세 설명이 없습니다." %>
                    </p>

                    <div class="mb-3">
                        <div class="g-info-row py-2 fs-6">유통기한 <span><%= rDate %></span></div>
                        <div class="g-info-row py-2 fs-6">구매처 <span><%= (place != null && !place.trim().isEmpty()) ? place : "미지정" %></span></div>
                    </div>

                    <div class="g-card-foot">
                        <span class="g-price"><%= price %>원</span>
                        <a href="deleteRefri.jsp?foodname=<%= java.net.URLEncoder.encode(foodName, "UTF-8") %>"
                           class="g-add danger" aria-label="삭제"
                           onclick="return confirm('<%= foodName %> 항목을 냉장고에서 삭제하시겠습니까?');">
                           <i class="bi bi-trash3"></i>
                        </a>
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
    <jsp:include page="footer.jsp" />
</main>

</body>
</html>
