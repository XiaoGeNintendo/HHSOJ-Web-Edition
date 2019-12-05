<%@page import="java.io.File"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.FileHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ConfigLoader"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	String userLooking = (String) session.getAttribute("username");
	if (userLooking == null) {
		out.println("Please login to continue");
		return;
	}
	Users u=new UserHelper().getUserInfo(userLooking);
	if(!u.isSetter()){
		out.println("Access denied");
		return;
	}
	
	String id=request.getParameter("nid");
	if(id==null){
		out.println("Access denied");
		return;
	}
	if(!id.matches("[0-9]+")){
		out.println("ID must be an integer");
		return;
	}
	
	
	File f=new File(ConfigLoader.getPath()+"/problems/"+id);
	if(f.exists()){
		out.println("Problem already existed!");
		return;
	}
	f.mkdirs();
	
	String path=(ConfigLoader.getPath()+"/problems/"+id+"/arg.txt");
	String path2=(ConfigLoader.getPath()+"/problems/"+id+"/statement.html");
	FileHelper.writeFile(path, "Solution=\nChecker=\nName=\nTL=\nML=\nTag=\nAllLanguage=null|English\nStatement_null=statement.html");
	FileHelper.writeFile(path2,"Problem in construction, don't submit!");
	
	response.sendRedirect("set_probindex.jsp");
%>	