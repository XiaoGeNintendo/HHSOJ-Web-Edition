<%@ page language="java" contentType="text/html; charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>HHSOJ</title>
	</head>
	<body>
		<!-- Enter Everything here -->
		<center>
			<h1>Welcome to Hell Hole Studios Online Judge!</h1>
			<h2>This OJ was made by XiaoGeNintendo in Hell Hole Studios</h2>
			<hr/>
			<a href="problemset.jsp">-=Problems=-</a>
			<a href="status.jsp">-=Status=-</a>
			<%
				String user=(String)session.getAttribute("username");
			
				if(user!=null){
					out.println("<a href=\"users.jsp?username="+user+"\">-="+user+"=-</a>");
					out.println("<a href=\"logout.jsp\">-=Logout=-</a>");
				}else{
					out.println("<a href=\"login.jsp\">-=Login=-</a>");
					out.println("<a href=\"register.jsp\">-=Register=-</a>");
				}
			%>
			
			<br/>
			<marquee>Welcome to HHSOJ!:P</marquee>
		</center>
		This system is still under developing. Please don't upload any harmful code. Thanks :( <br/>
		
		<a href="verdict.jsp">Verdicts List</a>
	</body>
</html>