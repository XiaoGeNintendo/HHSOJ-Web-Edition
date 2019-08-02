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
#code{
    margin: auto;
    width: 60%;
    height: 500px;
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
			String file=request.getParameter("file");
			String mode=request.getParameter("mode");
			if(file==null || mode==null){
				out.println("Access denied");
				return;
			}
		%>
		<!-- Default End -->
		<center>
			<i>Editing File:</i><input id="name" value="<%=file %>" />
			<div id="code">Loading File Content...</div>
			
			<button onclick="save()" class="btn btn-primary"><i class="fa fa-save"></i>Save</button>
			<p id="info"></p>
		</center>
		
		
	</div>
	
	<script>
	   // Init the code editor
	   var editor = ace.edit("code");
	   editor.setTheme("ace/theme/<%=u.getPreference().get("editorTheme").value%>");
	   editor.session.setMode("ace/mode/<%=mode%>");
	   document.getElementById('code').style.fontSize='<%=u.getPreference().get("fontSize").value%>';
	
	   if(<%=u.getPreference().get("autoComplete").value.equals("Yes")%>){
	   	ace.require("ace/ext/language_tools");
	   	
	   	editor.setOptions({
	   	    enableBasicAutocompletion: true,
	           enableSnippets: true,
	           enableLiveAutocompletion: true
	   	});
	   }
	   
	   //load the content
	   $.post("set_api.jsp",{file:"<%=file%>"},function(data,status){
		   editor.setValue(data.trim());
	   });
	   
	   function save(){
		   document.getElementById("info").innerHTML="Save Failed.Retrying";
		   $.post("set_save.jsp",{file:document.getElementById("name").value,data:editor.getValue()},function(data,status){
			   if(status=="success"){
				   document.getElementById("info").innerHTML=data.trim();
			   }
		   })
		   
		   
	   }
	   
    </script>
</body>
</html>