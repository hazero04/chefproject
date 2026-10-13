<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
   request.setCharacterEncoding("UTF-8");
   
   String filename ="";
   String realFolder="C:\\Users\\최하영\\workspace_webServer\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\Chef_Project\\resources\\images";
   int maxSize=5 * 1024 * 1024;   // 최대 업로드 파일 크기 5MB
   String encType="UTF-8";         
   
   MultipartRequest multi = new MultipartRequest(request, realFolder, maxSize, encType, new DefaultFileRenamePolicy());
   
   // 식재료 정보 가져오기
   String f_foodname = multi.getParameter("f_foodname");
   String f_description = multi.getParameter("f_description");
   String f_price = multi.getParameter("f_price");
   String f_date = multi.getParameter("f_date");
   String f_place = multi.getParameter("f_place");
   String unitsInStock = multi.getParameter("unitsInStock");
   
   // 이미지 파일명 가져오기
   Enumeration files = multi.getFileNames();
   String fname = (String) files.nextElement();
   String fileName = multi.getFilesystemName(fname);
   
   // 가격과 재고의 숫자화
   Integer price;
   if (f_price == null || f_price.isEmpty()) {
      price = 0;
   } else { 
      price = Integer.valueOf(f_price);
   }
   
   long stock;
   if (unitsInStock == null || unitsInStock.isEmpty()) {
      stock = 0;
   } else {
      stock = Long.valueOf(unitsInStock);
   }
   
 
   // 냉장고 데이터베이스에 정보 저장
   PreparedStatement pstmt = null;
   String sql = "INSERT INTO my_refri (f_foodname, f_description, f_price, f_date, f_place, f_count, f_filename) VALUES(?,?,?,?,?,?,?)";
   
   pstmt = connect.prepareStatement(sql);
   pstmt.setString(1, f_foodname);   // 식재료명
   pstmt.setString(2, f_description);// 상세 설명
   pstmt.setInt(3, price);           // 가격 
   pstmt.setString(4, f_date);       // 유통기한
   pstmt.setString(5, f_place);      // 구입처
   pstmt.setLong(6, stock);          // 재고 수 
   pstmt.setString(7, fileName);     // 이미지 파일명
   pstmt.executeUpdate();
   
   if (pstmt != null) pstmt.close();
   if (connect != null) connect.close();
   
   //저장 완료 후 나의냉장고 페이지로 이동
   response.sendRedirect("myRefri.jsp");
%>