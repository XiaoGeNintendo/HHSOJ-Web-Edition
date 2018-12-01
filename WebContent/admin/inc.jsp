<%@page import="com.hhs.xgn.jee.hhsoj.type.ContestInfo"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Contest"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ContestHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	String cid=request.getParameter("id");
	String dt=request.getParameter("time");
	if(cid==null || dt==null){
		return;
	}
	
	try{
		boolean in=(Boolean)session.getAttribute("admin");
		if(!in){
			return;
		}
	}catch(Exception e){
		out.println("<!-- "+e+" -->");
		return;
	}
	
	Contest c=new ContestHelper().getContestDataById(cid);
	if(c==null){
		return;
	}
	
	try{
		c.getInfo().increaseLength(Long.parseLong(dt)*60*1000);
	}catch(Exception e){
		out.println("<!-- "+e+" -->");
		return;
	}
	
	new ContestHelper().refreshContest(c);
	response.sendRedirect("cc.jsp?id="+cid);
	
%>