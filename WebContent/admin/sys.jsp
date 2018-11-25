<%@page import="com.hhs.xgn.jee.hhsoj.judger.TaskQueue"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.SubmissionHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Submission"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Contest"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ContestHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
boolean in=(Boolean)session.getAttribute("admin");
if(!in){
	return;
}

String str=request.getParameter("id");

Contest c=new ContestHelper().getContestDataById(str);

ArrayList<Submission> arr=new SubmissionHelper().getAllSubmissions();

int cnt=0;

for(Submission s:arr){
	if(s.isRated() && s.getVerdict().equals("Accepted") && c.inRange(s.getSubmitTime())){
		Submission as=new Submission();
		as.setProb(s.getProb());
		as.setCode(s.getCode());
		as.setLang(s.getLang());
		as.setUser(s.getUser());
		as.setSubmitTime(s.getSubmitTime());
		as.setRated(true);
		as.setTestset("large");
		TaskQueue.addTask(as);
		cnt++;
	}
}

out.println("Totally "+cnt+" programs will be rejudged");

%>