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

	String from=request.getParameter("from");
	String to=request.getParameter("to");
	
	if(from==null || to==null){
		out.println("error");
		return;
	}
	DownloadQueue.addTask(new DownloadTask(from,to,System.currentTimeMillis()));
%>
	