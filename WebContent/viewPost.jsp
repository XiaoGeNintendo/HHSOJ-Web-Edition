
<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
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
	<%
		String id = request.getParameter("id");
		if (id == null) {
			out.println("Post not found");
			return;
		}

		Blog bl = new BlogHelper().getBlogDataByID(id);

		if (bl == null) {
			out.println("Post not found");
			return;
		}
	%>
	
	<!-- Default Template -->
	<h1 id="title"><%=bl.getTitle()%></h1>
	<i id="subtitle">By <a href="users.jsp?username=<%=bl.getUser() %>"><%=bl.getUser()%></a> at <%=bl.getReadableTime() %></i>
	<hr />
	<jsp:include page="nav.jsp?at=blogs"></jsp:include>

	<%
		String userLooking = (String) session.getAttribute("username");
	%>
	<!-- Default End-->

	
	<div id="reader">
		<!-- Blog post HTML -->

		<%
			out.println(bl.getHtml());
		%>

		<!-- End blog -->
	</div>

	<hr/>
	
	<%
		int stat = 0; //0=no status, 1=upvote, -1=downvote
		if (userLooking != null) {
			Users u = new UserHelper().getUserInfo(userLooking);

			stat = u.getBlogStatus(bl.getId());
		}

		if (stat == 0) {
	%>
			<a href="dovote.jsp?id=<%=bl.getId() %>&upv=1"><img src="asset/upt.png" alt="Upvote"/></a>
	<%
			if (bl.getVote() > 0) {
	%>
				<i class="blogup">+<%=bl.getVote()%></i>
	<%
			} else {
	%>
				<i class="blogdown"><%=bl.getVote()%></i>
	<%
			}
	%>
			<a href="dovote.jsp?id=<%=bl.getId() %>&upv=-1"><img src="asset/downt.png" alt="Upvote"/></a>
	<%
		}
		
		if (stat == 1) {
	%>
			<img src="asset/upedt.png" alt="Upvoted"/>
	<%
			if (bl.getVote() > 0) {
	%>
				<i class="blogup">+<%=bl.getVote()%></i>
	<%
			} else {
	%>
				<i class="blogdown"><%=bl.getVote()%></i>
	<%
			}
	%>
			<img src="asset/downt.png" alt="Downvote"/>
	<%
		}
		
		if (stat == 2) {
	%>
			<img src="asset/upt.png" alt="Upvote"/>
	<%
			if (bl.getVote() > 0) {
	%>
				<i class="blogup">+<%=bl.getVote()%></i>
	<%
			} else {
	%>
				<i class="blogdown"><%=bl.getVote()%></i>
	<%
			}
	%>
			<img src="asset/downedt.png" alt="Downvoted"/>
	<%
		}
		
	%>
</body>
</html>