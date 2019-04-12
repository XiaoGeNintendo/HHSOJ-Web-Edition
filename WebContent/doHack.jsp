<%@page import="com.hhs.xgn.jee.hhsoj.judger.TaskQueue"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Problem"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ProblemHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Submission"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.SubmissionHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.BlogHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Blog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%

	request.setCharacterEncoding("utf-8");
	
try{
	String id=request.getParameter("id");
	String data=request.getParameter("data");
	String user=(String)session.getAttribute("username");
	if(user==null || user.equals("")){
		throw new Exception("Please login");
	}
	
	Submission s=new SubmissionHelper().getSubmission(Integer.parseInt(id));
	Problem p=new ProblemHelper().getProblemData(s.getProb());
	
	boolean[] query=new boolean[]{user!=null,s.getVerdict().equals("Accepted"),p.isHackable(s.getTestset())};
	
	boolean res=true;
	for(boolean x:query){
		res&=x;
	}
	
	if(!res){
		throw new Exception("Attempts to hack an unhackable solution");
	}else{
		Submission sw=new Submission();
		sw.setProb("H"+id);
		sw.setCode(data);
		sw.setLang("hack");
		sw.setUser(user);
		sw.setSubmitTime(System.currentTimeMillis());
		
		sw.setTestset("hackAttempt");
		
		int tq=TaskQueue.addTask(sw);
		
		//response.sendRedirect("status.jsp?id="+tq);
		
		out.println("Your attempt is in queue.\nPlease view status page to see the result");
	}
}catch(Exception e){
	out.println(e.getMessage());
	return;
}
	
	
	
%>