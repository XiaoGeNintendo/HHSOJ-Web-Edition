<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>


<title>HHSOJ - Time Changer</title>
</head>
<body>
	<!-- Default Template -->
	<h1 id="title">HHSOJ Tool: Time Changer</h1>
	<i id="subtitle">It might help you to write contest timetables -- XGN</i>
	<hr />
	
	<jsp:include page="nav.jsp?at=index"></jsp:include>
	
	<!-- Default End -->

	<center>
		<i>Note that if you are using Firefox or IE, this page may have some problem</i> <br/>
		
		Date:<input id="a" type="datetime-local" />
		<br/>
		
		<button id="submit" onclick="change()">Change me</button> <br/>
		
		Time stamp:<p id="out">...</p>
		
	</center>
	
	<script>
		function change(){
			var x=document.getElementById("a").value;
			var d=new Date(x);
			document.getElementById("out").innerHTML=d+"<br/>"+d.getTime();
		}
	</script>
</body>
</html>