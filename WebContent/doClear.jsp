<%@page import="com.hhs.xgn.jee.hhsoj.type.Question"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ContestHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Contest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String cid=request.getParameter("id");
	String user=(String)session.getAttribute("username");
	String clarification=request.getParameter("clarification");
	if(cid==null || user==null || clarification==null){
		out.println("Error <!-- Son null -->");
		return;
	}
	
	Contest c=new ContestHelper().getContestDataById(cid);
	if(c==null){
		out.println("Error <!-- Clever null -->");
		return;
	}
	
	if(clarification.length()>=65536){
		out.println("Clarification is too long.");
		return;
	}
	
	Question q=new Question();
	q.setAsker(user);
	q.setQuestion(clarification);
	q.setContestId(Integer.parseInt(cid));
	c.getQuestions().add(q);
	new ContestHelper().refreshContest(c);
	response.sendRedirect("contestWelcome.jsp?id="+cid);
%>