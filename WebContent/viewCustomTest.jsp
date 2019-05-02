<%@page import="com.hhs.xgn.jee.hhsoj.type.CustomTestSubmission"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Problem"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserRenderer"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ProblemHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.VerdictHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.TestResult"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Submission"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.SubmissionHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>
<style>
	#editor{
        margin: auto;
        width: 50%; 
        height: 250px;
   	}
</style>
<title>HHSOJ-Custom Submission <%=request.getParameter("id") %></title>
</head>
<body>
	
	<%
		CustomTestSubmission cts=null;
		String userLooking=(String)session.getAttribute("username");
		String id=null;
		try{
			id=request.getParameter("id");
			if(id==null){
				throw new Exception("null id");
			}
			
			cts=new SubmissionHelper().getCustomTestSubmission(id);
			if(!cts.getProb().equals("T")){
				throw new Exception("bad probid");
			}
			if(!cts.isValid(userLooking)){
				throw new Exception("bad user");
			}
		}catch(Exception e){
			out.println("Custom Submission Open Error.<br/>");
			out.println("May because:<br/>1) This code is private/protected<br/>2) Submission Data Broken<br/>3) This code is not a custom submission.");
			out.println("<a href=\"javascript:location.replace(document.referrer);\">←Back</a>");
			return;
		}
		
		
	%>

	<!-- Default Template -->
	<h1 id="title">Custom Submission on HHSOJ</h1>
	<i id="subtitle">It's none of your bussiness!  --XGN</i>
	<hr />
	<jsp:include page="nav.jsp?at=status"></jsp:include>
	<!-- Default End -->
	
	<center>
		<h1>Custom Submission <%=id %> on HHSOJ</h1>
	</center>
	
		<h2>Basic Information</h2>
	
		Submission ID:<%=id %> <br/>
		Submission Owner:<%out.println(new UserRenderer().getUserText(cts.getUser()));%><br/>
		Submission Language:<%=cts.getLang() %><br/>
		Submission Verdict:<%=new VerdictHelper().render(cts.getHTMLVerdict())%><br/>
		Submission Time Cost:<%=cts.getTimeCost() %><br/>
		Submission Memory Cost:<%=cts.getMemoryCost() %><br/>
		Submission Submit Time:<%=cts.getReadableTime() %><br/>
		Submission Visibility:<%=cts.getVisible() %> <br/>
		
		<h2>Code</h2>

		<div id="editor">Loading Code...</div>

		<script>
			code();
		</script>
		
		<br/>
		
		<br/>
		
		<div class="card">
	      <div class="card-header">
	        <a class="card-link" data-toggle="collapse" href="#collapseOne">
	          	Input Data
	        </a>
	      </div>
	      <div id="collapseOne" class="collapse" >
	        <div class="card-body">
	          <pre><%=cts.getInput().replace("<","&lt;").replace(">","&gt;") %></pre>
	        </div>
	      </div>
	    </div>
		
		<div class="card">
	      <div class="card-header">
	        <a class="card-link" data-toggle="collapse" href="#collapseOne1">
	          	Output Data/Compiler Information/Exit Code
	        </a>
	      </div>
	      <div id="collapseOne1" class="collapse" >
	        <div class="card-body">
	          <pre><%=cts.getCompilerComment().replace("<","&lt;").replace(">","&gt;") %></pre>
	        </div>
	      </div>
	    </div>
		
</body>
</html>