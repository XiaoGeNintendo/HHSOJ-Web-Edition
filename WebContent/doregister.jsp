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
	
	if(username==null){
		response.sendRedirect("register.jsp");
		return;
	}
	
	if(!username.matches("[a-z0-9A-Z]{1,50}")){
		out.println("Username should match regex [a-z0-9A-z]{1,50}");
		return;
	}
	if(password.length()>50){
		out.println("Maximum length of password is 50 characters");
		return;
	}
	if(line.length()>300){
		out.println("Maximum length of line is 300 characters");
		return;
	}
	if(email.length()>100){
		out.println("Maximum email length is 100 characters");
		return;
	}
	
	if(!ok){
		Users u=new Users();
		u.setUsername(username);
		u.setPassword(password);
		u.setLine(line);
		u.setEmail(email);
		if(!new ConfigLoader().load().isNeedEmailVerify()){
			u.setVerified(true);
		}
		db.addUser(u);
		
		request.getRequestDispatcher("finish_reg.jsp").forward(request, response);
		
	}
%>