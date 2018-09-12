<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<center>
		<h1>You are successfully logged in!</h1>
		
		<i>Welcome back, <%=request.getParameter("username") %>!</i>
		
		<a href="index.jsp"> Back to the main page!</a>
		<%
			session.setAttribute("username",request.getParameter("username"));
		%>
	</center>
</body>
</html>