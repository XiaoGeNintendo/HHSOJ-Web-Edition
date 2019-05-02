<%@page import="com.hhs.xgn.jee.hhsoj.db.ProblemHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Submission"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.SubmissionHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String id=request.getParameter("id");
if(id==null){
	out.println("Error id");
	return;
}
Submission s=new SubmissionHelper().getSubmission(id);

String userLooking=(String)session.getAttribute("username");

if(s.isRated() && new ProblemHelper().getProblemData(s.getProb()).getContest().isContestRunning()){
	
	if(s.getUser().equals(userLooking)==false){
		out.println("No cheating during contests!!!");
		return;
	}
	
}

out.println(s.getCode());
%>