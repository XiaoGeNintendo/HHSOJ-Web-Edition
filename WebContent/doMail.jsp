<%@page import="com.hhs.xgn.jee.hhsoj.type.Mail"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.BlogHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	request.setCharacterEncoding("utf-8");

	String html=request.getParameter("html");
	String user=(String)session.getAttribute("username");
	String title=request.getParameter("title");
	
	//System.out.println(html+" "+user+" "+title);
	
	if(html==null || user==null || html.equals("") || user.equals("") || title==null || title.equals("")){
		out.println("An error occurred while processing your operation.");
		out.println("Please go back to another page.");
		return;
	}
	
	Users send=new UserHelper().getUserInfo(user);
	Users to=new UserHelper().getUserInfo(title);
	
	if(to==null){
		to=send;
		html="<font color=#ff0000><b>[User '"+title+"' not found.The mail is rejected]</b></font><br/>"+html;
		title=user;

		long now=System.currentTimeMillis();
		send.getTalks().add(new Mail(user,title,html,now)); 
		
		new UserHelper().refreshUser(send);
	}else{

		long now=System.currentTimeMillis();
		send.getTalks().add(new Mail(user,title,html,now)); 
		to.getTalks().add(new Mail(user,title,html,now));
		
		new UserHelper().refreshUser(send);
		new UserHelper().refreshUser(to);
	}
	
	
	response.sendRedirect("mailbox.jsp?with="+title);
%>