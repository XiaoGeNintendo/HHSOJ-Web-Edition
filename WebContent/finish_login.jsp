<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<center>
		<%
			session.setAttribute("username",request.getParameter("username"));
			String type=request.getParameter("type");
			if(type!=null && type.equals("submit")){
				response.sendRedirect("submit.jsp");
				return;
			}
			
			response.sendRedirect("index.jsp");
		%>
	</center>
</body>
</html>