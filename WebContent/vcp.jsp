<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hhs.xgn.jee.hhsoj.db.*,com.hhs.xgn.jee.hhsoj.type.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="index.css" rel="stylesheet" type="text/css">
<%
	String cid="",pid="";
	Contest c=null;
	Problem p=null;
	try{
		 cid=request.getParameter("cid");
		 pid=request.getParameter("pid");
		 c=new ContestHelper().getContestDataById(cid);
		
		 p=c.getProblem(pid);
		
		if(p==null){
			throw new Exception("P is null");
		}
		if(!c.isContestStarted()){
			response.sendRedirect("contestWelcome.jsp?id="+cid);
			return;
		}
	}catch(Exception e){
		out.println("Error!");
		out.println("<!-- "+e+" -->");
		return;
	}
	
	
	String fullInfo="C"+cid+pid;
//	System.out.println(fullInfo);
%>

<title>HHSOJ-<%="C"+cid+pid %></title>
</head>
<body>
		
				<!-- Default Template -->
				<h1 id="title">Contest Problems on HHSOJ</h1>
				<i id="subtitle"><%=cid+pid %> - <%=p.getName() %></i>
				<hr />
				<jsp:include page="nav.jsp?at=contests"></jsp:include>
				
				<center>
					<h1><%=p.getName() %> on HHSOJ</h1>
					<b>Time Limit Per Test:<%=p.getArg("TL") %>MS</b> <br/>
					<b>Memory Limit Per Test:<%=p.getArg("ML")%>KB</b> <br/>
					<b>Contest status: <%=c.getStatusWithTime() %></b> <br/>
					<a href="contestWelcome.jsp?id=<%=cid %>">→Contest←</a>
					<a href="conSub.jsp?cid=<%=cid %>">→Submit←</a>
					<a href="status.jsp?probId=<%=fullInfo %>">→Status←</a>
					<a href="status.jsp?probId=<%=fullInfo %>&userId=<%=session.getAttribute("username") %>">→My Submission←</a>
				</center>
				
				<%
				out.println("<!-- Statement -->");
				out.println(new ProblemHelper().getProblemStatement(fullInfo)); 
				%>
				
				<center>
					<a href="contestWelcome.jsp?id=<%=cid %>">→Contest←</a>
					<a href="conSub.jsp?cid=<%=cid %>">→Submit←</a>
					<a href="status.jsp?probId=<%=fullInfo %>">→Status←</a>
					<a href="status.jsp?probId=<%=fullInfo %>&userId=<%=session.getAttribute("username") %>">→My Submission←</a>
				</center>

</body>
</html>