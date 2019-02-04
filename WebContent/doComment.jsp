<%@page import="com.hhs.xgn.jee.hhsoj.db.BlogHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Blog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%

	request.setCharacterEncoding("utf-8");
	
	String id=request.getParameter("id");
	String comment=request.getParameter("comment");
	String user=(String)session.getAttribute("username");
	if(user==null || id==null || comment==null){
		out.println("Error");
		return;
	}
	
	if(comment.length()>=65536){
		out.println("Comment is too long");
		return;
	}
	
	Blog b=new BlogHelper().getBlogDataByID(id);
	b.addComment(user, comment);
	
	
	new BlogHelper().refreshBlog(b);
	response.sendRedirect("viewBlog.jsp?id="+id+"#Comment"+(b.getComments().size()-1));
	
%>