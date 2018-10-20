<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="com.hhs.xgn.jee.hhsoj.db.*,com.hhs.xgn.jee.hhsoj.type.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="index.css" rel="stylesheet" type="text/css">
<title>HHSOJ-<%=request.getParameter("username")%></title>
</head>
<body>
	<%
		String user=request.getParameter("username");
		UserHelper db=new UserHelper();
		Users u=db.getUserInfo(user);
		if(user==null || user.equals("") || u==null){
			out.println("The users you are looking for is not registered :(");
			out.println("<br/><a href=\"index.jsp\">Back</a>");
		}else{
	%>

	<!-- Default Template -->
	<h1 id="title">Users on HHSOJ</h1>
	<i id="subtitle"><%=user %>'s space</i>
	<hr />
	<jsp:include page="nav.jsp?at=home"></jsp:include>
	<!-- Default End -->
	
	<h2><%=user %></h2>
	
	<i><%=u.getLine() %> -- <%=user %></i> <br/>
	<img alt="submission" src="asset/submissions.png"/><a href="status.jsp?userId=a">Submissions</a> <br/>
	<img alt="rating" src="asset/rating.png"/>Contest Rating: <%=u.getNowRating() %>(Max. <%=u.getMaxRating() %>) <br/>
	<!-- <img alt="blogs" src="asset/blogs.png"/><a href="#">Blogs</a><br/> -->
	
	<%
		}
	%>
</body>
</html>