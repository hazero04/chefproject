<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");

	String realFolder="C:\\Users\\최하영\\workspace_webServer\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\Chef_Project\\resources\\images";
	String encType="utf-8";	
	int maxSize=5 * 1024 * 1024;	
	
	MultipartRequest multi=new MultipartRequest(request, realFolder, maxSize, encType, new DefaultFileRenamePolicy());
	
	//기존에 입력한 식재료 이름을 불러오기 위함.
	String old_foodname=multi.getParameter("old_foodname"); 
	
	String f_foodname=multi.getParameter("f_foodname");
	String unitPrice=multi.getParameter("f_price");
	String description=multi.getParameter("f_description");
	String releaseDate=multi.getParameter("f_date");
	String place=multi.getParameter("f_place");
	String unitsInStock=multi.getParameter("unitsInStock");
	
	Enumeration files=multi.getFileNames();
	String fname=(String)files.nextElement();
	String fileName=multi.getFilesystemName(fname);
	
	int price;
	if (unitPrice == null || unitPrice.isEmpty())
		price=0;
	else
		price=Integer.valueOf(unitPrice);
	
	long stock;
	if (unitsInStock == null || unitsInStock.isEmpty())
		stock=0;
	else
		stock=Long.valueOf(unitsInStock);
	
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	
	
	String sql="SELECT * FROM food WHERE f_foodname=?";
	pstmt=connect.prepareStatement(sql);
	pstmt.setString(1, old_foodname);
	rs=pstmt.executeQuery();
	
	if (rs.next()) {
		if (fileName!=null) {	//이미지를 바꾸는 경우 
			sql="UPDATE food SET f_foodname=?, f_price=?, f_description=?, f_date=?, f_place=?, f_unitsInStock=?, f_filename=? WHERE f_foodname=?";
			pstmt=connect.prepareStatement(sql);
			pstmt.setString(1, f_foodname);
			pstmt.setInt(2, price);
			pstmt.setString(3, description);
			pstmt.setString(4, releaseDate);
			pstmt.setString(5, place);
			pstmt.setLong(6, stock);
			pstmt.setString(7, fileName);
			pstmt.setString(8, old_foodname); 
			pstmt.executeUpdate();
		} else {  //이미지를 바꾸지 않는 경우  
			sql="UPDATE food SET f_foodname=?, f_price=?, f_description=?, f_date=?, f_place=?, f_unitsInStock=? WHERE f_foodname=?";
			pstmt=connect.prepareStatement(sql);
			pstmt.setString(1, f_foodname);
			pstmt.setInt(2, price);
			pstmt.setString(3, description);
			pstmt.setString(4, releaseDate);
			pstmt.setString(5, place);
			pstmt.setLong(6, stock);
			pstmt.setString(7, old_foodname); 
			pstmt.executeUpdate();
		}
	}
	if (pstmt != null)
		pstmt.close();
	if (connect!=null)
		connect.close();
		
	response.sendRedirect("editFood.jsp?edit=change");
%>