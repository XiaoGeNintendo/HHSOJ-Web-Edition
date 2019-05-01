<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<jsp:include page="head.jsp"></jsp:include>
	
	<title>HHSOJ-Custom Submission</title>
	<style>
	    #code{
	        margin: auto;
	        width: 50%;
	        height: 250px;
    	}
    </style>
</head>
<body>

	<%
		String s = (String) session.getAttribute("username");
		if (s == null || s.equals("")) {
			response.sendRedirect("login.jsp?back=index");
		} else {
			Users u=new UserHelper().getUserInfo(s);
	%>

	<!-- Default Template -->
	<h1 id="title">Custom Submission</h1>
	<i id="subtitle">Sometimes called Custom Test --XGN</i>
	<hr />
	<jsp:include page="nav.jsp?at=submit"></jsp:include>

	<!-- Default End-->

	<center>
		Visibility:
		<input type="radio" name="pub" value="private"><acronym title="Cannot be seen from the status page, only you can see the detail">Private</acronym>
		<input type="radio" name="pub" value="protected"><acronym title="Can be seen from status page, but only you can see the detail">Protected</acronym>
		<input type="radio" name="pub" value=public><acronym title="Can be seen from the status page, anyone can see the detail">Public</acronym>
		<br/>
		<p>
			Language: <input type="radio" name="lang" value="java" onclick="s('java')"> <acronym
				title="Java1.8.0 : Name your class 'Program' and don't place it in a package!">Java</acronym>
			<input type="radio" name="lang" value="cpp" onclick="s('cpp')"> <acronym
				title="C++11 : Don't upload harmful code thx :(">C++</acronym> <input
				type="radio" name="lang" value="python" onclick="s('python')"> <acronym
				title="Python 3.6 : A short and powerful language">Python</acronym>
		<p>

		<br />
		<p>Code:</p>
		<div id="code"></div>
		<sub><i>Note:to change the editor config,go to your preference settings</i></sub> <br/>
		
		Input: <br/>
		<textarea cols=50 name="input" id="input" placeholder="Your program's input please"></textarea>
		<br/>
		
		Output: <br/>
		<textarea cols=50 name="output" id="output" placeholder="Run to see output"></textarea>
		<br/>
		
		<button onclick="submit()">
			Submit!
		</button>
	</center>
		
	<br/>
	<hr />


	<pre>
This is a place to submit Custom Submissions.
You can change the stuffs to see how things are working on the server
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
			var a=document.getElementById("pid").value;
			var code=editor.getValue();
			var te=document.getElementById("testset").value;
			
			if(lang=="" || a=="" || code==""){
				alert("Problem Id or Language or Code is Empty!");
				return;
			}
			
			httpPost("dosubmit.jsp",{
				"probid":a,
				"code":code,
				"lang":lang,
				"testset":te
			});
		}
	</script>
	<%
		}
	%>
</body>
</html>