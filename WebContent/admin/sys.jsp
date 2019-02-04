<%@page import="java.util.Map.Entry"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.ContestStandingColumn"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.ContestStandingRow"%>
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
try{
	boolean in=(Boolean)session.getAttribute("admin");
	if(!in){
		return;
	}
}catch(Exception e){
	out.println("<!-- "+e+" -->");
	return;
}

String str=request.getParameter("id");

Contest c=new ContestHelper().getContestDataById(str);

int cnt=0;

for(ContestStandingRow csr:c.getStanding().getRows()){
	for(Entry<String,ContestStandingColumn> e:csr.getScores().entrySet()){
		Submission s=e.getValue().getLastSubmission();
		
		if(s!=null){
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
}

out.println("Totally "+cnt+" programs will be rejudged");

%>