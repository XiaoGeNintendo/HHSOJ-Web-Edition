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
<title>HHSOJ-Status</title>
</head>
<body>
	<a href="javascript:history.go(-1)">←Back</a>
	<center>	
		
		<h1>Status</h1>
		<i>There'll be only one testing thread working at a time --XGN</i>
		<hr/>
		<table border="1" width="80%" align="center">
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
				
				for(Submission s:sb){
					
					
			%>
			
			<tr bgcolor="<%=(id==s.getId()?"cyan":"white")%>">
				<td align="center"><a href="submission.jsp?id=<%=s.getId()%>"> <%=s.getId() %> </a></td>
				<td align="center"><a href="problem.jsp?id=<%=s.getProb()%>"> <%=s.getProb() %> </a></td>
				<td align="center"><%=new VerdictHelper().render(s.getVerdict())%></td>
				<td align="center"><%=s.getTimeCost() %></td>
				<td align="center"><%=s.getMemoryCost() %></td>
				<td align="center"><a href="users.jsp?username=<%=s.getUser() %>"><%=s.getUser() %></a></td>
			</tr>
			
			<%
				}
			%>
		</table>
	</center>
</body>
</html>