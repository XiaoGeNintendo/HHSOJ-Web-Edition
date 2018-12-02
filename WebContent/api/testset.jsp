<%@page import="java.io.File"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ProblemHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Problem"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
try{
	String probId=request.getParameter("id");
	if(probId==null) throw new Exception("1");
	if(probId.startsWith("R")){
		out.println("<option value=\"cf\">Codeforces</option>");
		return;
	}
	Problem p=new ProblemHelper().getProblemData(probId);
	if(p==null) throw new Exception("2");
	
	File f=new File(p.getPath());
	if(!f.exists()) throw new Exception("3");
	
	for(File ano:f.listFiles()){
		if(ano.isDirectory()){
			out.println("<option value=\""+ano.getName()+"\">"+ano.getName()+"</option>");
		}
	}
}catch(Exception e){
	out.println("<option value=\"tests\">No testsets...</option>");
}
%>