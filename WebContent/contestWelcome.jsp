<%@page import="com.hhs.xgn.jee.hhsoj.db.UserRenderer"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.ContestStandingColumn"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.ContestStandingRow"%>
<%@page import="java.util.Date"%>
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
<%
	String id=request.getParameter("id");
	if(id==null){
		response.sendRedirect("contests.jsp");
		return;
	}
	Contest c=new ContestHelper().getContestDataById(id);
	if(c==null){
		response.sendRedirect("contests.jsp");
		return;
	}
%>
<title>HHSOJ - Contest Main Page of <%=c.getInfo().getName() %></title>
</head>
<body>
	<!-- Enter Everything here -->
	<h1 id="title"><%=c.getInfo().getName() %></h1>
	<i id="subtitle">Start at <%=new Date(c.getInfo().getStartTime()) %></i>
	<hr />
	<jsp:include page="nav.jsp?at=contests"></jsp:include>
	
	
	<h1>Time</h1>
	<p id="time"></p>
	
	<h1>Problems</h1>
	This contest contains <%=c.getInfo().getScores().size() %> problem(s) <br/>
	
	<table align="center" width="80%" border="1">
		<tr>
			<th align="center" width="10%">Index</th>
			<th align="center" width="60%">Name</th>
			<th align="center" width="15%">Score small</th>
			<th align="center" width="15%">Score large</th>
		</tr>
	<%
		ArrayList<Problem> arr=c.getProblems();
		for(Problem p:arr){
			if(c.isContestStarted()){
	%>
		<tr>
			<td align="center"><%=p.getConIndex() %></td>
			<td align="center"><a href="vcp.jsp?cid=<%=c.getId()%>&pid=<%=p.getConIndex()%>"><%=p.getName() %></a></td>
			<td align="center"><%=c.getInfo().getScores().get(p.getConIndex()).getSmall()%></td>
			<td align="center"><%=c.getInfo().getScores().get(p.getConIndex()).getLarge()%></td>
		</tr>
	<%}else{ %>
		<tr>
			<td align="center"><%=p.getConIndex() %></td>
			<td align="center"><%=p.getName() %></td>
			<td align="center"><%=c.getInfo().getScores().get(p.getConIndex()).getSmall()%></td>
			<td align="center"><%=c.getInfo().getScores().get(p.getConIndex()).getLarge()%></td>
		</tr>
	<%} %>
	<%} %>
	
	</table>
	
	<h1>Rules</h1>
	All HHSOJ Contests uses the rule that is similar to GCJ rule. That is: <br/>
	In each problem, a "small" and a "large" testset will be given. <br/>
	If you solved the "small" testset, some points will be given <br/>
	If you solved the "large" testset, some points will be given too <br/>
	The small testset will be judged during contest <br/>
	But the "large" testset will only be tested <b>after the contest</b> <br/>
	Be careful that every wrong submission that fails on small testset or resubmit will cause a loss of 50 points
	after you have passed the small testset <br/>
	Each problem has a minimum score of 0 <br/>
	All solutions that passes "small" testset will be judged on "large" testset after contest <br/>
	If you failed on "large" testset, nth will happen <br/>
	The user with the highest score gets higher rank<br/>
	If two users has the same score, a "tiebreaker" will be used <br/>
	the "tiebreaker" is the time of last correct submission that passes the "small" testset
	you submitted in the contest<br/>
	If the "tiebreaker" is smaller, the rank is higher <br/>
	
	
	
	<h1>Announcement</h1>
	<jsp:include page="announcement.jsp?id=<%=c.getId() %>"></jsp:include>
	
	<h1>Standings</h1>
	<table border="1" align="center" width="80%">
		<tr>
			<th width="10%" align="center">Rank</th>
			<th width="40%" align="center">User</th>
			<th width="20%" align="center">Score</th>
			<%
				for(Problem p:arr){
			%>
				<th align="center"><a href="vcp.jsp?cid=<%=p.getConId()%>&pid=<%=p.getConIndex() %>"><%=p.getConIndex() %></a></th>
			<%
				}
			%>
		</tr>
		<%
			int rank=1;
			for(ContestStandingRow csr:c.getStanding().getRows()){
		
		%>
			<tr>
				<td align="center"><%=rank %></td>
				<td align="center"><%out.println(new UserRenderer().getUserText(csr.getUser())); %></td>
				<td align="center"><abbr title="Penalty:<%=csr.getPenalty()%>"><%=csr.getScore() %></abbr></td>
		<%
				for(Problem p:arr){
					ContestStandingColumn csc=csr.getScores().getOrDefault(p.getConIndex(), new ContestStandingColumn(0,0,0));
		%>
					<td align="center"><abbr title="<%=csc.getScoreSmall()%>+<%=csc.getScoreLarge() %>-50*<%=csc.getUnsuccessfulSubmitCount()%>"><%=csc.getScore() %></abbr></td>			
		<%
				}
		%>
			</tr>
		<%
			rank++;
		}
		%>
	</table>
	<hr/>
	<i>HHSOJ Contest System</i>
	
	<script>
		var now=<%=System.currentTimeMillis()/1000%>;
		var start=<%=c.getInfo().getStartTime()/1000%>;
		var end=<%=c.getInfo().getEndTime()/1000%>;
		var status="<%=c.getStatus()%>";
		function minusTime(){
			now++;
			
			
			if(status.indexOf("Before")!=-1){
				var delta=start-now;
				if(delta<0){
					location.reload(true);
					return;
				}
				document.getElementById("time").innerHTML="Before start <b>"+parseInt(delta/3600)+"h"+parseInt(delta/60%3600)+"m"+parseInt(delta%60)+"s</b>";
			}else{
				if(status.indexOf("Running")!=-1){
					var delta=end-now;
					if(delta<0){
						location.reload(true);
						return;
					}
					
					document.getElementById("time").innerHTML="Before end <b>"+parseInt(delta/3600)+"h"+parseInt(delta/60%3600)+"m"+parseInt(delta%60)+"s</b>";
				}else{
					document.getElementById("time").innerHTML="Contest ended";
				}
			}
			
			setTimeout("minusTime()",1000);
		}
		minusTime();
	</script>
</body>
</html>