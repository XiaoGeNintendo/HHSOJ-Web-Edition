<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.hhs.xgn.jee.hhsoj.db.*,com.hhs.xgn.jee.hhsoj.type.*,java.util.*" %>
<%
	
	request.setCharacterEncoding("utf-8");
	
	
	
	String username=request.getParameter("username");
	String password=request.getParameter("password");
	String email=request.getParameter("email");
	String line=request.getParameter("line");
	
	//System.out.println(username+" "+password+" "+email+" "+line);
	
	UserHelper db=new UserHelper();
	ArrayList<Users> users=db.getAllUsers();
	
	boolean ok=false;
	
	for(Users s:users){
		if(s.getUsername().equals(username)){
			out.println("<font color=#ff0000><b>Sorry, this username has been taken. Please try another</b></font>");
			out.println("<a href=\"register.jsp\">Let me try again</a>");
					
			ok=true;
		}
	}
	
	if(!ok){
		Users u=new Users();
		u.setUsername(username);
		u.setPassword(password);
		u.setLine(line);
		
		db.addUser(u);
		
		request.getRequestDispatcher("finish_reg.jsp").forward(request, response);
		
	}
%>