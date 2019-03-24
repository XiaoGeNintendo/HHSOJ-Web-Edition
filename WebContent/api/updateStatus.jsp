<%@page import="com.hhs.xgn.jee.hhsoj.db.TypeMaster"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserRenderer"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.PatternMatcher"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.VerdictHelper"%>
<%@page import="java.util.Comparator"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.SubmissionHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Submission"%>
<%@page import="java.util.ArrayList"%>
<%
		
	String userPattern=request.getParameter("userId");
	String probPattern=request.getParameter("probId");
	String verdictPattern=request.getParameter("verdictId");
	
	
	
	String res="";
			
				ArrayList<Submission> sb=new SubmissionHelper().getAllSubmissions();
				
				sb.sort(new Comparator<Submission>(){
					public int compare(Submission o1, Submission o2){
						if(o1.getId()>o2.getId()){
							return -1;
						}
						if(o1.getId()<o2.getId()){
							return 1;
						}
						return 0;
					}
				});
				
				int id=-1,start=999999999;
				try{
					id=Integer.parseInt(request.getParameter("id"));
					start=Integer.parseInt(request.getParameter("start"));
				}catch(Exception e){
					
				}
				
				out.print("[");
				
				int cnt=0;
				
				for(Submission s:sb){
					try{
						if(new PatternMatcher().match(s,userPattern,probPattern,verdictPattern)){
							if(s.getId()<=start){
								
								
								out.print("{\"verdict\":\""+new VerdictHelper().render(s.getHTMLVerdict())+"\",");
								out.print("\"time\":\""+s.getTimeCost()+"\",");
								out.print("\"mem\":\""+s.getMemoryCost()+"\"},");
							cnt++;
							}
						}
					}catch(Exception e){			
						
					}
				}
				out.print("]");
			%>
	