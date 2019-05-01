<%@page import="com.hhs.xgn.jee.hhsoj.type.CustomTestSubmission"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Submission"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.SubmissionHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String id=request.getParameter("id");
	try{
		
		if(id==null){
			throw new Exception("null id");
		}
		 
		CustomTestSubmission cts=new SubmissionHelper().getCustomTestSubmission(id); 
		if(!cts.getProb().equals("T")){
			throw new Exception("bad probid");
		}
		
		
		
		String user=(String)session.getAttribute("username");
		if(user==null){
			throw new Exception("null user");
		}
		
		if(!cts.isValid(user)){ 
			throw new Exception("user invalid");
		}
		
		out.println("Request:"+id+"\nStatus:"+cts.getVerdict()+"\n"+cts.getCompilerComment()+"\n======\n"+cts.getTimeCost()+";"+cts.getMemoryCost());
	}catch(Exception e){
		out.println("Request:"+id+"\nStatus:Failed\n"+e);
		
		return;
	}
%>