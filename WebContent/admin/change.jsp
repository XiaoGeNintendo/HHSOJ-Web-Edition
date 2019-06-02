<%@page import="java.io.PrintWriter"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Problem"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ProblemHelper"%>
<%@page import="org.eclipse.jdt.internal.compiler.problem.ProblemHandler"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.ContestInfo"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Contest"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ContestHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	String dest=request.getParameter("dest");
	String pid=request.getParameter("pid");
	String text=request.getParameter("text");
	if(dest==null || pid==null || text==null){
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
	
	Problem p=new ProblemHelper().getProblemData(pid);
	PrintWriter pw=new PrintWriter(p.getPath()+"/"+dest);
	pw.println(text);
	pw.close();
	out.println("Write to "+p.getPath()+"/"+dest);
	
%>