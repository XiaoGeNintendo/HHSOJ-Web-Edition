<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Question"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ContestHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Contest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
	String uid=request.getParameter("id");
	String a=request.getParameter("role");
	String b=request.getParameter("color");
	if(uid==null || uid.equals("") || a==null || b==null){
		return;
	}
	
	Users u=new UserHelper().getUserInfo(uid);
	
	u.setSpecialColor(b);
	u.setSpecialRole(a);
	
	new UserHelper().refreshUser(u);
	
	out.print("update success for "+uid+" to "+a+"<br/>"+b);
	
%>