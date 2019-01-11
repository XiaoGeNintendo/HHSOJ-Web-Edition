
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
	
	<h1 id="title"><%=bl.getTitle()%></h1>
	<i id="subtitle">By <%out.println(new UserRenderer().getUserText(bl.getUser()));%> at <%=bl.getReadableTime() %></i>
	<hr />
	<jsp:include page="nav.jsp?at=blogs"></jsp:include>

	<%
		String userLooking = (String) session.getAttribute("username");
	%>
	<!-- Default End-->

	
	<div id="blog-content">
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
		
		if(bl.getUser().equals(userLooking)){
	%>
		<a href="editBlog.jsp?id=<%=bl.getId() %>">Edit</a> 
		<a href="deleteBlog.jsp?id=<%=bl.getId() %>">Delete</a>
		<br/>
	<%			
		}
		
		if(userLooking==null){		
	%>
			<br/>Please login to send comments <br/>
	<%
		}else{
			
	%>
		<br/>
		<a name="CommentArea"></a>
		<form action="doComment.jsp?id=<%=bl.getId() %>" method="post" id="comment">
			<textarea name="comment" rows="8" cols="100" placeholder="Leave your comment..."></textarea>
			<input type="submit" name="submit" value="Comment">
		</form>
		
		<br/>
	<%
		}
	%>
	
	<h3>Comments</h3>
	
	<table id="comment-table">
	<%
		for(int i=bl.getComments().size()-1;i>=0;i--){
			Comment c=bl.getComments().get(i);
	%>
		<tr>
			<td>
				<a name="Comment<%=i %>"></a>
				<%out.println(new UserRenderer().getUserText(c.getUser()));%>:
				<%=c.getComment() %>
				<%if(c.getUser().equals(userLooking)){%>
					<sup><a href="deleteComment.jsp?blogId=<%=bl.getId()%>&commentId=<%=i%>"><abbr title="Delete Comment">x</abbr></a></sup>
				<%} %>
			</td>
		</tr>
	<%
		}
	%>
	</table>
</body>
</html>