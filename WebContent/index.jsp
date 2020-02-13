<%@page import="com.hhs.xgn.jee.hhsoj.db.AnnouncementReader"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<jsp:include page="head.jsp"></jsp:include>
<title>HHSOJ</title>
</head>
<body>
	<!-- Enter Everything here -->

	<div class="container">
		<h1 class="title">
			<img src="asset/favicon/favicon128x.png"
				style="height: 50px; width: 50px; margin-right: 10px;"
				class="oj-icon"> Welcome to HellOJ!
		</h1>
		<i class="subtitle">This OJ is made by Hell Hole Studios</i>
		<hr />
		<jsp:include page="nav.jsp?at=index"></jsp:include>

		<%
			String marquee = new AnnouncementReader().readAnnouncement();
			if (marquee == null) {
				marquee = "Welcome to HHSOJ!";
			}
		%>
		<marquee id="marquee">
			<p><%=marquee%></p>
		</marquee>
		<p>This system is still under developing. Please don't upload any
			harmful code. Thanks :(</p>
		<a href="https://github.com/XiaoGeNintendo/HHSOJ-Essential">Also try HHSOJ Essential!</a>
		<br /> <br />


		<div class="card">
			<div class="card-header">
				<a class="card-link" data-toggle="collapse" href="#collapseOne">
					HHSOJ Tools </a>
			</div>
			<div id="collapseOne" class="collapse" data-parent="#accordion">
				<div class="card-body">
					<a href="verdict.jsp" id="verdict">Verdicts List</a> <br /> <a
						href="credits.jsp" id="credit">Credits</a> <br /> <a
						href="richtextEditor.jsp" id="richtext">Online Rich Text
						Editor</a> <br /> <a href="TimeChanger.jsp" id="timeChanger">Online
						Timestamp Changer</a> <br /> <a href="HMSChanger.jsp" id="hms">Online
						HMS to ms Changer</a> <br /> <a href="userSearch.jsp" id="us">User
						Search</a> <br /> <a href="customSubmit.jsp" id="cs">Custom 
						Submit</a>
				</div>
			</div>
		</div>



		<br />
		<%
			if (System.getProperty("os.name").toLowerCase().indexOf("linux") >= 0) {
		%>
		<p style="font-size: 20px;">
			<i class="fa fa-linux"></i>Now running on Linux <abbr
				title="Secure judging for servers"><i
				class="	fa fa-info-circle"></i></abbr>
		</p>
		<%
			} else if (System.getProperty("os.name").toLowerCase().indexOf("win") >= 0) {
		%>
		<p style="font-size: 20px;">
			<i class="fa fa-windows"></i> Now running on Windows <abbr
				title="Original version, easy to debug"><i
				class="	fa fa-info-circle"></i></abbr>
		</p>
		<%
			} else {
		%>
		<p style="font-size: 20px;">
			<i class="fa fa-question"></i> Now running on other OS <abbr
				title="Does not guarantee all functions working"> <i
				class="fa fa-info-circle"></i></abbr>
		</p>
		<%
			}
		%>
	</div>
</body>
</html>