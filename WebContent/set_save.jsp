<%@page import="com.hhs.xgn.jee.hhsoj.db.FileHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ConfigLoader"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String userLooking = (String) session.getAttribute("username");
	if (userLooking == null) {
		out.println("Please login to continue");
		return;
	}
	Users u=new UserHelper().getUserInfo(userLooking);
	if(!u.isSetter()){
		out.println("Access denied");
		return;
	}
	String file=request.getParameter("file");
	String val=request.getParameter("data");
	if(file==null || val==null){
		out.println("Access denied");
		return;
	}
	
	
	out.println(FileHelper.writeFile(ConfigLoader.getPath()+"/"+file,val));
%>	