<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
    <%@ include file="head.jsp" %>
    <title>식재료정보 오류</title>
</head>
<body>
   <%@ include file="top.jsp" %>
<main class="g-app">
   <div class="g-empty">
      <div class="g-empty-ico">🥲</div>
      <b>해당 식재료가 존재하지 않습니다.</b>
      <p class="small text-break mt-2"><%=request.getRequestURL() %>?<%=request.getQueryString() %></p>
      <a href="foodList.jsp" class="g-btn mt-3">식재료마트 목록 &raquo;</a>
   </div>
   <%@ include file="footer.jsp" %>
</main>
</body>
</html>
