<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
	String back=request.getParameter("back");
	session.setAttribute("username", null);
	response.sendRedirect((back==null?"index.jsp":back+".jsp"));
	
%>