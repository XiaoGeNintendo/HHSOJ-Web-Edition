<%@page import="java.io.File"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ConfigLoader"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Config"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	Config c;
	try{
		c=new ConfigLoader().load();
	}catch(Exception e){
		out.println(new File("hhsoj").getAbsolutePath());
		return;
	}
	
	String psd=request.getParameter("adminPsd");
	String usr=request.getParameter("adminName");
	if(c.getAdminPassword().equals(psd) && c.getAdminUsername().equals(usr)){
		session.setAttribute("admin", true);
		
		response.sendRedirect("platform.jsp");
	}else{
		response.sendRedirect("login.jsp");
	}
%>