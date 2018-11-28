<%@page import="com.hhs.xgn.jee.hhsoj.judger.TaskQueue"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>HHSOJ - Admin Platform</title>
</head>
<body>
	<%
	try{
		boolean in=(Boolean)session.getAttribute("admin");
		if(!in){
			return;
		}
	}catch(Exception e){
		out.println("<!-- "+e+" -->");
		return;
	}
		String verdict=request.getParameter("verdict");
		if(verdict!=null){
			TaskQueue.clear(verdict);
			response.sendRedirect("platform.jsp");
			return;
		}
	%>
	
	<h1>Clear Test Queue</h1>
	In this operation, you will clear all the task queue. <br/>
	You can set the verdict after clearing them. <br/>
	<form action="clear.jsp" method="get">
		Verdict:<input name="verdict" type="text">
		<input name="submit" type="submit">
	</form>
</body>
</html>