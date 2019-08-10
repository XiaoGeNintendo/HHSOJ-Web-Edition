<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>
<title>HHSOJ - Richtext Editor</title>
<style type="text/css">
.w-e-text-container {
	background: #ffffff;
	height: 400px;
}
</style>
</head>
<body>
<div class="container">
	<!-- Default Template -->
	<h1 class="title">HHSOJ Tool: Rich text editor</h1>
	<i class="subtitle">It might help you to write problem statements -- XGN</i>
	<hr />
	
	<jsp:include page="nav.jsp?at=index"></jsp:include>
	
	<!-- Default End -->
	
	<div id="div-content"></div>

	<br/>

	<center>
		<button class="btn btn-primary" id="submit">Change to HTML</button>
		<br/><br/>
		<textarea style="font-family:Consolas;" id="out" rows="10" cols="120"></textarea>
	</center>
	
	<script>
		//Add editor
		var E = window.wangEditor
		var editor2 = new E('#div-content')
		editor2.create()
		
		//Add button event
		document.getElementById("submit").addEventListener("click", function() {
			//Change into html
			document.getElementById("out").innerHTML=editor2.txt.html();
		})
	</script>
</div>
</body>
</html>