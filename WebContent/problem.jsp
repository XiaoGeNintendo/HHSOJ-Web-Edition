<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hhs.xgn.jee.hhsoj.db.*,com.hhs.xgn.jee.hhsoj.type.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="index.css" rel="stylesheet" type="text/css">
<title>HHSOJ-<%=request.getParameter("id") %></title>
</head>
<body>
	<%
		boolean ok=true;
		int id=0;
		try{
			id=Integer.parseInt(request.getParameter("id"));
		}catch(Exception e){
			out.println("<b>Unknown Problem ID</b><br/>");
			out.println("<a href=\"index.jsp\">Back</a>");
			ok=false;
		}
		
		if(ok){
			
			boolean ok2=true;
			ProblemHelper ph=new ProblemHelper();
			Problem p=new Problem();
			try{
				p=ph.getProblemData(id);
			}catch(Exception e){
				out.println("<b>Unknown Problem ID</b><br/>");
				out.println("<a href=\"index.jsp\">Back</a>");
				out.println("<!-- ");
				out.flush();
				e.printStackTrace(response.getWriter());
				out.println("-->");
				ok2=false;
				
			}
			
			
			if(ok2){
			
	%>	
				<!-- Default Template -->
				<h1 id="title">Problems on HHSOJ</h1>
				<i id="subtitle"><%=p.getId() %> - <%=p.getName() %></i>
				<hr />
				<jsp:include page="nav.jsp?at=problemset"></jsp:include>
				
				<center>
					<h1><%=p.getName() %> on HHSOJ</h1>
					<b>Time Limit Per Test:<%=p.getArg("TL") %>MS</b> <br/>
					<b>Memory Limit Per Test:<%=p.getArg("ML")%>KB</b> <br/>
					
					<a href="submit.jsp?id=<%=p.getId() %>">→Submit←</a>
					<a href="status.jsp?probId=<%=p.getId() %>">→Status←</a>
					<a href="status.jsp?probId=<%=p.getId() %>&userId=<%=session.getAttribute("username") %>">→My Submission←</a>
				</center>
				
				
				
				<jsp:include page="statement.jsp?id=<%=p.getId() %>" ></jsp:include>
				
				<center>
					<a href="submit.jsp?id=<%=p.getId() %>">→Submit←</a>
					<a href="status.jsp?probId=<%=p.getId() %>">→Status←</a>
					<a href="status.jsp?probId=<%=p.getId() %>&userId=<%=session.getAttribute("username") %>">→My Submission←</a>
				</center>
	<%
			}
		}
		
	%>
</body>
</html>