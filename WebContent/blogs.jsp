<%@page import="com.hhs.xgn.jee.hhsoj.type.Blog"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.BlogHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="index.css" rel="stylesheet" type="text/css">
<title>HHSOJ-Blogs</title>
</head>
<body>
	<!-- Default Template -->
	<h1 id="title">Community</h1>
	<i id="subtitle">Read,write and judge others' blogs! --XGN</i>
	<hr />
	<jsp:include page="nav.jsp?at=blogs"></jsp:include>
		
	<%
		String userLooking=(String)session.getAttribute("username");
	%>
	<!-- Default End-->
	
	<table align="center" class="write">
		<tr>
			<td width="85%"></td>
			<td width="15%"><img src="asset/post.png" alt="Post"/><a href="writeBlog.jsp">Write a post</a></td>
		</tr>
	</table>
	
	<table width="80%" align="center" border="1">
		<tr>
			<th width="70%">Post title</th>
			<th width="20%">Author</th>
			<th width="10%">Popularity</th> 
		</tr>
	
		<%
			BlogHelper bh=new BlogHelper();
			ArrayList<Blog> blogs=bh.getAllBlogs();
			for(Blog b:blogs){	
		%>
			<tr class="blogrow">
				<td align="center" class="blogtitle"><a href="viewPost.jsp?id=<%=b.getId()%>"><%=b.getTitle()%></a></td>
				<td align="center" class="bloguser"><a href="users.jsp?username=<%=b.getUser() %>"><%=b.getUser() %></a></td>
			
		<%
			if(b.getVote()>0){
		%>
				<td align="center" class="blogup">+<%=b.getVote() %></td>
		<%
			}else{
		%>
				<td align="center" class="blogdown"><%=b.getVote() %></td>
		<%
			}
		%>
			</tr>
		<%
			}
		%>
	</table>
</body>
</html>