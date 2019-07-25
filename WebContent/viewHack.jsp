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


<title>HHSOJ-Submission <%=request.getParameter("id") %></title>
</head>
<body>
	<script src="https://ajax.aspnetcdn.com/ajax/jquery/jquery-1.9.0.min.js"></script>
	<script src="js/wangHighLighter-1.0.0-min.js" type="text/javascript"></script>
	
	
	<%
		int id=-1;
		Submission s=new Submission();
		Problem p=null;
		try{
			id=Integer.parseInt(request.getParameter("id"));
			s=new SubmissionHelper().getSubmission(id);
			s.getCompilerComment(); //test null
			p=new ProblemHelper().getProblemData(s.getProb());
			
		}catch(Exception e){
			out.println("Submission doesn't exist");
			out.println("<a href=\"javascript:location.replace(document.referrer);\">←Back</a>");
			return;
		}
		
		String userLooking=(String)session.getAttribute("username");
		if(s.isRated() && new ProblemHelper().getProblemData(s.getProb()).getContest().isContestRunning()){
			
			if(s.getUser().equals(userLooking)==false){
				s.setCode("No cheating during contests!!!");	
			}
			
			s.setResults(new ArrayList<>());
		}
	%>
	
	
	<!-- Default Template -->
	<h1 class="title">Hacks on HHSOJ</h1>
	<i class="subtitle">unfortunately your solution to problem C has been hacked --Codeforces </i>
	<hr />
	<jsp:include page="nav.jsp?at=status"></jsp:include>
	<!-- Default End -->
	
	<center>
		<h1>Hack <%=id %> on HHSOJ</h1>
	</center>
	
	<h2>Hack Information</h2>
		From:<%=s.getUser() %> <br/>
		To:#<a href="submission.jsp?id=<%=s.getProb().substring(1)%>"><%=s.getProb().substring(1) %></a> <br/>
		Verdict:<b><%=s.getVerdict() %></b><br/>
	
	<div class="card">
      <div class="card-header">
        <a class="card-link" data-toggle="collapse" href="#collapseOne">
          	Validator Comment
        </a>
      </div>
      <div id="collapseOne" class="collapse" >
        <div class="card-body">
          <pre><%=s.getCompilerComment().replace("<","&lt;").replace(">","&gt;") %></pre>
        </div>
      </div>
    </div>
    
	<div class="card">
      <div class="card-header">
        <a class="card-link" data-toggle="collapse" href="#c2">
          	Hack Data
        </a>
      </div>
      <div id="c2" class="collapse" >
        <div class="card-body">
          <pre><%=s.getCode().replace("<","&lt;").replace(">","&gt;") %></pre>
        </div>
      </div>
    </div>	
		
</body>
</html>