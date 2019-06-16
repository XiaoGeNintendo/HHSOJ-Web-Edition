<%@page import="com.hhs.xgn.jee.hhsoj.db.MailHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Question"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ContestHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Contest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String usr=request.getParameter("user");
	String code=request.getParameter("code");
	if(usr==null || usr.equals("") || code==null || code.equals("")){
		out.println("Username or Password or Code is Empty");
		return;
	}
	
	Users u=new UserHelper().getUserInfo(usr);
	if(u==null){
		out.println("No such user");
		return;
	}

	if(u.getLastForget()<=System.currentTimeMillis()-60*60*1000){
		out.println("The code is out-of-date. Please resend another code");
		return;
	}
	
	if(code.equals(u.getForgetCode())){
		out.println("Reset Done. Your password has been set to the code you entered.");
		u.setPassword(u.getForgetCode());
		new UserHelper().refreshUser(u);
		return;
	}
	
%>