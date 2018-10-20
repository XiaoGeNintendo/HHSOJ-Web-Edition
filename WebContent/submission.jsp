<%@page import="com.hhs.xgn.jee.hhsoj.db.VerdictHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.TestResult"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Submission"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.SubmissionHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="index.css" rel="stylesheet" type="text/css">
<title>HHSOJ-Submission <%=request.getParameter("id") %></title>
</head>
<body>
	<script src="js/jquery-1.11.0.js" type="text/javascript"></script>
	<script src="js/wangHighLighter-1.0.0-min.js" type="text/javascript"></script>
	
	
	<%
		int id=-1;
		Submission s=new Submission(); 
		try{
			id=Integer.parseInt(request.getParameter("id"));
			s=new SubmissionHelper().getSubmission(id);
		}catch(Exception e){
			out.println("Submission doesn't exist");
			out.println("<a href=\"javascript:location.replace(document.referrer);\">←Back</a>");
			return;
		}
		
	%>
	
	<script>
		function code(){
			var highLightCode = wangHighLighter.highLight("<%=s.getLang().equals("cpp")?"C++":s.getLang()%>", "simple", "<%=s.getCode().replace("\\","\\\\").replace("\n", "\\n").replace("\r","\\r").replace("\t","\\t").replace("\"","\\\"").replace("</script>","</son>") %>"); 
			this.document.write(highLightCode);
		}
	</script>
	
	<!-- Default Template -->
	<h1 id="title">Submissions on HHSOJ</h1>
	<i id="subtitle">Ctrl+A Ctrl+C help me get AC!  --IC</i>
	<hr />
	<jsp:include page="nav.jsp?at=status"></jsp:include>
	<!-- Default End -->
	
	<center>
		<h1>Submission <%=id %> on HHSOJ</h1>
	</center>
	
		<h2>Basic Information</h2>
	
		Submission ID:<%=id %> <br/>
		Problem ID:<a href="problem.jsp?id=<%=s.getProb() %>"><%=s.getProb() %></a><br/>
		Submission Owner:<a href="users.jsp?username=<%=s.getUser() %>"><%=s.getUser()%></a><br/>
		Submission Language:<%=s.getLang() %><br/>
		Submission Verdict:<%=new VerdictHelper().render(s.getVerdict())%><br/>
		Submission Time Cost:<%=s.getTimeCost() %><br/>
		Submission Memory Cost:<%=s.getMemoryCost() %><br/>
		
		<h2>Code</h2>
		
		<script>
			code();
		</script>
		
		<h2>Compiler Comment</h2>
		<pre><%=s.getCompilerComment().replace("<","&lt;").replace(">","&gt;") %></pre>
		
		<h2>Testcases Information</h2>
		<%
			int cnt=1;
			for(TestResult tr:s.getResults()){
						
		%>
				<b>Test#<%=cnt %>:</b>
				<b><%=tr.getFile() %> </b>
				<b>Verdict:<%=new VerdictHelper().render(tr.getVerdict())%></b>
				<b>Time cost:<%=tr.getTimeCost() %>ms </b>
				<b>Memory cost:<%=tr.getMemoryCost() %>KB </b>
				<b>Checker comment:</b><br/>
				<pre><%=tr.getCheckerComment() %></pre>
				<br/><br/>
				
		<%
			cnt++;
			}
		%>
</body>
</html>