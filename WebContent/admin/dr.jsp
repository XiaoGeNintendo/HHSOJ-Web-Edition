<%@page import="com.hhs.xgn.jee.hhsoj.type.Question"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ContestHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Contest"%>
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
	String cid=request.getParameter("id");
	String que=request.getParameter("question");
	String ans=request.getParameter("answer");
	if(cid==null || que==null || ans==null){
		return;
	}
	
	Contest c=new ContestHelper().getContestDataById(cid);
	if(c==null){
		return;
	}
	
	Question q=new Question();
	q.setAsker("-=Announcement=-");
	q.setQuestion(que);
	q.setContestId(Integer.parseInt(cid));
	q.setAnswer(ans);
	q.setOpen(true);
	q.setStatus(Question.REPLIED);
	
	c.getQuestions().add(q);
	new ContestHelper().refreshContest(c);
	response.sendRedirect("cc.jsp?id="+cid);
%>