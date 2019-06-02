<%@page import="java.util.Date"%>
<%@page import="com.hhs.xgn.jee.hhsoj.download.*"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ConfigLoader"%>
<%@page import="com.hhs.xgn.jee.hhsoj.judger.TaskQueue"%>
<%@page import="com.hhs.xgn.jee.hhsoj.judger.JudgingThread"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	try{
		boolean in=(Boolean)session.getAttribute("admin");
		if(!in){
			return;
		}
	}catch(Exception e){
		out.println("<!-- "+e+" -->");
		return;
	}
%>
<tr>
	<th width="30%">From URL</th>
	<th width="30%">To Position</th>
	<th width="20%">Date</th>
	<th width="10%">Status</th>
	<th width="10%">Speed</th>
</tr>

<%
	for(DownloadTask dt:DownloadQueue.get()){ 
%>
		<tr>
			<td><%=dt.getFrom() %></td>
			<td><%=dt.getTo() %></td>
			<td><%=new Date(dt.getTime()) %></td>
			<td><%=dt.getStatus() %></td>
			<td><%=dt.s(dt.getSpeed())+"/s"%></td>
		</tr>
<%
	}
%>
	