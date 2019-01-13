<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.*,com.hhs.xgn.jee.hhsoj.db.*,com.hhs.xgn.jee.hhsoj.type.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>

<title>HHSOJ-Problems</title> 
</head>
<body>
	<h1 id="title">Contest Problems in HHSOJ</h1>
	<i id="subtitle">Bad contest time --XGN</i>
	<hr />
	<jsp:include page="nav.jsp?at=problemset"></jsp:include>
	
	<a href="problemset.jsp" class="problemset">Practice Problemset</a>
	<a href="cpset.jsp" class="problemset selected">Contest Problemset</a>
	<a href="cfset.jsp" class="problemset">Codeforces Problemset</a>
	
	<br/>
	<br/>
	
	<table id="problem-table">
		<tr>
			<th width="10%">ID</th>
			<th width="40%">Name</th>
			<th width="30%">Origin</th>
			<th width="20%">Tags</th>
		</tr>

		<!-- Start for -->

		<%
			ArrayList<Contest> cons=new ContestHelper().getAllContests();
			for (Contest c:cons) {
				for(Problem p:c.getProblems()){
		%>
					<tr>
						<td><%="C"+p.getConId()+p.getConIndex() %></td>
						<td><a href="problem.jsp?id=<%="C"+p.getConId()+p.getConIndex()%>"><%=p.getName() %></a></td>
						<td><a href="contestWelcome.jsp?id=<%=c.getId()%>"><%=c.getInfo().getName() %></a></td>
						<td><%=(c.isContestEnded()?p.getTag():"<i>Unknown</i>") %></td>
					</tr>
		<%
				}
			}
		%>
	</table>
</body>
</html>