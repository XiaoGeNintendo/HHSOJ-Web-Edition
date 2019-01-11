<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>


<title>HHSOJ - Richtext Editor</title>
</head>
<body>
	<!-- Default Template -->
	<h1 id="title">HHSOJ Tool: Rich text editor</h1>
	<i id="subtitle">It might help you to write problem statements -- XGN</i>
	<hr />
	
	<jsp:include page="nav.jsp?at=index"></jsp:include>
	
	<!-- Default End -->

	<script type="text/javascript" src="js/wangEditor.js"></script>
	
	<div id="in"></div>

	<br />

	<center>
		<button id="submit">Change to HTML</button> <br/>
		<textarea id="out" rows="30" cols="120"></textarea>
	</center>
	
	
	
	<script>
		//Add editor
		var E = window.wangEditor
		var editor2 = new E('#in')
		editor2.create()
		
		//Add button event
		document.getElementById("submit").addEventListener("click", function() {
			//Change into html
			document.getElementById("out").innerHTML=editor2.txt.html();
		})
	</script>
</body>
</html>