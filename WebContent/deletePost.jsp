<%@page import="com.hhs.xgn.jee.hhsoj.db.BlogHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Blog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="index.css" rel="stylesheet" type="text/css">
<title>HHSOJ - Delete Post</title>
</head>
<body>

	<%
		String userLooking;
		Blog b;
		try{
			userLooking=(String)session.getAttribute("username");
			int blogId=Integer.parseInt(request.getParameter("id"));
			b=new BlogHelper().getBlogDataByID(blogId);
			if(b==null){
				throw new Exception("Doesn't exist");
			}
			if(!b.getUser().equals(userLooking)){
				throw new Exception("You are not the author");
			}
			
			b.setDeleted(true);
			new BlogHelper().refreshBlog(b);
			
			response.sendRedirect("blogs.jsp");
		}catch(Exception e){
			out.println("Request Error");
			out.println("<!--"+e+"-->");
			return;
		}
		
	%>
	
	<!-- Default Template -->
	
	
</body>
</html>