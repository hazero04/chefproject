<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
    <%@ include file="head.jsp" %>
    <title>배송 정보</title>
</head>
<body>
   <%
      request.setCharacterEncoding("UTF-8");
   
         //장바구니에서 넘어온 체크박스 배열 받기
       String[] checkedBox = request.getParameterValues("checkedBox");
   %>

        <%@ include file="top.jsp" %>
    <main class="g-app">

        <div class="g-page-head">
            <div class="d-flex align-items-center">
                <a href="./shippingCart.jsp" class="g-back" aria-label="장바구니로"><i class="bi bi-chevron-left"></i></a>
                <div>
                    <h1>배송 정보</h1>
                    <p>Shipping Info</p>
                </div>
            </div>
        </div>

        <form action="./processShippingIN.jsp" method="post" class="g-form-card">
           <%
             if (checkedBox != null) {
                 for (String checkedName : checkedBox) {
           %>
               <input type="hidden" name="checkedBox" value="<%= checkedName %>" />
           <%
                 }
             }
           %>

            <div class="g-field">
                <label for="name">성명</label>
                <input type="text" id="name" name="name" class="form-control">
            </div>

            <div class="g-field">
                <label for="shippingDate">배송일</label>
                <input type="text" id="shippingDate" name="shippingDate" class="form-control" placeholder="YYYY/MM/DD">
                <div class="hint">(YYYY/MM/DD)</div>
            </div>

            <div class="row">
                <div class="col-sm-6 g-field">
                    <label for="country">국가명</label>
                    <input type="text" id="country" name="country" class="form-control">
                </div>
                <div class="col-sm-6 g-field">
                    <label for="zipCode">우편번호</label>
                    <input type="text" id="zipCode" name="zipCode" class="form-control">
                </div>
            </div>

            <div class="g-field">
                <label for="addressName">주소</label>
                <input type="text" id="addressName" name="addressName" class="form-control">
            </div>

            <div class="d-flex gap-2 mt-2">
                <a href="./shippingCart.jsp?cartId=<%=request.getParameter("cartId")%>" class="g-btn ghost" role="button"> 이전 </a>
                <input type="submit" class="g-btn flex-grow-1" value="등록" />
            </div>
        </form>
        <jsp:include page="footer.jsp" />
    </main>
</body>
</html>
