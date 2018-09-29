<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.*,com.hhs.xgn.jee.hhsoj.db.*,com.hhs.xgn.jee.hhsoj.type.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="index.css" rel="stylesheet" type="text/css">
<title>HHSOJ-Problems</title>
</head>
<body>
	<h1 id="title">Problems in HHSOJ</h1>
	<i id="subtitle">Solve them? Impossible! --Zzzyt</i>
	<hr />
	<div id="nav">
		<a href="index.jsp" class="nav-link-left">Home</a>
		<a href="problemset.jsp" class="nav-link-left selected">Problems</a>
		<a href="status.jsp" class="nav-link-left">Status</a>
		<a href="submit.jsp" class="nav-link-left">Submit</a>
		<%
			String user = (String) session.getAttribute("username");

			if (user != null) {
				out.println("<a href=\"users.jsp?username=" + user + "\" class=\"nav-link-right\">" + user + "</a>");
				out.println("<a href=\"logout.jsp\" class=\"nav-link-right\">Logout</a>");
			} else {
				out.println("<a href=\"login.jsp\" class=\"nav-link-right\">Login</a>");
				out.println("<a href=\"register.jsp\" class=\"nav-link-right\">Register</a>");
			}
		%>
	</div>
	<div id="seperator"></div>
	<table id="problem-table">
		<tr>
			<th width="10%">ID</th>
			<th width="50%">Name</th>
			<th width="40%">Tags</th>
		</tr>

		<!-- Start for -->

		<%
			ProblemHelper db = new ProblemHelper();
			ArrayList<Problem> p = db.getAllProblems();

			for (Problem pro : p) {
		%>
		<tr>

			<td><%=pro.getId()%></td>

			<td><a href="problem.jsp?id=<%=pro.getId()%>"><%=pro.getName()%></a></td>
			<td><%=pro.getTag()%></td>
		</tr>

		<!-- End for -->
		<%
			}
		%>
	</table>
</body>
</html>