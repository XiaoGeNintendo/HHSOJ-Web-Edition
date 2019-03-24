<%@page import="com.hhs.xgn.jee.hhsoj.db.UserRenderer"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.PatternMatcher"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.VerdictHelper"%>
<%@page import="java.util.Comparator"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.SubmissionHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Submission"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>

<title>HHSOJ-Status</title>
</head>
<body>
	
	<!-- Default Template -->
	<h1 id="title">Status</h1>
	<i id="subtitle">There'll be only one testing thread working at a time --XGN</i>
	<hr />
	<jsp:include page="nav.jsp?at=status"></jsp:include>
	<!-- Default End -->
	
	<center>	
		
		<%
		
			String userPattern=request.getParameter("userId");
			String probPattern=request.getParameter("probId");
			String verdictPattern=request.getParameter("verdictId");

		%>
		<div id="filter-top">
			<p><strong>Submission Filter Setting</strong></p>
			<form action="#" name="query" method="get">
				<p>
				User:<input name="userId" type="text" style="width:130px;" value="<%=(userPattern!=null?userPattern:"") %>"/>
				Problem:<input name="probId" type="text" style="width:70px;" value="<%=(probPattern!=null?probPattern:"") %>"/>
				Verdict:<input name="verdictId" type="text" style="width:150px;" value="<%=(verdictPattern!=null?verdictPattern:"") %>"/>
				<input name="submit" type="submit" value="Filter"/>
				</p>
			</form>
		</div>
		
		<br/>
		
		<table id="status-table">
		</table>
		
	</center>
	
	<script>
	
		get();
		
		function get(){
			xml=new XMLHttpRequest();
			
			var a=location.href.indexOf("?");
			var b="";
			if(a!=-1){
				b=location.href.substr(a);	
			}
			
			
			xml.open("GET","api/getStatus.jsp"+b,true);
			
			xml.onreadystatechange=function(){
				if (xml.readyState==4 && xml.status==200)
				{
					document.getElementById("status-table").innerHTML=xml.responseText;
					
					$('[data-toggle="tooltip"]').tooltip();   
					
					upd();
					//setTimeout(get,1000);
				}
			}
			
			xml.send();
		}
		
		function upd(){
			//THis function updates with the database
			xml=new XMLHttpRequest();
			var fa=document.getElementById("status-table").children[0];
			
			var a=location.href.indexOf("?");
			var b="";
			if(a!=-1){
				b=location.href.substr(a);	
			}
			
			var len=fa.children[1].children[1].innerText;
			
			xml.open("GET","api/updateStatus.jsp?start="+len+"&"+b.substr(1),true);
			
			xml.onreadystatechange=function(){
				if(xml.readyState==4 && xml.status==200){
					var res=eval("("+xml.responseText+")");
					
					
					for(var i=0;i<len;i++){
						
						fa.children[i+1].children[3].innerHTML=res[i].verdict;
						fa.children[i+1].children[4].innerHTML=res[i].time;
						fa.children[i+1].children[5].innerHTML=res[i].mem;
					}
					
					setTimeout(upd,1000);
				}
			}
			
			xml.send();
		}
		
	</script>
</body>
</html>