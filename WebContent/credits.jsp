<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="index.css" rel="stylesheet" type="text/css">
<title>HHSOJ - Credits</title>
</head>
<body>

	<!-- Enter Everything here -->
	<h1 id="title">Credits</h1>
	<i id="subtitle">I prefer cash :) --XGN</i>
	<hr />
	<div id="nav">
		<a href="index.jsp" class="nav-link-left selected">Home</a> 
		<a href="problemset.jsp" class="nav-link-left">Problems</a> 
		<a href="status.jsp" class="nav-link-left">Status</a>
		<a href="submit.jsp" class="nav-link-left">Submit</a>
		<a href="blogs.jsp" class="nav-link-left">Community</a>
		<%String user = (String) session.getAttribute("username");

			if (user != null) {
				out.println("<a href=\"users.jsp?username=" + user + "\" class=\"nav-link-right\">" + user + "</a>");
				out.println("<a href=\"logout.jsp\" class=\"nav-link-right\">Logout</a>");
			} else {
				out.println("<a href=\"login.jsp\" class=\"nav-link-right\">Login</a>");
				out.println("<a href=\"register.jsp\" class=\"nav-link-right\">Register</a>");
			}%>
	</div>
	<div id="seperator"></div>
	
	<center>
		<table id="creditTable" border="2">
			
			<tr id="creditHead">
				<th>Photo</th>
				<th>Name</th>
				<th>Description</th>
			</tr>
			
			<tr id="creditUser">
				<td>
					<img alt="XiaoGeNintendo" src="asset/XGN.png" height="100" width="100">
				</td>
				<td>XiaoGeNintendo</td>
				<td>The main developer.<br/><a href="mailto:gwq0419@163.com">Get him!</a></td>	
			</tr>
			
			<tr id="creditUser">
				<td>
					<img alt="Zzzyt" src="asset/ZJS.jpg" height="100" width="100">
				</td>
				<td>Zzzyt</td>
				<td>The CSS developer.<br/><a href="mailto:zzzyt@yopmail.com">Get him!</a></td>	
			</tr>
			
			<!-- Add your developers here -->
		</table>
		
		<!-- System path= <%=new File("hhsoj").getAbsolutePath() %> -->
	</center>
</body>
</html>