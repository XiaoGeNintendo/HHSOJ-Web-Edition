<%@page import="java.util.Date"%>
<%@page import="java.util.Comparator"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ContestHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Contest"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="index.css" rel="stylesheet" type="text/css">
<title>HHSOJ - Contests</title>
</head>
<body>
	<!-- Enter Everything here -->
	<h1 id="title">Contest List</h1>
	<i id="subtitle">-19 Legend! --XGN</i>
	<hr />
	<jsp:include page="nav.jsp?at=contests"></jsp:include>
	
	<center>
		<b>Now time:<%=new Date()%> </b>
	</center>
	<br/>
	
	<table border="1" width="80%" align="center">
		<tr>
			<th width="40%" align="center">Name</th>
			<th width="20%" align="center">Start Time</th>
			<th width="10%" align="center">Length</th>
			<th width="20%" align="center">Writers</th>
			<th width="10%" align="center">Status</th>
		</tr>
	<%
		ArrayList<Contest> arr=new ContestHelper().getAllContests();
		arr.sort(new Comparator<Contest>(){
			public int compare(Contest o1, Contest o2){
				return -Long.compare(o1.getInfo().getStartTime(),o2.getInfo().getStartTime());
			}
		});
		
		for(Contest c:arr){
	%>
		<tr>
			<td align="center"><a href="contestWelcome.jsp?id=<%=c.getId()%>"><%=c.getInfo().getName()%></a></td>
			<td align="center"><%=new Date(c.getInfo().getStartTime()) %></td>
			<td align="center"><%=c.getInfo().getReadableLength() %></td>
			<td align="center"><%=c.getInfo().getAuthorsHTML() %></td>
			<td align="center"><%=c.getStatus() %></td>
		</tr>
	<%} %>
	</table>
</body>
</html>