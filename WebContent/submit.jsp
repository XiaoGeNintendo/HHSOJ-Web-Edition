<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="index.css" rel="stylesheet" type="text/css">
<title>HHSOJ-Submit</title>
</head>
<body>

	<%
		String s = (String) session.getAttribute("username");
		if (s == null || s.equals("")) {
			response.sendRedirect("login.jsp?type=submit");
		} else {
	%>


	<script>
		function callsubmit() {
			//alert('I am running'+this.document);
			var prob = this.document.getElementsByName('probid')[0].value;
			var code = this.document.getElementsByName('code')[0].value;
			var lang = this.document.forms['submit']['lang'].value;

			if (lang == undefined) {
				alert('Using an out-dated explorer is prohibited!!!! Why don\'t you use a new explorer??');
				return false;
			}
			//alert(lang);

			if (prob == null || prob == ("")) {
				alert('Problem ID should be filled out.');
				return false;
			}
			if (code == null || code == ("")) {
				alert('Code should not be empty');
				return false;
			}
			if (code.length > 65536) {
				alert('Code length should be at most 65536 bytes')
				return false;
			}
			if (lang == null || lang == ("")) {
				alert('Please choose a language');
				return false;
			}

		}

		function call() {
			//Send a request to find out the testsets
			var xmlhttp;
			if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
				xmlhttp = new XMLHttpRequest();
			} else {// code for IE6, IE5
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
			}
			xmlhttp.onreadystatechange = function() {
				if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
					document.getElementById("testset").innerHTML = xmlhttp.responseText;
				}
			}

			var href = window.location.href;
			href = href.slice(0, href.lastIndexOf("/"));
			xmlhttp.open("GET", href + "/api/testset.jsp?id="
					+ document.getElementById("pid").value, true);
			xmlhttp.send();
		}
	</script>

	<!-- Default Template -->
	<h1 id="title">Submit!</h1>
	<i id="subtitle">Give out my answer! -- Phoenix Wright</i>
	<hr />
	<jsp:include page="nav.jsp?at=submit"></jsp:include>

	<%
		String userLooking = (String) session.getAttribute("username");
	%>
	<!-- Default End-->


	<center>

		<form name="submit" action="dosubmit.jsp"
			onsubmit="return callsubmit()" method="post">
			<p>
				Problem: <input type="text" id="pid" name="probid" onkeyup="call()"
					value="<%=(request.getParameter("id") == null ? "" : request.getParameter("id"))%>">
			</p>

			<p>
				Language: <input type="radio" name="lang" value="java"> <acronym
					title="Java1.8.0 : Name your class 'Program' and don't place it in a package!">Java</acronym>
				<input type="radio" name="lang" value="cpp"> <acronym
					title="C++11 : Don't upload harmful code thx :(">C++</acronym> <input
					type="radio" name="lang" value="python"> <acronym
					title="Python 3.6 : A short and powerful language">Python</acronym>
			<p>
			<p>
				Testsets: <select id="testset" name="testset">
					<option value="tests">No testsets...</option>
				</select>
			</p>

			<br />
			<p>Code:</p>

			<textarea name="code" cols="70" rows="20" id="code"
				style="width: 80%; max-width:800px;"></textarea>
			<br /> <input type="submit" name="submit" value="Submit"
				style="height: 30px; width: 100px;">
		</form>
	</center>
	<br/>
	<hr />


	<pre>
Use "C"+contestId+index to submit problems that are in the contest.
For example, "C1A" means the problem A in the contest id=1.
This is for practise only. To submit during an active contest, please use the Contest Submit System. 

User "R"+contestId+index to submit a Codeforces problem.
For example, "R1A" means submitting to "Theater Square".
Notice that if the admin doesn't allow remote judge, then you can't submit.

For Java users:
  Our java version is 1.8.0.
  You should name your class "Program" and set it public.
  Don't put your code in a package,If you get "Judgement Failed",please check if you put the code into a package.
  And more, don't use stuff like "System.exit(0)" to terminal your program,Otherwise a "Runtime Error" may be raised. 
		</pre>

	<script>
		call()
	</script>
	<%
		}
	%>
</body>
</html>