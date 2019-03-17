<%@page import="com.hhs.xgn.jee.hhsoj.remote.CodeforcesHelper"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.hhs.xgn.jee.hhsoj.db.*,com.hhs.xgn.jee.hhsoj.type.*"%>

<%
	try{
		
		String sid=request.getParameter("id");
		String user=(String)session.getAttribute("username");
		
		if(user==null){
			throw new Exception("You have to be logged in to refresh the statement");
		}
		
		if(sid==null){
			throw new Exception("Problem ID parameter not found");
		}
		
		System.out.println("[Refresh Codeforces Problem Statement] request "+sid+" from "+user+" ip="+request.getRemoteAddr());
		
		CodeforcesHelper.statement.remove(sid.substring(1));
		
		response.sendRedirect("cfp.jsp?id="+sid);
	}catch(Exception e){
		out.println("Error:"+e.getMessage());
		return;
	}
%>