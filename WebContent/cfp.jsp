<%@page import="com.hhs.xgn.jee.hhsoj.remote.CodeforcesProblem"%>
<%@page import="com.hhs.xgn.jee.hhsoj.remote.CodeforcesHelper"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.hhs.xgn.jee.hhsoj.db.*,com.hhs.xgn.jee.hhsoj.type.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>


    <meta http-equiv="content-type" content="text/html; charset=UTF-8">

    <!--CombineResourcesFilter-->
    
    <link rel="stylesheet" href="cf/cf_style.css" type="text/css" charset="utf-8" />

	<jsp:include page="head.jsp"></jsp:include>

<%
	String sid=null;
	try{
		sid=request.getParameter("id");
		if(!sid.startsWith("R")){
			response.sendRedirect("problem.jsp?id="+sid);
			return;
		}
		
		if(!new ConfigLoader().load().isEnableRemoteJudge()){
			out.println("Remote Judge is not opened by the admin");
			return;
		}
	}catch(Exception e){
		out.println("Unknown Problem ID");
		out.println("<!-- "+e+" -->");
		return;	
	}

	CodeforcesProblem cp=null;
	try{
		cp=CodeforcesHelper.getCodeforcesProblem(sid.substring(1));
		
		if(cp==null){
			throw new Exception("Unexpected null");
		}
	}catch(Exception e){
		out.println("Unknown Problem ID for this stuff");
		out.println("<!-- "+e+" -->");
		return;		
	}
	
%>

<title>HHSOJ-<%="R" + cp.getContestId() + cp.getIndex()%></title>
</head>
<body>

	<!-- Default Template -->
	<h1 id="title">Codeforces Problems on HHSOJ</h1>
	<i id="subtitle"><%=cp.getContestId() + cp.getIndex()%> - <%=cp.getName()%></i>
	<hr />
	<jsp:include page="nav.jsp?at=problemset"></jsp:include>

	<center>
		<a href="submit.jsp?id=<%=sid%>" class="link">Submit</a>
		<a href="status.jsp?probId=<%=sid%>" class="link">Status</a>
		<a href="status.jsp?probId=<%=sid%>&userId=<%=session.getAttribute("username")%>" class="link">My Submission</a>
	</center>

	<div class="seperator"></div>

	<%
		out.println("<!-- Statement -->");
		out.println(CodeforcesHelper.getProblemStatement(cp));
	%>
	
	<div class="seperator"></div>
	
	<center>
		<a href="submit.jsp?id=<%=sid%>" class="link">Submit</a>
		<a href="status.jsp?probId=<%=sid%>" class="link">Status</a>
		<a href="status.jsp?probId=<%=sid%>&userId=<%=session.getAttribute("username")%>" class="link">My Submission</a>
	</center>
	
	<div class="seperator"></div>
</body>
</html>