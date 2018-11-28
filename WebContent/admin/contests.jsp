<%@page import="com.hhs.xgn.jee.hhsoj.db.ContestHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Contest"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.SubmissionHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Submission"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>HHSOJ - Admin Platform</title>
</head>
<body>
	<%
	try{
		boolean in=(Boolean)session.getAttribute("admin");
		if(!in){
			return;
		}
	}catch(Exception e){
		out.println("<!-- "+e+" -->");
		return;
	}
		ArrayList<Contest> con=new ContestHelper().getAllContests();
		for(Contest c:con){
			out.println("<b>Contest #"+c.getId()+"</b> - "+c.getInfo().getName()+" - "+c.getStatusWithTime());
			out.println("<a href=\"sys.jsp?id="+c.getId()+"\">Run system test</a> ");
			out.println("<a href=\"pr.jsp?id="+c.getId()+"\">Pend Rating Change</a>");
			out.println("<br/>");
		}
		
	%>
</body>
</html>