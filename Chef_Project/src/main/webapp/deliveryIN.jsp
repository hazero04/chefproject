<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>배송 정보</title>
</head>
<body>
   <%
      request.setCharacterEncoding("UTF-8");
   
         //장바구니에서 넘어온 체크박스 배열 받기
       String[] checkedBox = request.getParameterValues("checkedBox");
   %>

    <div class="container py-4">
        <%@ include file="top.jsp" %>

        <div class="p-5 mb-4 bg-body-tertiary rounded-3">
            <div class="container-fluid py-5">
                <h1 class="display-5 fw-bold">배송 정보</h1>
                <p class="col-md-8 fs-4">Shipping Info</p>
            </div>
        </div>

        <div class="row align-items-md-stretch">
            <form action="./processShippingIN.jsp" method="post">
               <%
                 if (checkedBox != null) {
                     for (String checkedName : checkedBox) {
             %>
                   <input type="hidden" name="checkedBox" value="<%= checkedName %>" />
               <%
                     }
                 }
               %>
               
                <div class="mb-3 row">
                    <label class="col-sm-2">성명</label>
                    <div class="col-sm-3">
                        <input type="text" name="name" class="form-control">
                    </div>
                </div>

                <div class="mb-3 row">
                    <label class="col-sm-2">배송일</label>
                    <div class="col-sm-3">
                        <input type="text" name="shippingDate" class="form-control">(YYYY/MM/DD)
                    </div>
                </div>

                <div class="mb-3 row">
                    <label class="col-sm-2">국가명</label>
                    <div class="col-sm-3">
                        <input type="text" name="country" class="form-control">
                    </div>
                </div>

                <div class="mb-3 row">
                    <label class="col-sm-2">우편번호</label>
                    <div class="col-sm-3">
                        <input type="text" name="zipCode" class="form-control">
                    </div>
                </div>

                <div class="mb-3 row">
                    <label class="col-sm-2">주소</label>
                    <div class="col-sm-5">
                        <input type="text" name="addressName" class="form-control">
                    </div>
                </div>

                <div class="mb-3 row">
                    <div class="col-sm-offset-2 col-sm-10">
                        <a href="./shippingCart.jsp?cartId=<%=request.getParameter("cartId")%>" class="btn btn-secondary" role="button"> 이전 </a>
                        <input type="submit" class="btn btn-primary" value="등록" />
                    </div>
                </div>
            </form>
        </div>
        <jsp:include page="footer.jsp" />
    </div>
</body>
</html>