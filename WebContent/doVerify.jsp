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
	if(usr==null || usr.equals("") || pwd==null || pwd.equals("")){
		out.println("Username or Password is Empty");
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
	
	if(u.getLastVerify()>=System.currentTimeMillis()-60*1000){
		out.println("Too frequent request! Wait "+(System.currentTimeMillis()-u.getLastVerify()+999)/1000+" seconds OK?");
		return;
	}
	
	if(u.isVerified()){
		out.println("No need to verify");
		return;
	}
	
	out.println(new MailHelper().sendVerifyMail(u));
%>