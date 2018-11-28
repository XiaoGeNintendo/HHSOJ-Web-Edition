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

String id=request.getParameter("id");
if(id==null){
	return;
}
Contest c=new ContestHelper().getContestDataById(id);
if(c==null){
	return;
}

new RatingCalc().calc4(c);
out.println("Please view console logs for detail");
		
%>