<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>


<title>HHSOJ - HMS Changer</title>
</head>
<body>
<div class="container">
	<!-- Default Template -->
	<h1 class="title">HHSOJ Tool: HMS Changer</h1>
	<i class="subtitle">It might help you to write contest lengths -- XGN</i>
	<hr />
	
	<jsp:include page="nav.jsp?at=index"></jsp:include>
	
	<!-- Default End -->

	<center>
		<div class="card" style="width:500px;"><div class="card-body">
		<div class="input-group">
			<input class="form-control" id="h" placeholder="Hour">
			<input class="form-control" id="m" placeholder="Minute">
			<input class="form-control" id="s" placeholder="Second">
		</div>
		
		<button class="btn btn-primary" id="submit" onclick="change()">Change me</button> <br/>
		
		<p>Length:</p>
		<p id="out">...</p>
		</div></div>
	</center>
	
	<script>
		function change(){
			var h=document.getElementById("h").value;
			var m=document.getElementById("m").value;
			var s=document.getElementById("s").value;
			document.getElementById("out").innerHTML=((h*3600+m*60+s)*1000)+"ms";
			
		}
	</script>
</div>
</body>
</html>