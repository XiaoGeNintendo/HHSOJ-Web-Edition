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
		
		ArrayList<Users> user=new UserHelper().getAllUsers();
		
		for(Users u:user){
			out.println("<b>User #"+u.getId()+"</b> - "+(u.isBanned()?"<s>":"")+u.getUsername()+(u.isBanned()?"</s>":"")+" - Rating:"+u.getNowRating()+"<a href=\"watchUsr.jsp?id="+u.getUsername()+"\">Detail</a><br/>");
		}
	%>
	
	
</body>
</html>