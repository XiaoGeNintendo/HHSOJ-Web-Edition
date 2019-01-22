<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.hhs.xgn.jee.hhsoj.db.*,com.hhs.xgn.jee.hhsoj.type.*,java.util.*" %>
<%
	String username="";
	String password="";
	String type="";
	
	request.setCharacterEncoding("utf-8");
	
	username=request.getParameter("username");
	password=request.getParameter("password");
	type=request.getParameter("type");
	
	UserHelper db=new UserHelper();
	ArrayList<Users> users=db.getAllUsers();
	
	boolean ok=false;
	
	for(Users s:users){
		if(s.getUsername().equals(username) && s.getPassword().equals(password)){
			
			if(s.isBanned()){
				out.println("Man, you are banned!!! No more logging in!");
				return;
			}
			
			request.getRequestDispatcher("finish_login.jsp").forward(request, response);
			return;
		}
	}
	
	if(!ok){
		out.println("<font color=#ff0000><b>Wrong username or password. Please try again!</b></font><br/><a href=\"login.jsp\">Try again</a>");
	}
%>