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
   <%@ include file="head.jsp" %>
    <title>주문 정보</title>
</head>
<body>
        <%@ include file="top.jsp" %>
    <main class="g-app">

        <div class="g-page-head">
            <div class="d-flex align-items-center">
                <a href="./shippingCart.jsp?cartId=<%=shipping_cartId%>" class="g-back" aria-label="이전"><i class="bi bi-chevron-left"></i></a>
                <div>
                    <h1>주문 정보</h1>
                    <p>Order Info</p>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-lg-8">
                <div class="g-receipt">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h2 class="fs-4 fw-bold m-0"><i class="bi bi-receipt text-success me-1"></i> 영수증</h2>
                        <span class="g-chip green">배송일 <%out.println(shipping_shippingDate); %></span>
                    </div>
                    <table>
                        <thead>
                        <tr>
                            <th>식재료명</th>
                            <th class="text-end">가격</th>
                            <th class="text-center">수량</th>
                            <th class="text-end">합계</th>
                        </tr>
                        </thead>
                        <tbody>
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
                            <td><%=food.getFoodname()%></td>
                            <td class="text-end"><%=food.getPrice()%>원</td>
                            <td class="text-center"><%=food.getQuantity()%>개</td>
                            <td class="text-end"><%=total%>원</td>
                        </tr>
                        <%
                            }
                        %>
                        </tbody>
                        <tfoot>
                        <tr>
                            <td colspan="3">총 금액</td>
                            <td class="text-end text-success"><%=sum %>원</td>
                        </tr>
                        </tfoot>
                    </table>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="g-summary">
                    <h3 class="fs-5 fw-bold mb-2"><i class="bi bi-geo-alt-fill text-success"></i> 배송 주소</h3>
                    <div class="g-summary-row"><span>성명</span><span><%out.println(shipping_name); %></span></div>
                    <div class="g-summary-row"><span>우편번호</span><span><%out.println(shipping_zipCode); %></span></div>
                    <div class="g-summary-row"><span>주소</span><span class="text-end"><%out.println(shipping_addressName); %>(<%out.println(shipping_country); %>)</span></div>
                    <div class="g-summary-row"><span>배송일</span><span><%out.println(shipping_shippingDate); %></span></div>
                    <div class="g-summary-row total"><span>결제 금액</span><span><%=sum %>원</span></div>
                    <a href="./thankCust.jsp" class="g-btn block mt-3" role="button"> 주문 완료 </a>
                    <a href="./shippingCart.jsp?cartId=<%=shipping_cartId%>" class="g-btn ghost block mt-2" role="button"> 이전 </a>
                </div>
            </div>
        </div>
        <jsp:include page="footer.jsp" />
    </main>
</body>
</html>