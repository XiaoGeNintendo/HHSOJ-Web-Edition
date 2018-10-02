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
			if(code.length >65536){
 				alert('Code length should be at most 65536 bytes')
 				return false;
 			}
			if (lang == null || lang == ("")) {
				alert('Please choose a language');
				return false;
			}

		}
	</script>

	<!-- Default Template -->
	<h1 id="title">Submit!</h1>
	<i id="subtitle">Give out my answer! -- Phoenix Wright</i>
	<hr />
	<div id="nav">
		<a href="index.jsp" class="nav-link-left">Home</a> 
		<a href="problemset.jsp" class="nav-link-left">Problems</a> 
		<a href="status.jsp" class="nav-link-left">Status</a> 
		<a href="submit.jsp" class="nav-link-left  selected">Submit</a> 
		<a href="users.jsp?username=<%=s %>" class="nav-link-right"><%=s %></a>
		<a href="logout.jsp" class="nav-link-right">Logout</a> 
	</div>
	<div id="seperator"></div>
	<br />
	<!-- Default End -->
	
	<center>

		<form name="submit" action="dosubmit.jsp"
			onsubmit="return callsubmit()" method="post">
			Problem:<input type="text" name="probid"
				value="<%=(request.getParameter("id") == null ? "" : request.getParameter("id"))%>">
			<br /> Code: <br />
			<textarea name="code" cols="70" rows="40" id="code"></textarea>
			<br /> Language:
			<input type="radio" name="lang" value="java">
 			<acronym title="Java1.8.0 : Name your class 'Program' and don't place it in a package!">Java</acronym>
 			<input type="radio" name="lang" value="cpp">
 			<acronym title="C++11 : Runs slowly and plz don't write harmful code">C++</acronym>
 			<input type="radio" name="lang" value="python">
 			<acronym title="Python 3.6 : Doesn't support now :(">Python</acronym>
 			<br/> 
			<input type="submit" name="submit" value="Submit">

		</form>

		<hr />

		<pre>
For Java users:
 Out java version is 1.8.0.
 You should name your class "Program" and set it public.
 Don't put your code in a package
 If you get "Judgement Failed" , please check if you put the code into a package.
 And more, don't use stuff like "System.exit(0)" to terminal your program.
 Otherwise a "Runtime Error" may be raised. 
		</pre>
	</center>

	<%
		}
	%>
</body>
</html>