<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dto.Food" %>
<%@ page import="java.sql.*" %>
<!-- <%@ page import="dao.FoodRepository" %> -->
<%@ include file="dbconnect.jsp" %>

<%
   request.setCharacterEncoding("UTF-8");
    String id = request.getParameter("foodname");
    
    if (id == null || id.trim().equals("")) {
        response.sendRedirect("foodList.jsp");
        return;
    }
   
    //데이터베이스에서 식재료정보 꺼내오기
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    Food goods = null;
    
    try {
        String sql = "SELECT * FROM food WHERE f_foodname = ?";
        pstmt = connect.prepareStatement(sql);
        pstmt.setString(1, id);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
           goods = new Food();
           goods.setFoodname(rs.getString("f_foodname"));
           goods.setDescription(rs.getString("f_description"));
           goods.setPrice(rs.getInt("f_price"));
           goods.setDate(rs.getString("f_date"));
           goods.setUnitsInStock(rs.getInt("f_unitsInStock"));
           goods.setFilename(rs.getString("f_filename"));
       }
   } catch(Exception e) {
        e.printStackTrace();
   }
   
   if (rs!=null)
      rs.close();
   if (pstmt!=null)
      pstmt.close();
       
   //만약 데이터베이스에서 식재료를 못찾았다면 에러페이지로 이동
   if (goods == null) {
        response.sendRedirect("errorFoodIN.jsp");
        return;
    }
    
   //세션에서 장바구니 리스트 꺼내오기
   ArrayList<Food> Foodlist = (ArrayList<Food>) session.getAttribute("FoodCartList");
    if (Foodlist == null) {
        Foodlist = new ArrayList<Food>();
        session.setAttribute("FoodCartList", Foodlist);
    }
   
    //장바구니에 이미 같은 식재료가 있는지 확인
    int count = 0;
    
    for (int i = 0; i < Foodlist.size(); i++) {
        Food goodsQnt = Foodlist.get(i);
        
        if (goodsQnt != null && goodsQnt.getFoodname() != null) {
           if (goodsQnt.getFoodname().equals(id)) {
               count++;
               int orderQuantity = goodsQnt.getQuantity() + 1;
                  goodsQnt.setQuantity(orderQuantity);
               break;
           }
       }
    }
    
    //장바구니에 처음 담기는 재료는 새로 추가
    if (count == 0) {
        goods.setQuantity(1);
        Foodlist.add(goods);
    }
    
    //response.sendRedirect("foodDetail.jsp?foodname=" + java.net.URLEncoder.encode(id, "UTF-8"));
    response.sendRedirect("shippingCart.jsp");
%>