<%@page import="com.hhs.xgn.jee.hhsoj.remote.CodeforcesProblem"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.hhs.xgn.jee.hhsoj.db.*,com.hhs.xgn.jee.hhsoj.type.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="index.css" rel="stylesheet" type="text/css">
<title>HHSOJ-<%=request.getParameter("id")%></title>
</head>
<body>
	<%
		request.setCharacterEncoding("utf-8");
	
		boolean ok = true;
		int id = 0;
		try {

			String sid = request.getParameter("id");
			if (sid.startsWith("C")) {
				Problem p = new ProblemHelper().getProblemData(sid);
				response.sendRedirect("vcp.jsp?cid=" + p.getConId() + "&pid=" + p.getConIndex());
				return;
			}
			if(sid.startsWith("R")){
				//Codeforces Problem
				CodeforcesProblem cp=new ProblemHelper().getProblemDataR(sid);
				response.sendRedirect("https://codeforces.com/contest/"+cp.getContestId()+"/problem/"+cp.getIndex());
				return;
			}
			id = Integer.parseInt(request.getParameter("id"));
		} catch (Exception e) {
			out.println("<b>Unknown Problem ID</b><br/>");
			out.println("<a href=\"index.jsp\">Back</a>");
			ok = false;
		}

		if (ok) {

			boolean ok2 = true;
			ProblemHelper ph = new ProblemHelper();
			Problem p = new Problem();
			try {
				p = ph.getProblemData(id);
			} catch (Exception e) {
				out.println("<b>Unknown Problem ID</b><br/>");
				out.println("<a href=\"index.jsp\">Back</a>");
				out.println("<!-- ");
				out.flush();
				e.printStackTrace(response.getWriter());
				out.println("-->");
				ok2 = false;

			}

			if (ok2) {
	%>
	<!-- Default Template -->
	<h1 id="title">HHSOJ Problemset</h1>
	<i id="subtitle"><%=p.getId()%> - <%=p.getName()%></i>
	<hr />
	<jsp:include page="nav.jsp?at=problemset"></jsp:include>

	<center>
		<h1>#<%=p.getId()%> - <%=p.getName()%></h1>
		<p>
			<b>Time Limit Per Test: <%=p.getArg("TL")%> ms
			</b>
		</p>
		<p>
			<b>Memory Limit Per Test: <%=p.getArg("ML")%> KB
			</b>
		</p>

		<a href="submit.jsp?id=<%=p.getId()%>" class="link">Submit</a>
		<a href="status.jsp?probId=<%=p.getId()%>" class="link">Status</a>
		<a href="status.jsp?probId=<%=p.getId()%>&userId=<%=session.getAttribute("username")%>" class="link">My Submission</a>
	</center>

	<div class="seperator"></div>

	<%
		out.println("<!-- Statement -->");
		out.println(new ProblemHelper().getProblemStatement("" + p.getId()));
	%>

	<div class="seperator"></div>

	<center>
		<a href="submit.jsp?id=<%=p.getId()%>" class="link">Submit</a>
		<a href="status.jsp?probId=<%=p.getId()%>" class="link">Status</a>
		<a href="status.jsp?probId=<%=p.getId()%>&userId=<%=session.getAttribute("username")%>" class="link">My Submission</a>
	</center>
	<%
		}
		}
	%>
	
	<div class="seperator"></div>
</body>
</html>