<%@page import="com.hhs.xgn.jee.hhsoj.type.ContestStandingRow"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ContestHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Contest"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Comment"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Blog"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.BlogHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Submission"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.SubmissionHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	String username=request.getParameter("username");
	String oldPassword=request.getParameter("password");
	String newPassword=request.getParameter("newPassword");
	String line=request.getParameter("line");
	String userPic=request.getParameter("icon");
	String info=request.getParameter("info");
	String nowUsername=(String)session.getAttribute("username");
	
	Users nowU=new UserHelper().getUserInfo(nowUsername);
	
	if(!oldPassword.equals(nowU.getPassword())){
		out.println("Incorrect password");
		return;
	}
	
	if(username.equals("")==false){
		
		ArrayList<Users> allUsers=new UserHelper().getAllUsers();
		for(Users u:allUsers){
			if(u.getUsername().equals(username)){
				out.println("The username has been in use.");
				return;
			}
		}
		
		if(!username.matches("[a-zA-Z0-9]{1,50}")){
			out.println("Username illegal");
			return;
		}
		
		//Refresh all user data
		
		ArrayList<Submission> sub=new SubmissionHelper().getAllSubmissions();
		
		//Refresh Submission
		for(Submission s:sub){
			if(s.getUser().equals(nowU.getUsername())){
				s.setUser(username);
				new SubmissionHelper().storeStatus(s);
			}
		}
		
		//Refresh Blog
		ArrayList<Blog> blogs=new BlogHelper().getAllBlogs();
		for(Blog b:blogs){
			if(b.getUser().equals(nowU.getUsername())){
				b.setUser(username);
				new BlogHelper().refreshBlog(b);
			}
			
			for(Comment c:b.getComments()){
				if(c.getUser().equals(nowU.getUsername())){
					c.setUser(username);
				}
			}
			new BlogHelper().refreshBlog(b);
		}
		
		//Refresh Contest
		ArrayList<Contest> cons=new ContestHelper().getAllContests();
		for(Contest c:cons){
			ContestStandingRow csr=c.getStanding().getContestStandingRowOfUser(nowU.getUsername());
			csr.setUser(username);
			new ContestHelper().refreshContest(c);
		}
		
		nowU.setUsername(username);
		session.setAttribute("username", username);
	}
	if(newPassword.equals("")==false && newPassword.length()<=50){
		nowU.setPassword(newPassword);
	}
	if(line.equals("")==false && line.length()<=300){
		nowU.setLine(line);
	}
	if(userPic.equals("")==false && userPic.length()<=1024){
		nowU.setUserPic(userPic);
	}
	if(info!=null && info.equals("on")){
		nowU.setSendNotify(true);
	}else{
		nowU.setSendNotify(false);
	}
	new UserHelper().refreshUser(nowU);
	
	response.sendRedirect("users.jsp?username="+nowU.getUsername());
	
%>