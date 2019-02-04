<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ConfigLoader"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.codec.digest.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String path=request.getParameter("path");
	String encrypt=request.getParameter("encrypt");
	if(path==null || encrypt==null){
		response.setStatus(404);
		return;
	}
	
	try{
		File req=new File(ConfigLoader.getPath()+"/"+path);
		if(!req.exists() || req.isDirectory()){
			throw new Exception("Not a readable file");
		}
		
		if(req.length()>=1024*1024){
			throw new Exception("File is too large");
		}
		
		String md5=DigestUtils.md5Hex(new FileInputStream(req));
		
		System.out.println("[External Resource Request]File:"+path+"("+req+") Length:"+req.length()+" Given md5:"+encrypt+" Expected md5:"+md5+" Operator:"+request.getRemoteAddr());
		
		if(!md5.equalsIgnoreCase(encrypt)){
			throw new Exception("Bad MD5");
		}
		
		BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(req),"utf-8"));
		
		char[] c=new char[1024*1024]; //Max flow size is 1024*1024
		
		int ret=br.read(c);
		br.close();
		
		if(ret==-1){	
			throw new Exception("Unexpected EOF");
		}
		
		out.println(c);
		
	}catch(Exception e){
		response.setStatus(404);
		out.println("<!--"+e+"-->");
	}
%>