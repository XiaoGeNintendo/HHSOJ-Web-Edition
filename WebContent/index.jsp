<%@ page language="java" contentType="text/html; charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="index.css" rel="stylesheet" type="text/css">
<title>HHSOJ</title>
</head>
<body>
	<!-- Enter Everything here -->
	<h1 id="title">Welcome to Hell Hole Studios Online Judge!</h1>
	<i id="subtitle">This OJ is made by XiaoGeNintendo in Hell Hole
		Studios</i>
	<hr />
	<div id="nav">
		<a href="index.jsp" class="nav-link-left selected">Home</a> 
		<a href="problemset.jsp" class="nav-link-left">Problems</a> 
		<a href="status.jsp" class="nav-link-left">Status</a>
		<a href="submit.jsp" class="nav-link-left">Submit</a>
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
	<br />
	<marquee id="marquee">Welcome to HHSOJ!:P</marquee>
	This system is still under developing. Please don't upload any harmful
	code. Thanks :(
	<br />

	<a href="verdict.jsp" id="verdict">Verdicts List</a>
	
	<hr/>
	<h1>Credits</h1>
	
	<a href="mailto:gwq0419@163.com">XiaoGeNintendo</a> <br/>
	<a href="http://codeforces.com/profile/zzzyt">Zzzyt</a>
</body>
</html>