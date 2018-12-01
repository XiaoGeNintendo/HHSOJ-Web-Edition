<%@page import="com.hhs.xgn.jee.hhsoj.type.Question"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.RatingCalc"%>
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

String cid=request.getParameter("cid");
String qid=request.getParameter("qid");
if(cid==null || qid==null){
	return;
}
Contest c=new ContestHelper().getContestDataById(cid);
Question q=c.getQuestions().get(Integer.parseInt(qid));
q.setOpen(!q.isOpen());
new ContestHelper().refreshContest(c);

response.sendRedirect("cc.jsp?id="+cid);
%>