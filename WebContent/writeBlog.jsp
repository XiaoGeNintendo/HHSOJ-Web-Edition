<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="index.css" rel="stylesheet" type="text/css">
<title>HHSOJ-Wring a new blog</title>
</head>
<body>

	<!-- Default Template -->
	<h1 id="title">Writing a new blog on HHSOJ</h1>
	<i id="subtitle">I have to poop for 15 minutes -- CF User</i>
	<hr />
	<div id="nav">
		<a href="index.jsp" class="nav-link-left">Home</a> <a
			href="problemset.jsp" class="nav-link-left">Problems</a> <a
			href="status.jsp" class="nav-link-left">Status</a> <a
			href="submit.jsp" class="nav-link-left">Submit</a> <a
			href="blogs.jsp" class="nav-link-left selected">Community</a>
		<%
			String userLooking = (String) session.getAttribute("username");
			if (userLooking != null && !userLooking.equals("")) {
		%>
		<a href="users.jsp?username=<%=userLooking%>" class="nav-link-right"><%=userLooking%></a>
		<a href="logout.jsp" class="nav-link-right">Logout</a>
		<%
			} else {
				response.sendRedirect("index.jsp");
			}
		%>
	</div>
	<div id="seperator"></div>
	<br />
	<!-- Default End -->

	<script type="text/javascript" src="js/wangEditor.js"></script>

	<b>Now logging in as <%=userLooking%></b>
	<br />
	<center>
		Title:<input type="text" width="50%" id="inpt"/> <br /> <br />
	</center>

	<div id="div1"></div>

	<br />

	<center>
		<button id="submit">Finish</button>
	</center>
	
	<script>
		//Post function
		function httpPost(URL, PARAMS) {
			var temp = document.createElement("form");
			temp.action = URL;
			temp.method = "post";
			temp.style.display = "none";

			for ( var x in PARAMS) {
				var opt = document.createElement("textarea");
				opt.name = x;
				opt.value = PARAMS[x];
				temp.appendChild(opt);
			}

			document.body.appendChild(temp);
			temp.submit();

			return temp;
		}
		
		//Add editor
		var E = window.wangEditor
		var editor2 = new E('#div1')
		editor2.create()

		//Add action

		document.getElementById("submit").addEventListener("click", function() {
			//Send a post request
			var para={
				"html":editor2.txt.html(),
				"title":document.getElementById("inpt").value
			}
			
			httpPost("doWriteBlog.jsp",para);
		})
	</script>


</body>
</html>