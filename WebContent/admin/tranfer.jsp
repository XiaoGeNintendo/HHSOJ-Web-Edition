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
<title>HHSOJ - Admin Tranfer File Platform</title>
<jsp:include page="../head.jsp"></jsp:include>
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
	%>
	<h1>Admin Transfer Platform</h1>
	<i>While downloading, please do not shutdown the server!</i>
	<hr/>
	<h2>Add a new download task</h2>
	From URL:<input id="n1">
	To Position:<input id="n2" value="<%=ConfigLoader.getPath() %>">
	<button onclick="start()">Start!</button>
	<hr/>
	<table border="1" width="80%" id="bala">
		<tr>
			<th width="30%">From URL</th>
			<th width="30%">To Position</th>
			<th width="20%">Date</th>
			<th width="10%">Status</th>
			<th width="10%">Speed</th>
		</tr>	
	</table>
	
	<script>
		function start(){
			$.post("dotransfer.jsp",{from:$("#n1").value,to:$("#n2").value},function(data,status){
				alert("result:\n"+data+" "+status);
			});
		}
		
		function poll(){
			$.get("gettransfer.jsp",function(data,status){
				document.getElementById("bala").innerHTML=data;
				setTimeout(poll,1000);	
			});
			
		}
		poll();
	</script>
</body>
</html>