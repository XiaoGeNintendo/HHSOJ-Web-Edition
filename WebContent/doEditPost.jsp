<%@page import="com.hhs.xgn.jee.hhsoj.type.Blog"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.BlogHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	String html=request.getParameter("html");
	String user=(String)session.getAttribute("username");
	String title=request.getParameter("title");
	String id=request.getParameter("id");
	if(html==null || user==null || html.equals("") || user.equals("") || title==null || title.equals("") || id==null){
		out.println("An error occurred while processing your operation.");
		out.println("Please go back to another page.");
		return;
	}
	
	Blog b=new BlogHelper().getBlogDataByID(id);
	b.setHtml(html);
	b.setTitle(title);
	
	new BlogHelper().refreshBlog(b);
	
	
	out.println("Your blog has been successfully saved");
	out.println("<a href=\"index.jsp\">back</a>");
		
%>