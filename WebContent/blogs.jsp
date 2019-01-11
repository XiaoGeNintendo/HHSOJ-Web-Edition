<%@page import="com.hhs.xgn.jee.hhsoj.db.UserRenderer"%>
<%@page import="java.util.Comparator"%>
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
	<!-- Default Template -->
	<h1 id="title">Community</h1>
	<i id="subtitle">Read,write and judge others' blogs! --XGN</i>
	<hr />
	<jsp:include page="nav.jsp?at=blogs"></jsp:include>
		
	<%
		String userLooking=(String)session.getAttribute("username");
	
		
	%>
	<!-- Default End-->
	<div id="write-blog">
		<img src="asset/post.png" alt="Post"/>
		<p style="vertical-align: middle;float:left;margin-top:3px;"><a href="writeBlog.jsp">Write a post</a>&nbsp;</p>
    </div>
	
	<table id="blog-table">
		<tr>
			<th width="70%">Post title</th>
			<th width="18%">Author</th>
			<th width="12%">Popularity</th> 
		</tr>
	
		<%
			BlogHelper bh=new BlogHelper();
			ArrayList<Blog> blogs=bh.getAllBlogs();
			
			blogs.sort(new Comparator<Blog>(){
				public int compare(Blog o1, Blog o2){
					return -Integer.compare(o1.getId(), o2.getId());
				}
			});
			
			String userF=request.getParameter("userF");
			
			if(userF!=null){
				out.println("<center><b>Now using UserFilter - "+userF+"</b></center>");
			}
			
			
			for(Blog b:blogs){	
				if(userF!=null && !b.getUser().equals(userF) || b.isDeleted()){
					continue;
				}
		%>
			<tr>
				<td><a href="viewBlog.jsp?id=<%=b.getId()%>"><%=b.getTitle()%></a></td>
				<td><%out.println(new UserRenderer().getUserText(b.getUser())); %></td>
			
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