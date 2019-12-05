<%@page import="java.io.File"%>
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
			Problem p=null;
			
			try{
				p=new ProblemHelper().getProblemData(pid);
				if(p==null){
					throw new Exception();
				}
			}catch(Exception e){
				out.println("No such problem");
				return;
			}
		%>
		<!-- Default End -->
		
		<a href="set_editProbInfo.jsp?id=<%=pid %>" class="btn"><i class="fa fa-edit"></i>Summary</a>
		<a href="set_editProbFile.jsp?id=<%=pid %>" class="btn btn-primary"><i class="fa fa-file-archive-o"></i>Files</a>
		<a href="set_editProbTest.jsp?id=<%=pid %>" class="btn"><i class="fa fa-code"></i>Tests</a>
		
		<br/>
			<center>
				<a href="javascript:openEdit('<%=pid %>','newFile','plain')" class="btn btn-success"><i class="fa fa-plus"></i>New File</a> <br/>
			</center>
			
			<%
				File f=new File(p.getPath());
				for(File sub:f.listFiles()){
					if(!sub.isDirectory()){	
						int expos=sub.getName().lastIndexOf('.');
						String extension=(expos==-1?"":sub.getName().substring(expos+1));
			%>
						<a href="javascript:del('<%=pid %>','<%=sub.getName()%>')" class="btn btn-danger"><i class="fa fa-times"></i>Delete</a>
			<%
			
						if(extension.equalsIgnoreCase("EXE") || extension.isEmpty()){
			%>
					<a href="#" class="btn btn-primary disabled"><i class="fa fa-times"></i><%=sub.getName() %></a> <br/>
			<%continue;
							
						}
						if(extension.equalsIgnoreCase("html") ||extension.equalsIgnoreCase("htm")){
			%>
					<a href="javascript:openEdit('<%=pid%>','<%=sub.getName() %>','html')" class="btn btn-primary"><i class="fa fa-globe"></i><%=sub.getName() %></a> <br/>
			<%continue;
						}
						if(extension.equalsIgnoreCase("cpp") ||extension.equalsIgnoreCase("c") || extension.equalsIgnoreCase("h")){
			%>
					<a href="javascript:openEdit('<%=pid%>','<%=sub.getName() %>','c_cpp')" class="btn btn-primary"><i class="fa fa-file-code-o"></i><%=sub.getName() %></a> <br/>
			<%continue;
						}
						if(extension.equalsIgnoreCase("java")){
			%>
					<a href="javascript:openEdit('<%=pid%>','<%=sub.getName() %>','java')" class="btn btn-primary"><i class="fa fa-file-code-o"></i><%=sub.getName() %></a> <br/>
			<%continue;
						}
			%>
						<a href="javascript:openEdit('<%=pid%>','<%=sub.getName() %>','plain')" class="btn btn-primary"><i class="fa fa-edit"></i><%=sub.getName() %></a> <br/>
			<%
					}
				}
			%>
			
		
		
	</div>
</body>
</html>