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
			Problem p=new ProblemHelper().getProblemData(pid);
			
		%>
		<!-- Default End -->
		
		<a href="set_editProbInfo.jsp?id=<%=pid %>" class="btn"><i class="fa fa-edit"></i>Summary</a>
		<a href="set_editProbFile.jsp?id=<%=pid %>" class="btn"><i class="fa fa-file-archive-o"></i>Files</a>
		<a href="set_editProbTest.jsp?id=<%=pid %>" class="btn btn-primary"><i class="fa fa-code"></i>Tests</a>
		
		<br/>
		
		<input id="add" style="max-width: 1000px; width: 70%;" placeholder="Testset Name">
		<button onclick="add()" class="btn btn-success"><i class="fa fa-plus"></i>New Testset</button>
		
		<div id="accordion">
			<%
				File f=new File(p.getPath());
				for(File sub:f.listFiles()){
					if(sub.isDirectory() && !sub.getName().startsWith("!")){
						String frn=sub.getName().replace(" ","_");
			%>
						<div class="card">
						  <div class="card-header">
						    <a class="card-link" data-toggle="collapse" href="#collapse<%=frn%>">
						      <%=sub.getName() %>
						    </a>
						  </div>
						  <div id="collapse<%=frn %>" class="collapse" data-parent="#accordion">
						    <div class="card-body">
						      <a href="javascript:openEdit('<%=pid %>','<%=sub.getName() %>/newInput','plain')" class="btn btn-success"><i class="fa fa-plus"></i>New Input</a> <br/>
						  <%
						  		for(File input:sub.listFiles()){
						  			if(input.isFile()){
						  				 %>
						  				 <a href="javascript:openEdit('<%=pid %>','<%=sub.getName() %>/<%=input.getName() %>','plain')" class="btn btn-primary"><i class="fa fa-edit"></i><%=input.getName() %></a>
						  				 <a href="javascript:del('<%=pid %>','<%=sub.getName()+"/"+input.getName() %>')" class="btn btn-danger"><i class="fa fa-times"></i>Delete</a> <br/>
						  				 <%
						  			}
						  		}
						  %>
						    </div>
						  </div>
						</div>		
			<%
					}
				}
			%>
		</div>
		
		<script>
		function add(){
			var para={
				"pid":"<%=pid%>",
				"name":document.getElementById("add").value
			}
			
			httpPost("set_addset.jsp",para);
		}
		
		</script>
	</div>
	
</body>
</html>