<%@page import="com.hhs.xgn.jee.hhsoj.type.PreferUnit"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Question"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ContestHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Contest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	try{
		String user=(String)session.getAttribute("username");
		if(user==null || user.equals("")){
			throw new Exception("not login");
		}
		Users u=new UserHelper().getUserInfo(user);
		
		if(u==null){
			throw new Exception("Unknown user");
		}
		
		for(String key:u.getPreference().allKey){
			
			System.out.println("voo");
			
			String v=request.getParameter("value_"+key);
			String r=request.getParameter("public_"+key);
			System.out.println("voo");
			u.getPreference().units.get(key).value=v;
			u.getPreference().units.get(key).isPublic=r!=null;
		}
		
		new UserHelper().refreshUser(u);
		
		response.sendRedirect("users.jsp?username="+user);
		
	}catch(Exception e){
		out.println("Error!");
		e.printStackTrace();
		out.println("<!-- "+e+"-->");
	}
%>