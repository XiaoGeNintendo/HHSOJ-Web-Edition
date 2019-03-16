<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<jsp:include page="head.jsp"></jsp:include>
<title>HHSOJ</title>
</head>
<body>
	<!-- Enter Everything here -->
	
	<h1 id="title">
	<img src="asset/favicon/favicon128x.png" style="height:50px;width:50px;margin-right:10px;" class="oj-icon">
	Welcome to HellOJ!
	</h1>
	<i id="subtitle">This OJ is made by XiaoGeNintendo in Hell Hole
		Studios</i>
	<hr />
	<jsp:include page="nav.jsp?at=index"></jsp:include>
	
</body>
</html>