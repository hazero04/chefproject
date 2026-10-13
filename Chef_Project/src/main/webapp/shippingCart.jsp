<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dto.Food" %>
<%@ page import="dao.FoodRepository" %>
<html>
<head>
<%@ include file="head.jsp" %>
<%
    String FoodCartId = session.getId();
%>
<title>장바구니</title>
</head>
<body>
    <%@ include file="top.jsp" %>
<main class="g-app">

    <div class="g-page-head">
        <div>
            <h1>장바구니</h1>
            <p>FoodCart · 주문할 식재료를 선택하세요</p>
        </div>
    </div>

   <form action="./deliveryIN.jsp" method="post">
      <input type="hidden" name="FoodCartId" value="<%=FoodCartId%>" />

      <div class="row g-4">
          <div class="col-lg-8">
              <%
                  int sum = 0;
                  ArrayList<Food> FoodCartList = (ArrayList<Food>) session.getAttribute("FoodCartList");
                  if (FoodCartList == null) {
                     FoodCartList = new ArrayList<Food>();
                  }

                  if (FoodCartList.size() == 0) {
              %>
              <div class="g-empty">
                  <div class="g-empty-ico">🧺</div>
                  <b>장바구니가 비어 있어요</b>
                  식재료 마트에서 맛있는 재료를 담아보세요!
              </div>
              <%
                  }

                  for (int i = 0; i < FoodCartList.size(); i++) { //상품리스트 하나씩 출력
                      Food food = FoodCartList.get(i);
                      int total = food.getPrice() * food.getQuantity();
                      sum = sum + total;
              %>
              <div class="g-cart-row">
                  <!-- 장바구니 속 체크박스 -->
                  <input type="checkbox" class="g-check" name="checkedBox" value="<%=food.getFoodname()%>" checked aria-label="<%=food.getFoodname()%> 선택" />

                  <div class="g-cart-thumb">
                      <img src="./resources/images/<%=food.getFilename()%>" alt="<%=food.getFoodname()%>" onerror="this.style.display='none'">
                  </div>

                  <div class="g-cart-info">
                      <b><%=food.getFoodname()%></b>
                      <small><%=food.getPrice()%>원 · 유통기한 <span class="text-nowrap"><%=food.getDate()%></span></small>
                      <div class="g-qty"><span><%=food.getQuantity()%>개</span></div>
                  </div>

                  <div class="g-cart-right">
                      <a href="./deleteCart.jsp?id=<%=java.net.URLEncoder.encode(food.getFoodname(), "UTF-8")%>" class="g-x" aria-label="삭제"><i class="bi bi-x-lg"></i></a>
                      <span class="g-price"><%=total%>원</span>
                  </div>
              </div>
              <%
                  }
              %>
              <a href="./foodList.jsp" class="g-btn ghost sm mt-4"><i class="bi bi-chevron-left"></i> 쇼핑 계속하기</a>
          </div>

          <div class="col-lg-4">
              <div class="g-summary">
                  <div class="g-summary-row"><span>담은 식재료</span><span><%=FoodCartList.size()%>종류</span></div>
                  <div class="g-summary-row"><span>배송비</span><span>무료</span></div>
                  <div class="g-summary-row total"><span>총금액</span><span><%=sum%>원</span></div>
                  <button type="submit" class="g-btn block mt-3">주문하기 <span class="g-btn-tag"><%=sum%>원</span></button>
              </div>
          </div>
      </div>
    </form>
    <jsp:include page="footer.jsp" />
</main>
</body>
</html>
