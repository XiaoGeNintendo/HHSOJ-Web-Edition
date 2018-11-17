<%@page import="com.hhs.xgn.jee.hhsoj.judger.TaskQueue"%>
<%@page import="com.hhs.xgn.jee.hhsoj.judger.JudgingThread"%>
<%@page import="java.io.File"%>
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
		boolean in=(Boolean)session.getAttribute("admin");
		if(!in){
			return;
		}
	%>
	<h1>Admin Platform</h1>
	<hr/>
	HHSOJ system path: <%=new File("hhsoj").getAbsolutePath() %> <br/>
	
	<hr/>
	
	<a href="users.jsp">Show all users</a> <br/>
	<a href="subs.jsp">Show all submissions</a> <br/>
	<a href="blogs.jsp">Show all posts</a> <br/>
	
	<hr/>
	Next to test:<%=(TaskQueue.hasElement()?TaskQueue.getFirstSubmission().toJson():null) %> <br/>
	<a href="clear.jsp">Clear judging queue</a> <br/>
	
	<hr/>
	<a href="richtextEditor.jsp">Rich text editor</a> <br/>
	<a href="TimeChanger.jsp">Time Changer</a> <br/>
	
	<hr/>
	<i> HHSOJ Admin Platform </i>
</body>
</html>