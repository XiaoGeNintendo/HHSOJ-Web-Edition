<%@page import="java.io.PrintWriter"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Problem"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ProblemHelper"%>
<%@page import="org.eclipse.jdt.internal.compiler.problem.ProblemHandler"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.ContestInfo"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Contest"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ContestHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String dest=request.getParameter("dest");
	String pid=request.getParameter("pid");
	String text=request.getParameter("val");
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