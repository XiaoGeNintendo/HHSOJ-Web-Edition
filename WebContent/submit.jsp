<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>HHSOJ-Submit</title>
</head>
<body>
	
	<%
		String s=(String)session.getAttribute("username");
		if(s==null || s.equals("")){
			out.println("Please login to submit.<br/>");
			out.println("<a href=\"index.jsp\">Back to main page</a>");	
		}else{
	%>
	<a href="javascript:history.go(-1)">←Back</a>
	
	<script>
		function callsubmit(){
			//alert('I am running'+this.document);
			var prob=this.document.getElementsByName('probid')[0].value;
			var code=this.document.getElementsByName('code')[0].value;
			var lang=this.document.forms['submit']['lang'].value;
			
			if(lang==undefined){
				alert('Using an out-dated explorer is prohibited!!!! Why don\'t you use a new explorer??');
				return false;
			}
			//alert(lang);
			
			if(prob==null || prob==("")){
				alert('Problem ID should be filled out.');
				return false;
			}
			if(code==null || code==("")){
				alert('Code should not be empty');
				return false;
			}
			if(lang==null || lang==("")){
				alert('Please choose a language');
				return false;
			}
			
		}
	</script>
	
	<center>
		<h1>Submit!</h1>
		<i>Give out my answer! --Phoenix Wright</i> <br/>
		Now using account <%=s %>
		<hr/>
		<form name="submit" action="dosubmit.jsp" onsubmit="return callsubmit()" method="post">
			Problem:<input type="text" name="probid" value="<%=(request.getParameter("id")==null?"":request.getParameter("id")) %>">
			<br/>
			Code:
			<br/>
			<textarea name="code" cols="30" rows="15"></textarea>
			<br/>
			Language:<input type="radio" name="lang" value="java">Java <input type="radio" name="lang" value="cpp">C++ <input type="radio" name="lang" value="python">Python3
			<br/>
			<input type="submit" name="submit" value="Submit">
			
		</form>
		
		<hr/>
		
		<pre>
Please don't put your Java class in a package.
Your Java class will be named as "Program.java".
Don't upload anything that will be harmful to the server!
Python submitting is still testing! Use it carefully!
		</pre>
	</center>
	
	<%
		}
	%>
</body>
</html>