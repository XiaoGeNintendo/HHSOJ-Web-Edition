<%@page import="com.hhs.xgn.jee.hhsoj.type.Comment"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.BlogHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Blog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	try{
		String user=(String)session.getAttribute("username");
		String blogId=request.getParameter("blogId");
		String commentId=request.getParameter("commentId");
		int cid=Integer.parseInt(commentId);
		if(commentId==null || blogId==null || user==null){
			throw new Exception("null");
		}
		Blog b=new BlogHelper().getBlogDataByID(blogId);
		Comment c=b.getComments().get(cid);
		if(!c.getUser().equals(user)){
			throw new Exception("user not right");
		}
		b.getComments().remove(cid);
		new BlogHelper().refreshBlog(b);
		response.sendRedirect("viewPost.jsp?id="+blogId);
	}catch(Exception e){
		out.println("Error");
		out.println("<!--"+e+"-->");
	}
%>