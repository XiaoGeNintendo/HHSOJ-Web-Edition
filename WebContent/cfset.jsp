<%@page import="com.hhs.xgn.jee.hhsoj.remote.CodeforcesProblem"%>
<%@page import="com.hhs.xgn.jee.hhsoj.remote.CodeforcesHelper"%>
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
	<h1 id="title">Codeforces Problems Viewing in HHSOJ</h1>
	<i id="subtitle">All your bugs are belong to me!! --Codeforces</i>
	<hr />
	<jsp:include page="nav.jsp?at=problemset"></jsp:include>
	
	<%
		Users u=null;
		try{
			String sid=(String)session.getAttribute("username");
			u=new UserHelper().getUserInfo(sid);
		}catch(Exception e){
			
		}
	%>
	<a href="problemset.jsp" class="problemset">Practice Problemset</a>
	<a href="cpset.jsp" class="problemset">Contest Problemset</a>
	<a href="cfset.jsp" class="problemset selected">Codeforces Problemset</a>
	
	<br/>
	<br/>
	
	<table id="problem-table">
		<tr>
			<th width="10%">ID</th>
			<th width="45%">Name</th>
			<th width="40%">Tags</th>
			<th width="5%"> </th>
		</tr>

		<%
			//long st=System.currentTimeMillis();
			List<CodeforcesProblem> arr=CodeforcesHelper.getCodeforcesProblems();
			//System.out.println(System.currentTimeMillis()-st);
			
			for(CodeforcesProblem cp:arr){
		%>
				<tr>
					<td bgcolor="<%=new UserRenderer().getColorUP(u,"R"+cp.getContestId()+cp.getIndex())%>"><%="R"+cp.getContestId()+cp.getIndex() %></td>
					<td><a href="cfp.jsp?id=<%="R"+cp.getContestId()+cp.getIndex()%>"><%=cp.getName() %></a></td>
					<td><%=cp.getTags()%></td>
					<td><a href="submit.jsp?id=<%="R"+cp.getContestId()+cp.getIndex() %>"><img src="asset/submit.png"/></a></td>
				</tr>
		<%
			}
		%>
	</table>
</body>
</html>