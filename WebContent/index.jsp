<%@page import="com.hhs.xgn.jee.hhsoj.db.AnnouncementReader"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
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
	<marquee id="marquee"><p><%=marquee %></p></marquee>
	<p>This system is still under developing. Please don't upload any harmful
	code. Thanks :(</p>
	<br />
	<a href="verdict.jsp" id="verdict">Verdicts List</a>
	<br/>
	<a href="credits.jsp" id="credit">Credits</a>
	<br/>
	<a href="richtextEditor.jsp" id="richtext">Online Rich Text Editor</a>
	<br/>
	<a href="TimeChanger.jsp" id="timeChanger">Online Timestamp Changer</a>
	<br/>
	<a href="HMSChanger.jsp" id="hms">Online HMS to ms Changer</a>
	<br/>
	<%
		if(System.getProperty("os.name").toLowerCase().indexOf("linux")>=0){	
	%>
			<abbr title="Secure Judging,Widely Used"><p class="fa fa-linux">Now running on Linux</p></abbr>
	<%
		}else{
	%>
			<abbr title="Original Version,Easy Testing"><p class="fa fa-windows">Now running on Windows</p></abbr>
	<%
		}
	%>
</body>
</html>