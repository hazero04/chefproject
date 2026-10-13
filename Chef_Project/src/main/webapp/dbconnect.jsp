<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%
    Connection connect = null;

    try {
        String url = "jdbc:mysql://localhost:3306/ChefDB";
        String user = "root";
        String password = "root";

        Class.forName("com.mysql.jdbc.Driver");
        connect = DriverManager.getConnection(url, user, password);

    } catch (SQLException ex) {
        out.println("데이터베이스 연결이 실패했습니다.<br>");
        out.println("SQLException: " + ex.getMessage());
    }
%>