<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.hhs.xgn.jee.hhsoj.db.*,com.hhs.xgn.jee.hhsoj.type.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>

<%
	String cid = "", pid = "";
	Contest c = null;
	Problem p = null;
	try {
		cid = request.getParameter("cid");
		pid = request.getParameter("pid");
		c = new ContestHelper().getContestDataById(cid);

		p = c.getProblem(pid);

		if (p == null) {
			throw new Exception("P is null");
		}
		if (!c.isContestStarted()) {
			response.sendRedirect("contestWelcome.jsp?id=" + cid);
			return;
		}
	} catch (Exception e) {
		out.println("Error!");
		out.println("<!-- " + e + " -->");
		return;
	}

	String fullInfo = "C" + cid + pid;
	//	System.out.println(fullInfo);
%>

<title>HHSOJ-<%="C" + cid + pid%></title>
</head>
<body>

	<!-- Default Template -->
	<h1 id="title">Contest Problems on HHSOJ</h1>
	<i id="subtitle"><%=cid + pid%> - <%=p.getName()%></i>
	<hr />
	<jsp:include page="nav.jsp?at=contests"></jsp:include>

	<center>
		<h1><%=p.getName()%></h1>

		<p>
			<b>Time Limit Per Test: <%=p.getArg("TL")%> ms
			</b>
		</p>
		<p>
			<b>Memory Limit Per Test: <%=p.getArg("ML")%> KB
			</b>
		</p>
		<p>
			<b>Contest status: <%=c.getStatusWithTime()%></b>
		</p>

		<a href="contestWelcome.jsp?id=<%=cid%>" class="link">Contest</a> <a
			href="submit.jsp?id=<%=fullInfo%>" class="link">Submit <abbr
			title="Out of competition">OOC</abbr></a> <a
			href="conSub.jsp?cid=<%=cid%>" class="link">Submit</a> <a
			href="status.jsp?probId=<%=fullInfo%>" class="link">Status</a> <a
			href="status.jsp?probId=<%=fullInfo%>&userId=<%=session.getAttribute("username")%>"
			class="link">My Submission</a>
	</center>

	<div class="seperator"></div>

	<%
		out.println("<!-- Statement -->");
		out.println(new ProblemHelper().getProblemStatement(fullInfo));
	%>
	
	<div class="seperator"></div>
	
	<center>
		<a href="contestWelcome.jsp?id=<%=cid%>" class="link">Contest</a> <a
			href="submit.jsp?id=<%=fullInfo%>" class="link">Submit <abbr
			title="Out of competition">OOC</abbr></a> <a
			href="conSub.jsp?cid=<%=cid%>" class="link">Submit</a> <a
			href="status.jsp?probId=<%=fullInfo%>" class="link">Status</a> <a
			href="status.jsp?probId=<%=fullInfo%>&userId=<%=session.getAttribute("username")%>"
			class="link">My Submission</a>
	</center>
	
	<div class="seperator"></div>
</body>
</html>