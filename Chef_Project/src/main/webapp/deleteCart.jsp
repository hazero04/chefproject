<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dto.Food" %>

<%
    //장바구니 화면에서 넘어온 삭제할 식재료 받기
    String id = request.getParameter("id");
    
    //만약 식재료 이름이 안 넘어왔다면 식재료 목록 페이지로 돌려보냄
    if (id == null || id.trim().equals("")) {
        response.sendRedirect("foodList.jsp");
        return;
    }

    //세션에서 현재 사용자의 장바구니 목록을 꺼내옴
    ArrayList<Food> FoodCartList = (ArrayList<Food>) session.getAttribute("FoodCartList");
    
    //장바구니가 비어있지 않다면 삭제 프로세스를 진행
    if (FoodCartList != null) {
        //사용자가 삭제요청한 식재료 찾기
        for (int i = 0; i < FoodCartList.size(); i++) {
            Food food = FoodCartList.get(i);
            
            //장바구니에 담긴 식재료 이름과 사용자가 클릭한 식재료 이름이 일치하면
            if (food.getFoodname().equals(id)) {
               FoodCartList.remove(i); //장바구니에서 식재료 삭제
                break;
            }
        }
    }

    //삭제 처리가 끝난 후 다시 새로고침된 장바구니 목록 화면으로 돌려보냄
    response.sendRedirect("shippingCart.jsp");
%>