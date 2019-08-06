<%@page import="com.hhs.xgn.jee.hhsoj.db.FileHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ConfigLoader"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
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
	
	if(file.contains("..")){
		out.println("Please don't use '..' in filename");
		return;
	}
	
	System.out.println("Compile File Request Start");
	
	
	out.println(FileHelper.compileFile(ConfigLoader.getPath()+"/"+file,val));
%>	