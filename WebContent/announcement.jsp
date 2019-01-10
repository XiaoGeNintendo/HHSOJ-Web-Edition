<%@page import="com.hhs.xgn.jee.hhsoj.db.ConfigLoader"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Contest"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ContestHelper"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.File"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Problem"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ProblemHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- This page is used to read statement files -->

<%
	String id=request.getParameter("id");
	if(id==null || id.equals("")){
		out.println("Don't view this page, thx.");
		return;
	}
	File statementPath=new File(ConfigLoader.getPath()+"/contests/"+id+"/index.html");
	BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(statementPath)));
	String s;
	while((s=br.readLine())!=null){
		out.println(s);
	}
	br.close();
	
%>