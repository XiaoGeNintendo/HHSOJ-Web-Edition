<%@page import="com.hhs.xgn.jee.hhsoj.db.PatternMatcher"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.VerdictHelper"%>
<%@page import="java.util.Comparator"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.SubmissionHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Submission"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="index.css" rel="stylesheet" type="text/css">
<title>HHSOJ-Status</title>
<style type="text/css">
	#status-table {
		border-collapse: collapse;
		width: 80%;
		align-self: center;
		margin: 0px auto;
		min-width: 500px;
		border:1px solid #cccccc;
		background:#f0f0f0;
	}
	
	#status-table th{
		text-align:center;
		padding: 3px;
		border: 1px solid #cccccc;
	}
	
	#status-table td{
		text-align:center;
		padding: 3px;
		border: 1px solid #cccccc;
	}
</style>
</head>
<body>
	
	<!-- Default Template -->
	<h1 id="title">Status</h1>
	<i id="subtitle">There'll be only one testing thread working at a time --XGN</i>
	<hr />
	<jsp:include page="nav.jsp?at=status"></jsp:include>
	<!-- Default End -->
	
	<center>	
		
		<%
		
			String userPattern=request.getParameter("userId");
			String probPattern=request.getParameter("probId");
			String verdictPattern=request.getParameter("verdictId");
			
			
		%>
		<div id="filter-top">
			<p><strong>Submission Filter Setting</strong></p>
			<form action="#" name="query" method="get">
				<p>
				User:<input name="userId" type="text" style="width:130px;"/>
				Problem:<input name="probId" type="text" style="width:70px;"/>
				Verdict:<input name="verdictId" type="text" style="width:150px;"/>
				<input name="submit" type="submit" value="Filter"/>
				</p>
			</form>
		</div>
		
		<br/>
		
		<table	id="status-table">
			<tr>
				<th width="15%">#</th>
				<th width="15%">ProbID</th>
				<th width="35%">Verdict</th>
				<th width="10%">Time Cost</th>
				<th width="10%">Memory Cost</th>
				<th width="20%">User</th>
			</tr>
			
			<!-- Start for here -->
			<%
				
				ArrayList<Submission> sb=new SubmissionHelper().getAllSubmissions();
				
				sb.sort(new Comparator<Submission>(){
					public int compare(Submission o1, Submission o2){
						if(o1.getId()>o2.getId()){
							return -1;
						}
						if(o1.getId()<o2.getId()){
							return 1;
						}
						return 0;
					}
				});
				
				int id=-1;
				try{
					id=Integer.parseInt(request.getParameter("id"));
				}catch(Exception e){
					
				}
				
				int cnt=0;
				for(Submission s:sb){
					if(new PatternMatcher().match(s,userPattern,probPattern,verdictPattern)){
					
			%>
			
			<tr bgcolor="<%=(id==s.getId()?"cyan":(cnt%2==0?"white":"#efefef"))%>">
				<td><a href="submission.jsp?id=<%=s.getId()%>"> <%=s.getId() %> </a></td>
				
				<td><a href="problem.jsp?id=<%=s.getProb()%>"> <%=s.getProb() %><sup><abbr title="Testset:<%=s.getTestset() %>"><%=s.getTestset().substring(0,1).toUpperCase() %></abbr></sup> </a></td>
				<td><%=new VerdictHelper().render(s.getHTMLVerdict())%></td>
				<td><%=s.getTimeCost() %></td>
				<td><%=s.getMemoryCost() %></td>
				<td><a href="users.jsp?username=<%=s.getUser() %>"><%=s.getUser()+(s.isRated()?"<sup><abbr title=\"In-contest submission\">#</abbr></sup>":"")%></a></td>
			</tr>
			
			<%
						cnt++;
					}
				}
			%>
		</table>
	</center>
</body>
</html>