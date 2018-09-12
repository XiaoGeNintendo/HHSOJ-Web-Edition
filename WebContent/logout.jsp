<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
	session.setAttribute("username", null);
	response.sendRedirect("index.jsp");
	
%>