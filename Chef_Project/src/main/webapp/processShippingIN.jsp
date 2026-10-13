<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dto.Food" %>
<%
    request.setCharacterEncoding("UTF-8");

   String sessionId = session.getId();
   
   String p_name = request.getParameter("name");
    String p_shippingDate = request.getParameter("shippingDate");
    String p_country = request.getParameter("country");
    String p_zipCode = request.getParameter("zipCode");
    String p_addressName = request.getParameter("addressName");

    if (p_name == null) p_name = "";
    if (p_shippingDate == null) p_shippingDate = "";
    if (p_country == null) p_country = "";
    if (p_zipCode == null) p_zipCode = "";
    if (p_addressName == null) p_addressName = "";
    
    
    //----- 장바구니 속 체크박스 -----
    String[] checkedBox = request.getParameterValues("checkedBox");
    
    //세션 속 전체 장바구니 가져오기
   ArrayList<Food> FoodCartList = (ArrayList<Food>) session.getAttribute("FoodCartList");
    
    //선택된 상품들만 따로 담을 새로운 리스트 생성
    ArrayList<Food> checkoutList = new ArrayList<Food>();
    
    //전체 장바구니를 돌면서 사용자가 체크한 상품만 쏙 골라내기
    if (checkedBox != null && FoodCartList != null) {
        for (Food food : FoodCartList) {
            for (String checkedName : checkedBox) {
                // 전체 장바구니 상품명과 체크된 상품명이 일치하면 리스트에 추가
                if (food.getFoodname().equals(checkedName)) {
                    checkoutList.add(food);
                }
            }
        }
    }
    //골라낸 최종 결제상품리스트를 CheckoutList로 세션에 새롭게 보관
    session.setAttribute("CheckoutList", checkoutList);
    

    //안전하게 변환된 값들로 쿠키 생성
    Cookie cartId = new Cookie("Shipping_cartId", URLEncoder.encode(sessionId, "UTF-8"));
    Cookie name = new Cookie("Shipping_name", URLEncoder.encode(p_name, "UTF-8"));
    Cookie shippingDate = new Cookie("Shipping_shippingDate", URLEncoder.encode(p_shippingDate, "UTF-8"));
    Cookie country = new Cookie("Shipping_country", URLEncoder.encode(p_country, "UTF-8"));
    Cookie zipCode = new Cookie("Shipping_zipCode", URLEncoder.encode(p_zipCode, "UTF-8"));
    Cookie addressName = new Cookie("Shipping_addressName", URLEncoder.encode(p_addressName, "UTF-8"));

    //쿠키 유효 기간 설정
    cartId.setMaxAge(24 * 60 * 60);
    name.setMaxAge(24 * 60 * 60);
    shippingDate.setMaxAge(24 * 60 * 60);
    zipCode.setMaxAge(24 * 60 * 60);
    country.setMaxAge(24 * 60 * 60);
    addressName.setMaxAge(24 * 60 * 60);

    //브라우저에 쿠키 추가
    response.addCookie(cartId);
    response.addCookie(name);
    response.addCookie(shippingDate);
    response.addCookie(country);
    response.addCookie(zipCode);
    response.addCookie(addressName);

    //결제 페이지로 이동
    response.sendRedirect("payment.jsp");
%>