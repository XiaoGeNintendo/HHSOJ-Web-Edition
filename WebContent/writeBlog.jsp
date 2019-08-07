<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>

<title>HHSOJ - Writing a new blog</title>
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
		<h1 class="title">Writing a new blog on HHSOJ</h1>
		<i class="subtitle">I have to poop for 15 minutes -- CF User</i>
		<hr />

		<jsp:include page="nav.jsp?at=blogs"></jsp:include>
		<%
			String userLooking = (String) session.getAttribute("username");
			if (userLooking == null) {
				out.println("Please login to continue");
				return;
			}
		%>
		<!-- Default End -->

		<p>
			<i>( Now logging in as <%=userLooking%> )
			</i>
		</p>
		<br />

		<p>
			<input type="text" class="form-control" placeholder="Title" id="inpt"/>
		</p>
		<br />

		<div id="div-content"></div>

		<br />

		<center>
			<button type="button" id="submit" class="btn btn-primary" style="width:100px;">Post</button>
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
			var editor2 = new E('#div-content')
			editor2.create()

			//Add action

			document.getElementById("submit").addEventListener("click",
					function() {
						//Send a post request
						var para = {
							"html" : editor2.txt.html(),
							"title" : document.getElementById("inpt").value
						}

						httpPost("doWriteBlog.jsp", para);
					})
		</script>

	</div>
</body>
</html>