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
	String pwd=request.getParameter("pwd");
	String code=request.getParameter("code");
	if(usr==null || usr.equals("") || pwd==null || pwd.equals("") || code==null || code.equals("")){
		out.println("Username or Password or Code is Empty");
		return;
	}
	
	Users u=new UserHelper().getUserInfo(usr);
	if(u==null){
		out.println("No such user");
		return;
	}
	if(!u.getPassword().equals(pwd)){
		out.println("Password is Incorrect");
		return;
	}
	if(u.isVerified()){
		out.println("No need to verify");
		return;
	}
	

	if(u.getLastVerify()<=System.currentTimeMillis()-60*60*1000){
		out.println("The code is out-of-date. Please resend another code");
		return;
	}
	
	if(code.equals(u.getVerifyCode())){
		out.println("Verify Success. You are logged in. Return to homepage to view changes.");
		session.setAttribute("username", u.getUsername());
		u.setVerified(true);
		new UserHelper().refreshUser(u);
		return;
	}
	
	
	out.println("Verify Failed. Check your cases.\n(Secretly tell you another mysterious code:"+(u.getVerifyCode()==null?"[No Data]":u.getVerifyCode().hashCode())+")");
%>