<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dto.Food" %>
<%@ page import="dao.FoodRepository" %>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
<%
    String FoodCartId = session.getId();
%>
<title>장바구니</title>
</head>
<body>
<div class="container py-4">
    <%@ include file="top.jsp" %>

    <div class="p-5 mb-4 bg-body-tertiary rounded-3">
        <div class="container-fluid py-5">
            <h1 class="display-5 fw-bold">장바구니</h1>
            <p class="col-md-8 fs-4">FoodCart</p>
        </div>
    </div>

   <form action="./deliveryIN.jsp" method="post">
      <input type="hidden" name="FoodCartId" value="<%=FoodCartId%>" />
   
       <div class="row align-items-md-stretch">
           <div class="row">
               <table width="100%">
                   <tr>
                       <td align="right">
                           <button type="submit" class="btn btn-success">주문하기</a>
                       </td>
                   </tr>
               </table>
           </div>

           <div style="padding-top: 50px">
               <table class="table table-hover">
                   <tr>
                       <th>선택</th>
                       <th>식재료명</th>
                       <th>가격</th>
                       <th>유통기한</th>
                       <th>수량</th>
                       <th>합계</th>
                       <th>비고</th>
                   </tr>
                   <%
                       int sum = 0;
                       ArrayList<Food> FoodCartList = (ArrayList<Food>) session.getAttribute("FoodCartList");
                       if (FoodCartList == null) {
                          FoodCartList = new ArrayList<Food>();
                       }

                       for (int i = 0; i < FoodCartList.size(); i++) { //상품리스트 하나씩 출력
                           Food food = FoodCartList.get(i);
                           int total = food.getPrice() * food.getQuantity();
                           sum = sum + total;
                   %>
                   <tr>
                      <!-- 장바구니 속 체크박스 -->
                      <td>
                           <input type="checkbox" name="checkedBox" value="<%=food.getFoodname()%>" checked />
                       </td>
                    
                       <td><%=food.getFoodname()%></td>
                       <td><%=food.getPrice()%>원</td>
                       <td><%=food.getDate()%></td>
                       <td><%=food.getQuantity()%>개</td>
                       <td><%=total%>원</td>
                       <td>
                           <a href="./deleteCart.jsp?id=<%=food.getFoodname()%>" class="badge text-bg-danger">삭제</a>
                       </td>
                   </tr>
                   <%
                       }
                   %>
                   <tr>
                       <th></th>
                       <th></th>
                       <th></th> <th>총금액</th>
                       <th><%=sum%>원</th>
                       <th></th>
                       <th></th>
                   </tr>
               </table>
               <a href="./foodList.jsp" class="btn btn-secondary"> &laquo; 쇼핑 계속하기</a>
           </div>
       </div>
    </form> <jsp:include page="footer.jsp" />
</div>
</body>
</html>
