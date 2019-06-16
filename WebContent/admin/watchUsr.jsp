<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
<%@page import="java.util.ArrayList"%>
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
		
	String id=request.getParameter("id");
	if(id==null || id.equals("")){
		return;
	}
	
	Users u=new UserHelper().getUserInfo(id);
	%>
	<h1><%=u.getId()+":"+u.getUsername() %></h1>
	<hr/>
	
	<b>Contest Record</b>:<%=u.getRatings() %> <br/>
	<b>Rating</b>:<%=u.getNowRating() %>/<%=u.getMaxRating() %><br/>
	<b>Mail</b>: <%=u.getEmail() %> <br/>
	
	<hr/>
	
	<a href="ban.jsp?id=<%=u.getId() %>">Ban/Unban</a> <br/>
	
	<input id="role" value="<%=u.getSpecialRole()%>" placeholder="Special Role">
	<input id="color" value="<%=u.getSpecialColor()%>" placeholder="Special Render Method.">
	<button onclick="send()">Change Role</button>
	
	<hr/>
	<%=u.toJson() %>
</body>
</html>