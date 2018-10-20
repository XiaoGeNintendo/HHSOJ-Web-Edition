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
<style type="text/css">
	#problem-table {
		border-collapse: collapse;
		width: 80%;
		align-self: center;
		margin: 0px auto;
		min-width: 500px;
		border:1px solid #cccccc;
		background:#f0f0f0;
	}
	
	#problem-table th{
		padding: 3px;
		border: 1px solid #cccccc;
	}
	
	#problem-table td{
		padding: 3px;
		border: 1px solid #cccccc;
	}
</style>
</head>
<body>
	<h1 id="title">Problems in HHSOJ</h1>
	<i id="subtitle">Solve them? Impossible! --Zzzyt</i>
	<hr />
	<jsp:include page="nav.jsp?at=problemset"></jsp:include>
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