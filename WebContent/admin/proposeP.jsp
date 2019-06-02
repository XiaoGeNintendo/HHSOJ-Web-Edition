<%@page import="com.hhs.xgn.jee.hhsoj.db.Templater"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.FileHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ProblemHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Problem"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ConfigLoader"%>
<%@page import="com.hhs.xgn.jee.hhsoj.judger.TaskQueue"%>
<%@page import="com.hhs.xgn.jee.hhsoj.judger.JudgingThread"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>HHSOJ - Admin Problem Edit</title>
<jsp:include page="../head.jsp"></jsp:include>
</head>
<body>
	<%
		Problem p=null;
		try{
			boolean in=(Boolean)session.getAttribute("admin");
			if(!in){
				return;
			}
			

			String id=request.getParameter("id");
			id.charAt(0); //null check
			
			p=new ProblemHelper().getProblemData(id);
			p.getId(); //null check
		}catch(Exception e){
			out.println("<!-- "+e+" -->");
			return;
		}
		
	%>
	<h1>Problem Edit</h1>
	<hr/>
	
	<%
		
	%>
	
	<!-- To load arg.txt -->
	<%=Templater.loadTemplate("arg.txt",p)%>
	
	<!-- To load all statements -->
	<%
		for(String ls:p.getArg("AllLanguage").split(";")){
			out.println(Templater.loadTemplate(p.getArg("Statement_"+ls.split("\\|")[0]),p));
		}
	%>
	
	
</body>
</html>