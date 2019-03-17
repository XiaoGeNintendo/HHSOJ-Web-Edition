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
	<h1 id="title">Problems in HHSOJ</h1>
	<i id="subtitle">Solve them? Impossible! --Zzzyt</i>
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
	
	<a href="problemset.jsp" class="problemset selected">Practice Problemset</a>
	<a href="cpset.jsp" class="problemset">Contest Problemset</a>
	<a href="cfset.jsp" class="problemset">Codeforces Problemset</a>
	
	<br/>
	<br/>
	
	<table id="problem-table">
		<tr>
			<th width="10%">ID</th>
			<th width="50%">Name</th>
			<th width="40%">Tags</th>
		</tr>

		<!-- Start for -->

		<%
			ProblemHelper db = new ProblemHelper();
			ArrayList<Problem> p = db.getAllProblems();

			for (Problem pro : p) {
		%>
		<tr>

			<td bgcolor="<%=new UserRenderer().getColorUP(u,""+pro.getId())%>"><%=pro.getId()%></td>

			<td><a href="problem.jsp?id=<%=pro.getId()%>"><%=pro.getName()%></a></td>
			<td><%=pro.getTag()%></td>
		</tr>

		<!-- End for -->
		<%
			}
		%>
	</table>
</body>
</html>