
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserRenderer"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Comment"%>
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
<jsp:include page="head.jsp"></jsp:include>

<title>HHSOJ-Blogs</title>
</head>
<body>
<div class="container">
	<%
		request.setCharacterEncoding("utf-8");
	
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
		if(bl.isDeleted()){
			out.println("This blog has been deleted");
			return;
		}
	%>
	
	<!-- Default Template -->
	
	<h1 class="title"><%=bl.getTitle()%></h1>
	<i class="subtitle">By <%out.println(new UserRenderer().getUserText(bl.getUser()));%> at <%=bl.getReadableTime() %></i>
	<hr />
	<jsp:include page="nav.jsp?at=blogs"></jsp:include>

	<%
		String userLooking = (String) session.getAttribute("username");
	%>
	<!-- Default End-->

	
	<div class="card"><div class="card-body">
		<!-- Blog post HTML -->

		<%
			out.println(bl.getHtml());
		%>

		<!-- End blog -->
	</div></div>

	<hr/>
	
	<%
		int stat = 0; //0=no status, 1=upvote, -1=downvote
		if (userLooking != null) {
			Users u = new UserHelper().getUserInfo(userLooking);

			stat = u.getBlogStatus(bl.getId());
		}

		if (stat == 0) {
	%>
			<a href="dovote.jsp?id=<%=bl.getId() %>&upv=1"><i class="fa fa-thumbs-up upvote"></i></a>
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
			<a href="dovote.jsp?id=<%=bl.getId() %>&upv=-1"><i class="fa fa-thumbs-down downvote"></i></a>
	<%
		}
		
		if (stat == 1) {
	%>
			<i class="fa fa-thumbs-up upvoted"></i>
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
			<i class="fa fa-thumbs-down downvote"></i>
	<%
		}
		
		if (stat == 2) {
	%>
			<i class="fa fa-thumbs-up upvote"></i>
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
			<i class="fa fa-thumbs-down downvoted"></i>
	<%
		}
		
		if(bl.getUser().equals(userLooking)){
	%>
		<a class="btn btn-secondary" href="editBlog.jsp?id=<%=bl.getId() %>">Edit</a> 
		<a class="btn btn-danger" href="deleteBlog.jsp?id=<%=bl.getId() %>">Delete</a>
		<br/>
	<%			
		}
		
		if(userLooking==null){		
	%>
			<br/>Please login to send comments <br/>
	<%
		}else{
			
	%>
		<div class="form-group">
			<form action="doComment.jsp?id=<%=bl.getId() %>" method="post" id="comment">
				<textarea class="form-control" name="comment" rows="4" placeholder="Leave your comment..."></textarea>
				<input class="btn btn-primary" type="submit" name="submit" value="Comment">
			</form>
		</div>
		<br/>
	<%
		}
	%>
	
	<h3 style="font-family:Consolas;">Comments</h3>
	
	<%
		for(int i=bl.getComments().size()-1;i>=0;i--){
			Comment c=bl.getComments().get(i);
	%>
	<div class="card" style="margin:5px;"><div class="card-body">
		<a name="Comment<%=i %>"></a>
		<table><tr>
			<td style="vertical-align:center;">
				<p style="margin-right:10px;"><%out.println(new UserRenderer().getUserText(c.getUser()));%></p>
			</td>
			<td>
				<p style="word-break:break-word;">
				<%=c.getComment() %>
				<%if(c.getUser().equals(userLooking)){%>
					<br/>
					<a href="deleteComment.jsp?blogId=<%=bl.getId()%>&commentId=<%=i%>">Delete</a>
				<%} %>
				</p>
			</td>		
		</tr></table>
	</div></div>
	<%
		}
	%>
</div>
</body>
</html>