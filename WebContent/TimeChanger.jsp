<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>


<title>HHSOJ - Time Changer</title>
</head>
<body>
<div class="container">
	<!-- Default Template -->
	<h1 class="title">HHSOJ Tool: Time Changer</h1>
	<i class="subtitle">It might help you to write contest timetables -- XGN</i>
	<hr />
	
	<jsp:include page="nav.jsp?at=index"></jsp:include>
	
	<!-- Default End -->

	<center>
	<div class="card" style="width:600px;"><div class="card-body">
		<i>Note that if you are using Firefox or IE, this page may have some problem</i> <br/>
		
		Date:<input id="a" type="datetime-local" />
		<br/>
		
		<button class="btn" id="submit" onclick="change()">Change me</button> <br/>
		
		Time stamp:<p id="out">...</p>
	</div></div>
	</center>
	
	<script>
		function change(){
			var x=document.getElementById("a").value;
			var d=new Date(x);
			document.getElementById("out").innerHTML=d+"<br/>"+d.getTime();
		}
	</script>
</div>
</body>
</html>