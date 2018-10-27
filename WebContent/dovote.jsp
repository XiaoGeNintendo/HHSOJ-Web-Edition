<%@page import="com.hhs.xgn.jee.hhsoj.db.BlogHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Blog"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	String user=(String)session.getAttribute("username");
	if(user==null || user.equals("")){
		out.println("Permission denied");
		return;
	}
	
	try{
		int id=Integer.parseInt(request.getParameter("id"));
		int upv=Integer.parseInt(request.getParameter("upv"));
		
		Users u=new UserHelper().getUserInfo(user);
		Blog b=new BlogHelper().getBlogDataByID(id);
		
		if(u.getBlogStatus(id)!=0){
			throw new Exception("Voted");
		}
		
		u.setBlogStatus(id, (upv==1?1:2));
		if(upv==1){
			b.addvote();
		}else{
			b.downvote();
		}
		
		new UserHelper().refreshUser(u);
		new BlogHelper().refreshBlog(b);
		
		response.sendRedirect("viewPost.jsp?id="+id);
		
	}catch(Exception e){
		out.println("Permission denied");
		out.println("<!-- "+e+" -->");
		return;
	}
%>