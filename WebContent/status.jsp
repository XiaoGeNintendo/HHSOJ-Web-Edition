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
<style>
.filter-top {
	border-collapse: collapse;
	width: 100%;
	align-self: center;
	margin: 0px auto;
	min-width: 500px;
	border: 1px solid #cccccc;
	background: #ffffff;
	padding: 10px;
}
</style>
<title>HHSOJ-Status</title>
</head>
<body>
<div class="container">
	<!-- Default Template -->
	<h1 class="title">Status</h1>
	<i class="subtitle">There'll be only one testing thread working at a time --XGN</i>
	<hr />
	<jsp:include page="nav.jsp?at=status"></jsp:include>
	<!-- Default End -->
	
	<center>	
		
		<%
		
			String userPattern=request.getParameter("userId");
			String probPattern=request.getParameter("probId");
			String verdictPattern=request.getParameter("verdictId");

		%>
		<div class="card filter-top">
			<p><strong>Submission Filter Setting</strong></p>
			<form action="#" name="query" method="get">
				<p>
				<input class="form-control" name="userId" type="text" style="width:150px;display:inline-block;" placeholder="User" value="<%=(userPattern!=null?userPattern:"") %>"/>
				<input class="form-control" name="probId" type="text" style="width:100px;display:inline-block;" placeholder="Problem" value="<%=(probPattern!=null?probPattern:"") %>"/>
				<input class="form-control" name="verdictId" type="text" style="width:150px;display:inline-block;" placeholder="Verdict" value="<%=(verdictPattern!=null?verdictPattern:"") %>"/>
				<input class="btn btn-primary" name="submit" type="submit" value="Filter"/>
				</p>
			</form>
		</div>
		
		<br/>
		
		<table class="table table-bordered table-sm" id="status-table">
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
		
		function renderJS(s){
			if(s.startsWith("Time Limit Exceeded") || s.startsWith("Memory Limit Exceeded")){
				return "<span style=\"color:#0000ff;\">"+s+"</span>";
			}
			if(s == ("Accepted") || s=="Successful Hacking Attempt"){
				return "<span style=\"color:#00ff00;font-weight:bold;\">"+s+"</span>";
			}
			if(s == "Unsuccessful Hacking Attempt" || s=="Hacked"){
				return "<span style=\"color:#ff0000;font-weight:bold;\">"+s+"</span>";
			}
			if(s.startsWith("Defending") || s.startsWith("Initalizing") || s.startsWith("Running") || s.startsWith("Judging") || s.startsWith("Compiling") || s.startsWith("In queue")){
				return "<span style=\"color:#787878;\">"+s+"</span>";
			}
			if(s.startsWith("Wrong Answer")){
				return "<span style=\"color:#ff0000;\">"+s+"</span>";
			}
			if(s.startsWith("Runtime Error")){
				return "<span style=\"color:#088a85;\">"+s+"</span>";
			}	
			return "<span style=\"color:#201890;\">"+s+"</span>";
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
			
			if(b.substr(1)!=""){
				xml.open("GET","api/updateStatus.jsp?start="+len+"&"+b.substr(1),true);	
			}else{
				xml.open("GET","api/updateStatus.jsp?start="+len,true);
			}
			
			
			xml.onreadystatechange=function(){
				if(xml.readyState==4 && xml.status==200){
					var res=eval("("+xml.responseText+")");
					
					
					for(var i=0;i<res.length;i++){
						
						var fa=document.getElementById("status-table").children[0];
						if(fa.children[i+1]==undefined){
							console.log("BAD REQUEST for "+fa+"<>"+fa.children[i+1]+" "+i);
							continue;
						}
						
						var son=fa.children[i+1].children[3];
						if(son.children[0].lastmode==res[i].renderMode){
							//Continue last turn
							//console.log("I should be updating"+son.children[0].lastmode+" "+res[i].renderMode+" "+i);
							
							var id="verdict"+i;
							var mode=son.children[0].lastmode;
							
							if(mode=="2"){
								document.getElementById(id).innerHTML=res[i].verdict;
							}else if(mode=="4"){
								
								
								if(document.getElementById(id)==null){
									continue;
								}
								
								document.getElementById(id).innerHTML=res[i].verdict;
								document.getElementById("display"+i).style="width:"+res[i].percent+"%";
							}
						}else{
							//Renew Render Mode
							son.children[0].lastmode=res[i].renderMode;
							
							
							var mode=res[i].renderMode;
							
							if(mode=="1"){
								son.children[0].innerHTML="<b><font color=#00ff00>"+res[i].verdict+"</font></b>";	
							}else if(mode=="2"){
								son.children[0].innerHTML="<i class=\"fa fa-spinner fa-spin\"></i><font color=#787878 id=\"verdict"+i+"\">"+res[i].verdict+"</font>";
							}else if(mode=="3" || mode=="5"){
								
								son.children[0].innerHTML=renderJS(res[i].verdict);
							}else if(mode=="4"){
								son.children[0].innerHTML="<div class=\"progress\"><div id=\"display"+i+"\" class=\"progress-bar bg-success progress-bar-striped progress-bar-animated\" style=\"width:"+res[i].percent+"%\"><p style=\"color:#ff0000\" id=\"verdict"+i+"\">"+res[i].verdict+"</p></div></div>";
							}
						}
						
						fa.children[i+1].children[4].innerHTML=res[i].time;
						fa.children[i+1].children[5].innerHTML=res[i].mem;
					}
					
					setTimeout(upd,1000);
				}
			}
			
			xml.send();
		}
		
	</script>
</div>
</body>
</html>