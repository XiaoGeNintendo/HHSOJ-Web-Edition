<%@page import="com.hhs.xgn.jee.hhsoj.type.Problem"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Contest"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ContestHelper"%>
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
		String conid= request.getParameter("cid");
		
		if(conid==null){
			response.sendRedirect("submit.jsp");
			return;
		}
		
		Contest c=new ContestHelper().getContestDataById(conid);
		
		if(c==null){
			response.sendRedirect("submit.jsp");
			return;
		}
		
		if(!c.isContestRunning()){
			response.sendRedirect("submit.jsp");
			return;
		}
		
		if (s == null || s.equals("")) {
			response.sendRedirect("login.jsp");
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

		
	</script>

	<!-- Default Template -->
	<h1 id="title">Submit in contest!</h1>
	<i id="subtitle">Not open for practise! --XGN</i>
	<hr />
	<jsp:include page="nav.jsp?at=contests"></jsp:include>

	<%
		String userLooking = (String) session.getAttribute("username");
	%>
	<!-- Default End-->


	<center>

		<form name="submit" action="docs.jsp"
			onsubmit="return callsubmit()" method="post">
			Problem:
			<select id="prob" name="probid" >
				<%
					ArrayList<Problem> problems=c.getProblems();
					for(Problem p:problems){
				%>
					<option value="<%="C"+p.getConId()+p.getConIndex() %>"><%=p.getConIndex()+" - "+p.getName() %></option>
				<%
					}
				%>
			</select>
			
			<br /> Code: <br />
			<textarea name="code" cols="70" rows="20" id="code"></textarea>
			<br /> 
			Language: <input type="radio" name="lang" value="java">
			<acronym title="Java1.8.0 : Name your class 'Program' and don't place it in a package!">Java</acronym>
			<input type="radio" name="lang" value="cpp">
			<acronym title="C++11 : Don't upload harmful code thx :(">C++</acronym> 
			<input type="radio" name="lang" value="python"> 
			<acronym title="Python 3.6 : A short and powerful language">Python</acronym>
			<br /> 
			<br/>
			<input type="submit" name="submit" value="Submit">
		</form>

		<hr />

		<pre>
		
Notice that: This submit system is only for submissions in contest.
All submission made by this system is rated.
If you want to submit problem for practising please use the practise submit system.

-----------------------------------
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