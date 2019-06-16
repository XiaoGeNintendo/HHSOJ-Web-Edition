<%@page import="com.hhs.xgn.jee.hhsoj.db.ConfigLoader"%>
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
	if(usr==null || usr.equals("")){
		out.println("Username is Empty");
		return;
	}
	
	Users u=new UserHelper().getUserInfo(usr);
	if(u==null){
		out.println("No such user");
		return;
	}
	if(u.isBanned() || !u.isVerified()){
		out.println("User is banned or not verified");
		return;
	}
	if(!new ConfigLoader().load().isEnableForgetPassword()){
		out.println("Resetting Password Feature is Closed By Admin.");
		return;
	}
	if(u.getLastForget()>=System.currentTimeMillis()-60*1000){
		out.println("Too frequent request! Wait "+(60-(System.currentTimeMillis()-u.getLastForget()+999)/1000)+" seconds OK?");
		return;
	}
	
	
	out.println(new MailHelper().sendForgetEmail(u)+"\nTime limit is 60 minutes.");
%>