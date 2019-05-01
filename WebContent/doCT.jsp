<%@page import="com.hhs.xgn.jee.hhsoj.type.CustomTestSubmission"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Problem"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ProblemHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.judger.TaskQueue"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Submission"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String code=request.getParameter("code");
	String lang=request.getParameter("lang");
	String input=request.getParameter("input");
	String visi=request.getParameter("public");
	String user=(String)session.getAttribute("username");
	
	if(code==null || lang==null || user==null ||input==null || visi==null){
		
		out.println("Null check failed");
		return;
	}
	
	if(code.length()>65536 || lang.length()>1024 || visi.length()>1024 || input.length()>65536){
		
		out.println("Length check failed");
		return;
	}
	
	CustomTestSubmission cts=new CustomTestSubmission(code,input,visi,user);
	
	
	int id=TaskQueue.addTask(cts);
	
	out.println(id);
%>