<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.hhs.xgn.jee.hhsoj.db.*,com.hhs.xgn.jee.hhsoj.type.*,java.util.*" %>
<%
	String username="";
	String password="";
	
	request.setCharacterEncoding("utf-8");
	
	
	
	username=request.getParameter("username");
	password=request.getParameter("password");
	
	//System.out.println(username+" "+password);
	
	UserHelper db=new UserHelper();
	ArrayList<Users> users=db.getAllUsers();
	
	boolean ok=false;
	
	for(Users s:users){
		if(s.getUsername().equals(username) && s.getPassword().equals(password)){
			
			request.getRequestDispatcher("finish_login.jsp").forward(request, response);
			
			ok=true;
		}
	}
	
	if(!ok){
		out.println("<font color=#ff0000><b>Wrong username or password. Please try again!</b></font><br/><a href=\"login.jsp\">Try again</a>");
	}
%>