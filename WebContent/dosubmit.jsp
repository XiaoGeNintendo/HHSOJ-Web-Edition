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
	String testset=request.getParameter("testset");
	String user=(String)session.getAttribute("username");
	
	if(prob==null || code==null || lang==null || user==null){
		response.sendRedirect("submit.jsp");
		return;
	}
	
	if(code.length()>65536 || testset.length()>1024 || prob.length()>1024 || lang.length()>1024){
		response.sendRedirect("submit.jsp");
		return;
	}
	
	try{
		Problem p=new ProblemHelper().getProblemData(prob);
		if(p.getType()==Problem.CONTEST){
			if(!p.getContest().isContestEnded()){
				out.println("This problem is not open for practise now.");
				out.println("Please consider use the contest submit system");
				return;
			}
		}
		if(p.getType()==Problem.CUSTOM){
			out.println("WTF RU DOING??? DO YOU KNOW WHERE TO SUBMIT CUSTOM SUBMISSIONS?");
			return;
		}
		if(p.getType()==Problem.CODEFORCES){
			
		}
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
	
	if(testset==null){
		s.setTestset("tests");	
	}else{
		s.setTestset(testset);
	}

	int id=TaskQueue.addTask(s);
	
	
	response.sendRedirect("status.jsp?id="+id);
%>