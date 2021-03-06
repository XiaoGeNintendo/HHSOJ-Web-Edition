<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Problem"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Contest"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ContestHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>
	<style>
	    #code{
	        margin: auto;
	        width: 60%;
	        height: 500px;
    	}
    </style>
<title>HHSOJ-Submit</title>
</head>
<body>
	<div class="container">
		<%
			String s = (String) session.getAttribute("username");
			if (s == null || s.equals("")) {
				response.sendRedirect("login.jsp?back=submit");
			}
			Users u=new UserHelper().getUserInfo(s);
			
			
			String conid= request.getParameter("cid");
			
			if(conid==null){
				response.sendRedirect("submit.jsp");
				return;
			}
			
			Contest c=new ContestHelper().getContestDataById(conid);
			
			if(c==null){
				response.sendRedirect("submit.jsp");
				return;
			}
			
			if(!c.isContestRunning()){
				response.sendRedirect("submit.jsp");
				return;
			}
			
			if (s == null || s.equals("")) {
				response.sendRedirect("login.jsp");
			} else {
		%>
	
	
			<!-- Default Template -->
		<h1 class="title">Submit in Contest!</h1>
		<i class="subtitle">Pretests Passed -- Codeforces</i>
		<hr />
		<jsp:include page="nav.jsp?at=submit"></jsp:include>
	
		<!-- Default End-->
	
		<center>		
			<div class="input-group" style="width:300px;">
				<div class="input-group-prepend">
	      			<span class="input-group-text">Problem</span>
	    		</div>
				<select class="form-control" id="prob" name="probid">
					<%
						ArrayList<Problem> problems=c.getProblems();
						for(Problem p:problems){
					%>
						<option value="<%="C"+p.getConId()+p.getConIndex() %>"><%=p.getConIndex()+" - "+p.getName() %></option>
					<%
						}
					%>
				</select>
			</div>
			
			<div class="input-group" style="width:300px;">
				<div class="input-group-prepend">
	      			<span class="input-group-text">Language</span>
	    		</div>
				<select class="form-control" id="lang" name="testset" onchange="s()">
					<option value="cpp">C++ 11</option>
					<option value="java">Java 1.8.0</option>
					<option value="python">Python 3.6</option>
				</select>
			</div>
			
			<div id="code"></div>
			<i>Note:to change the editor config,go to your preference settings</i><br/>
			
			<button onclick="submit()" class="btn btn-primary">
				Submit!
			</button>
		</center>
			
		<br/>
		<hr />
	
		<pre>
Use "C"+contestId+index to submit problems that are in the contest.
For example, "C1A" means the problem A in the contest id=1.
This is for practise only. To submit during an active contest, please use the Contest Submit System. 

User "R"+contestId+index to submit a Codeforces problem.
For example, "R1A" means submitting to "Theater Square".
Notice that if the admin doesn't allow remote judge, then you can't submit.

For Java users:
  You should name your class "Program" and set it public.
  Don't put your code in a package,If you get "Judgement Failed",please check if you put the code into a package.
  And more, don't use stuff like "System.exit(0)" to terminal your program,Otherwise a "Runtime Error" may be raised. 
			</pre>
	
		<script>
			
			// Init the code editor
		    var editor = ace.edit("code");
		    editor.setTheme("ace/theme/<%=u.getPreference().get("editorTheme").value%>");
		    editor.session.setMode("ace/mode/c_cpp");
		    document.getElementById('code').style.fontSize='<%=u.getPreference().get("fontSize").value%>';
	
		    if(<%=u.getPreference().get("autoComplete").value.equals("Yes")%>){
		    	ace.require("ace/ext/language_tools");
		    	
		    	editor.setOptions({
		    	    enableBasicAutocompletion: true,
		            enableSnippets: true,
		            enableLiveAutocompletion: true
		    	});
		    }
		    
		    var lang="";
		    
		    function s(s){
		    	lang=s;
		    	if(s=="cpp"){
		    		s="c_cpp";
		    	}
		    	editor.session.setMode("ace/mode/"+s);
		    }
		    
		  //Post function
			function httpPost(URL, PARAMS) {
				var temp = document.createElement("form");
				temp.action = URL;
				temp.method = "post";
				temp.style.display = "none";
	
				for ( var x in PARAMS) {
					var opt = document.createElement("textarea");
					opt.name = x;
					opt.value = PARAMS[x];
					temp.appendChild(opt);
				}
	
				document.body.appendChild(temp);
				temp.submit();
	
				return temp;
			}
		  
			function submit(){
				var a=document.getElementById("prob").value;
				var code=editor.getValue();
				
				if(lang=="" || a=="" || code==""){
					alert("Problem Id or Language or Code is Empty!\nIf you made sure everything is right, click on ALL the radio checkbox you selected once more.");
					return;
				}
				
				httpPost("docs.jsp",{
					"probid":a,
					"code":code,
					"lang":lang,
				});
			}
		</script>
		<%
			}
		%>
	</div>
</body>
</html>
