<%@page import="com.hhs.xgn.jee.hhsoj.db.AnnouncementReader"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="index.css" rel="stylesheet" type="text/css">
<title>HHSOJ</title>
</head>
<body>
	<!-- Enter Everything here -->
	<h1 id="title">Welcome to Hell Hole Studios Online Judge!</h1>
	<i id="subtitle">This OJ is made by XiaoGeNintendo in Hell Hole
		Studios</i>
	<hr />
	<jsp:include page="nav.jsp?at=index"></jsp:include>
	
	<%
		String marquee=new AnnouncementReader().readAnnouncement();
		if(marquee==null){
			marquee="Welcome to HHSOJ!";
		}
	%>
	<marquee id="marquee"><%=marquee %></marquee>
	This system is still under developing. Please don't upload any harmful
	code. Thanks :(
	<br />

	<a href="verdict.jsp" id="verdict">Verdicts List</a>
	
	<br/>
	<a href="credits.jsp" id="credit">Credits</a>
	
</body>
</html>