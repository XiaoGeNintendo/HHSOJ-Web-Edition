<%@page import="com.hhs.xgn.jee.hhsoj.db.ConsoleParser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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

	out.println(ConsoleParser.parse(session,request));
	
%>
	