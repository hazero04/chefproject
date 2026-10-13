<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
<%@ include file="head.jsp" %>
<title>Login</title>
</head>
<body>
	<%@ include file="top.jsp" %>
<main class="g-app">

	<div class="g-auth">
		<div class="g-brand-logo">🥕</div>
		<h1>로그인</h1>
		<p class="lead">Login · 관리자 아이디와 비밀번호를 입력하세요</p>
		<%
			String error=request.getParameter("error");
			if(error!=null) {
				out.println("<div class='g-alert py-3'>");
				out.println("<i class='bi bi-exclamation-circle-fill text-danger me-1'></i> 아이디와 비밀번호를 확인해 주세요");
				out.println("</div>");
			}
		%>
		<form class="form-signin" action="j_security_check" method="post">
			<div class="g-field">
				<label for="floatingInput">ID</label>
				<input type="text" class="form-control" id="floatingInput" name="j_username" placeholder="ID" required autofocus>
			</div>
			<div class="g-field">
				<label for="floatingPassword">Password</label>
				<input type="password" class="form-control" id="floatingPassword" name="j_password" placeholder="Password" required>
			</div>
			<button class="g-btn block mt-2" type="submit">로그인</button>
		</form>
	</div>
	<%@ include file="footer.jsp" %>
</main>
</body>
</html>
