<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.hhs.xgn.jee.hhsoj.db.*,com.hhs.xgn.jee.hhsoj.type.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>HHSOJ-Problems</title>
</head> 
<body>
	<a href="index.jsp">←Back</a>
	<center>
		
		<h1>Problems in HHSOJ</h1>
		<i>Solve them? Impossible! --Zzzyt</i>
		<br/>
		<a href="submit.jsp">Submit</a> or <a href="status.jsp">Status</a>
		<hr/>
		<table align="center" border="1" width="80%">
			<tr>
				<th width="10%">ID</th>
				<th width="50%">Name</th>
				<th width="40%">Tags</th>
			</tr>
			
			<!-- Start for -->
			
			<%
				ProblemHelper db=new ProblemHelper();
				ArrayList<Problem> p=db.getAllProblems();
				
				for(Problem pro:p){
				
			%>
				<tr>
				
					<td><%=pro.getId() %></td>
					
					<td><a href="problem.jsp?id=<%=pro.getId() %>"><%=pro.getName() %></a></td>
					<td><%=pro.getTag() %></td>
				</tr>	
			
			<!-- End for -->
			<%
				}
			%>
		</table>
	</center>
</body>
</html>