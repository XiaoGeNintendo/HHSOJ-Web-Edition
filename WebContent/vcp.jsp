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
	String lang=request.getParameter("lang");
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
<div class="container">
	<!-- Default Template -->
	<h1 class="title"><%=c.getInfo().getName() %></h1>
	<i class="subtitle"><%=cid + pid%> - <%=p.getName()%></i>
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
	</center>
	<a href="contestWelcome.jsp?id=<%=cid%>" style="float:left;" class="btn btn-info">Contest</a>
	<a href="submit.jsp?id=<%=fullInfo%>" style="float:left;" class="btn btn-primary">Submit <abbr title="Out of competition">OOC</abbr></a>
	<a href="conSub.jsp?cid=<%=cid%>" style="float:left;" class="btn btn-primary">Submit</a>
	<a href="status.jsp?probId=<%=fullInfo%>" style="float:left;" class="btn btn-secondary">Status</a> 
	<a href="status.jsp?probId=<%=fullInfo%>&userId=<%=session.getAttribute("username")%>" style="float:left;" class="btn btn-secondary">My Submission</a>
	
	<div class="dropdown" style="float:right;">
		<button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="#">Language:<%=(lang==null || lang.equals("null")?"default":lang) %></button>
	     	<div class="dropdown-menu">
	        <%for(String ls:p.getArg("AllLanguage").split(";")){
	        	
	        	String code=ls.split("\\|")[0];
	        	String dis=ls.split("\\|")[1];
	        %>
	        	<a class="dropdown-item" href="?id=<%=p.getId() %>&lang=<%=code%>"><i class="fa <%=(code.equals(lang)?"fa-check":"fa-globe")%>"></i><%=dis %></a>
	        	<%} %>
	    </div>
	</div>

	<div class="card" style="clear:both;">
	<div class="card-body">
	<%
		out.println("<!-- Statement -->");
		out.println(new ProblemHelper().getProblemStatement(fullInfo,lang));
	%>
	</div>
	</div>
	
	<a href="contestWelcome.jsp?id=<%=cid%>" style="float:left;" class="btn btn-info">Contest</a>
	<a href="submit.jsp?id=<%=fullInfo%>" style="float:left;" class="btn btn-primary">Submit <abbr title="Out of competition">OOC</abbr></a>
	<a href="conSub.jsp?cid=<%=cid%>" style="float:left;" class="btn btn-primary">Submit</a>
	<a href="status.jsp?probId=<%=fullInfo%>" style="float:left;" class="btn btn-secondary">Status</a> 
	<a href="status.jsp?probId=<%=fullInfo%>&userId=<%=session.getAttribute("username")%>" style="float:left;" class="btn btn-secondary">My Submission</a>
</div>
</body>
</html>