<%@page import="java.io.File"%>
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
	
	
	
	String name=request.getParameter("name");
	String back=request.getParameter("back");
	if(name==null || back==null){
		out.println("Access denied");
		return;
	}
	
	if(name.contains("..")){
		out.println("Access denied");
		return;
	}
	
	File f=new File(ConfigLoader.getPath()+"/"+name);
	if(!f.exists()){
		out.println("File doesn't exist");
		return;
	}
	
	boolean ok=f.delete();
	if(!ok){
		out.println("Delete Failed");
		return;
	}
	
	response.sendRedirect(back);
%>	