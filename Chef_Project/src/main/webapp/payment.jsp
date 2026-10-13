<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="dto.Food" %>
<%@ page import="dao.FoodRepository" %>

<%
   request.setCharacterEncoding("UTF-8");

    String cartId = session.getId();

    String shipping_cartId = "";
    String shipping_name = "";
    String shipping_shippingDate = "";
    String shipping_country = "";
    String shipping_zipCode = "";
    String shipping_addressName = "";

    Cookie[] cookies = request.getCookies();

    if (cookies != null) {
        for (int i = 0; i < cookies.length; i++) {
            Cookie thisCookie = cookies[i];
            String n = thisCookie.getName();
            
            if (n.equals("Shipping_cartId"))
                shipping_cartId = URLDecoder.decode(thisCookie.getValue(), "UTF-8");
            if (n.equals("Shipping_name"))
                shipping_name = URLDecoder.decode(thisCookie.getValue(), "UTF-8");
            if (n.equals("Shipping_shippingDate"))
                shipping_shippingDate = URLDecoder.decode(thisCookie.getValue(), "UTF-8");
            if (n.equals("Shipping_country"))
                shipping_country = URLDecoder.decode(thisCookie.getValue(), "UTF-8");
            if (n.equals("Shipping_zipCode"))
                shipping_zipCode = URLDecoder.decode(thisCookie.getValue(), "UTF-8");
            if (n.equals("Shipping_addressName"))
                shipping_addressName = URLDecoder.decode(thisCookie.getValue(), "UTF-8");
        }
    }
%>

<html>
<head>
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>주문 정보</title>
</head>
<body>
    <div class="container py-4">
        <%@ include file="top.jsp" %>

        <div class="p-5 mb-4 bg-body-tertiary rounded-3">
            <div class="container-fluid py-5">
                <h1 class="display-5 fw-bold">주문 정보</h1>
                <p class="col-md-8 fs-4">Order Info</p>
            </div>
        </div>

        <div class="row align-items-md-stretch alert alert-success">
            <div class="text-center">
               <h1>영수증</h1>
            </div>
            <div class="row justify-content-between">
               <div class="col-4" align="left">
                   <strong>배송 주소</strong><br>
                    성명 : <%out.println(shipping_name); %><br>
                    우편번호 : <%out.println(shipping_zipCode); %><br>
                    주소 : <%out.println(shipping_addressName); %>(<%out.println(shipping_country); %>)<br>
                </div>
                <div class="col-4" align="right">
                    <p><em>배송일: <%out.println(shipping_shippingDate); %></em>
                </div>
            </div>
            <div class="py-5">
                <table class="table table-hover">
                   <tr>
                        <th class="text-center">식재료명</th>
                        <th class="text-center">가격</th>
                        <th class="text-center">수량</th>
                        <th class="text-center">합계</th>
                    </tr>
               <%
                       int sum = 0;
                  //세션에서 전체장바구니 FoodCartList 가져오기
                        ArrayList<Food> FoodCartList = (ArrayList<Food>) session.getAttribute("CheckoutList");
                        if (FoodCartList == null) 
                           FoodCartList = new ArrayList<Food>();
                        for (int i = 0; i < FoodCartList.size(); i++) {
                           Food food = FoodCartList.get(i);
                            int total = food.getPrice() * food.getQuantity();
                            sum = sum + total;
                    %>
                    <tr>
                        <td class="text-center"><em><%=food.getFoodname()%> </em></td>
                        <td class="text-center"><%=food.getPrice()%>원</td>
                        <td class="text-center"><%=food.getQuantity()%>개</td>
                        <td class="text-center"><%=total%>원</td>
                    </tr>
                    <%
                        }
                    %>
                    <tr>
                        <td></td>
                        <td></td>
                        <td class="text-right"><strong>총 금액: </strong></td>
                        <td class="text-center text-danger"><strong><%=sum %>원 </strong></td>
                    </tr>
                </table>
               
            <a href="./shippingCart.jsp?cartId=<%=shipping_cartId%>" class="btn btn-secondary" role="button"> 이전 </a>
            <a href="./thankCust.jsp" class="btn btn-success" role="button"> 주문 완료 </a>
            </div>
        </div>
    </div>
</body>
</html>