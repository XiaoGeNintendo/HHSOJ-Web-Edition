<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page
	import="com.hhs.xgn.jee.hhsoj.db.*,com.hhs.xgn.jee.hhsoj.type.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="index.css" rel="stylesheet" type="text/css">
<title>HHSOJ-<%=request.getParameter("username")%></title>
</head>
<body>
	<%
		String user = request.getParameter("username");
		UserHelper db = new UserHelper();
		Users u = db.getUserInfo(user);
		if (user == null || user.equals("") || u == null) {
			out.println("The users you are looking for is not registered :(");
			out.println("<br/><a href=\"index.jsp\">Back</a>");
			return;
		}
	%>

	<!-- Default Template -->
	<h1 id="title">Users on HHSOJ</h1>
	<i id="subtitle"><%=user%>'s space</i>
	<hr />
	<jsp:include page="nav.jsp?at=index"></jsp:include>
	<!-- Default End -->


	<table width="80%">
		<tr>
			<th width="30%"></th>
			<th width="70%"></th>
		</tr>

		<tr>
			<td align="left">
				<h2><%=user %></h2>
				<i><%=u.getLine()%> -- <%=user%></i> <br /> 
				<img alt="submission" src="asset/submissions.png" />
				<a href="status.jsp?userId=a">Submissions</a> <br /> 
				<img alt="posts" src="asset/posts.png" />
				<a href="blogs.jsp?userF=<%=u.getUsername()%>">Posts by him</a><br />
				<img alt="rating" src="asset/rating.png" />Contest Rating: <%=u.getNowRating()%>(Max.<%=u.getMaxRating()%>) <br /> 
				
	
					<%
						String userLooking = (String) session.getAttribute("username");
								if (user.equals(userLooking)) {
					%> 
							<img alt="setting" src="asset/settings.png"><a href="settings.jsp">Change settings</a><br /> 
					<%
					 	}
				    %> 
			 </td>
			<td align="right"><img src="<%=u.getUserPic()%>" /></td>
		</tr>
	</table>
</body>
</html>