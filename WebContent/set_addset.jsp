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
	
	
	
	String pid=request.getParameter("pid");
	String name=request.getParameter("name");
	
	if(pid==null || name==null){
		out.println("Access denied");
		return;
	}
	
	if(name.contains("/") || name.contains("\\") || name.contains("..")){
		out.println("Bad name");
		return;
	}
	File f=new File(ConfigLoader.getPath()+"/problems/"+pid+"/"+name);
	if(f.exists()){
		out.println("Testset Already Exists");
		return;
	}
	
	boolean ok=f.mkdir();
	if(!ok){
		out.println("Create Failed");
		return;
	}
	
	response.sendRedirect("set_editProbTest.jsp?id="+pid);
%>	