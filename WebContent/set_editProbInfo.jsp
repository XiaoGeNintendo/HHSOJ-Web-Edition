<%@page import="com.hhs.xgn.jee.hhsoj.type.Problem"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ProblemHelper"%>
<%@page import="org.eclipse.jdt.internal.compiler.lookup.ProblemMethodBinding"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>
<script src="js/setter.js"></script>
<title>HHSOJ-Problemsetter Menu</title>
<style type="text/css">
.w-e-text-container {
	background: #ffffff;
	height: 400px;
}
</style>
</head>
<body>
	<div class="container">
		<!-- Default Template -->
		<h1 class="title">Problemsetter Menu</h1>
		<i class="subtitle">Ninja Setters! -- HackerEarth</i>
		<hr />

		<jsp:include page="nav.jsp?at=problemset"></jsp:include>
		<%
			String userLooking = (String) session.getAttribute("username");
			if (userLooking == null) {
				out.println("Please login to continue");
				return;
			}
			Users u=new UserHelper().getUserInfo(userLooking);
			if(!u.isSetter()){
				out.println("Access denied");
				return;
			}
			String pid=request.getParameter("id");
			if(pid==null){
				out.println("No such problem");
				return;
			}
			Problem p=new ProblemHelper().getProblemData(pid);
			
		%>
		<!-- Default End -->
		
		<a href="set_editProbInfo.jsp?id=<%=pid %>" class="btn btn-primary"><i class="fa fa-edit"></i>Summary</a>
		<a href="set_editProbFile.jsp?id=<%=pid %>" class="btn"><i class="fa fa-file-archive-o"></i>Files</a>
		<a href="set_editProbTest.jsp?id=<%=pid %>" class="btn"><i class="fa fa-code"></i>Tests</a>
		
		<br/>
		<center>
			<a href="javascript:openEdit('<%=pid%>','arg.txt','plain')" class="btn btn-primary"><i class="fa fa-edit"></i>Edit arg.txt</a>
		</center>
		
	</div>
</body>
</html>