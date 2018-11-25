<%@page import="com.hhs.xgn.jee.hhsoj.type.Problem"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ProblemHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.judger.TaskQueue"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Submission"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String prob=request.getParameter("probid");
	String code=request.getParameter("code");
	String lang=request.getParameter("lang");
	String user=(String)session.getAttribute("username");
	
	if(prob==null || code==null || lang==null || user==null){
		response.sendRedirect("submit.jsp");
		return;
	}
	
	try{
		Problem p=new ProblemHelper().getProblemData(prob);
		
	}catch(Exception e){
		out.println("No such problem.");
		out.println("<a href=\"submit.jsp\">Resubmit</a>");
		out.println("<!--");
		out.flush();
		e.printStackTrace(response.getWriter());
		out.println("-->");
		return;
	}
	
	Submission s=new Submission();
	s.setProb(prob);
	s.setCode(code);
	s.setLang(lang);
	s.setUser(user);
	s.setSubmitTime(System.currentTimeMillis());
	s.setRated(true);
	s.setTestset("small");
	
	int id=TaskQueue.addTask(s);
	
	
	response.sendRedirect("status.jsp?probId="+prob+"&userId="+user);
%>