<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	String username=request.getParameter("username");
	String oldPassword=request.getParameter("password");
	String newPassword=request.getParameter("newPassword");
	String line=request.getParameter("line");
	String userPic=request.getParameter("icon");
	
	String nowUsername=(String)session.getAttribute("username");
	
	Users nowU=new UserHelper().getUserInfo(nowUsername);
	
	if(!oldPassword.equals(nowU.getPassword())){
		out.println("Incorrect password");
		return;
	}
	
	if(username.equals("")==false){
		nowU.setUsername(username);
		session.setAttribute("username", username);
	}
	if(newPassword.equals("")==false){
		nowU.setPassword(newPassword);
	}
	if(line.equals("")==false){
		nowU.setLine(line);
	}
	if(userPic.equals("")==false){
		nowU.setUserPic(userPic);
	}
	new UserHelper().refreshUser(nowU);
	
	response.sendRedirect("users.jsp?username="+username);
	
%>