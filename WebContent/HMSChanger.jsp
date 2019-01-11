<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>


<title>HHSOJ - HMS Changer</title>
</head>
<body>
	<!-- Default Template -->
	<h1 id="title">HHSOJ Tool: HMS Changer</h1>
	<i id="subtitle">It might help you to write contest lengths -- XGN</i>
	<hr />
	
	<jsp:include page="nav.jsp?at=index"></jsp:include>
	
	<!-- Default End -->

	<center>
		
		<input id="h" value="0">h<input id="m" value="0">m<input id="s" value="0">s
		
		<br/>
		
		<button id="submit" onclick="change()">Change me</button> <br/>
		
		Length:<p id="out">...</p>
		
	</center>
	
	<script>
		function change(){
			var h=document.getElementById("h").value;
			var m=document.getElementById("m").value;
			var s=document.getElementById("s").value;
			document.getElementById("out").innerHTML=((h*3600+m*60+s)*1000)+"ms";
			
		}
	</script>
</body>
</html>