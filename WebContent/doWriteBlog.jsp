<%@page import="com.hhs.xgn.jee.hhsoj.db.BlogHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	String html=request.getParameter("html");
	String user=(String)session.getAttribute("username");
	String title=request.getParameter("title");
	if(html==null || user==null || html.equals("") || user.equals("") || title==null || title.equals("")){
		out.println("An error occurred while processing your operation.");
		out.println("Please go back to another page.");
		return;
	}
	
	new BlogHelper().writeBlog(title,html,user);
	
	
	out.println("Your blog has been successfully saved");
	out.println("<a href=\"index.jsp\">back</a>");
		
%>