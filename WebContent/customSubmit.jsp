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
	<jsp:include page="nav.jsp?at=index"></jsp:include>

	<!-- Default End-->

	<center>
		Visibility:
		<input type="radio" name="pub" value="private" onclick="w('private')"><acronym title="Cannot be seen from the status page, only you can see the detail">Private</acronym>
		<input type="radio" name="pub" value="protected" onclick="w('protected')"><acronym title="Can be seen from status page, but only you can see the detail">Protected</acronym>
		<input type="radio" name="pub" value=public onclick="w('public')"><acronym title="Can be seen from the status page, anyone can see the detail">Public</acronym>
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
		<textarea cols=50 name="input" id="input" placeholder="Your program's input please.No more than 65536b."></textarea>
		<br/>
		
		Output: <br/>
		<textarea cols=50 name="output" id="output" placeholder="Run to see output" readonly="readonly"></textarea>
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
	    var visi="";
	    var last=-1;
	    
	    function getOutput(){
	    	if(last!=-1){
	    		$.get("api/getCTStatus.jsp?id="+last,function(data,status){
	    			document.getElementById("output").value=data.trim();
	    		})
	    	}
	    	
	    	setTimeout(getOutput,1000);
	    }
	    
	    getOutput();
	    
	    function w(s){
	    	visi=s;
	    }
	    
	    function s(s){
	    	lang=s;
	    	if(s=="cpp"){
	    		s="c_cpp";
	    	}
	    	editor.session.setMode("ace/mode/"+s);
	    }
	    
		function submit(){
			var code=editor.getValue();
			var pub=visi;
			var input=document.getElementById("input").value;
			
			if(lang=="" || code=="" || pub==""){
				alert("Did you miss something?\nSomething is not filled correctly.");
				return;
			}
			
			$.post("doCT.jsp",{
				"code":code,
				"lang":lang,
				"public":visi,
				"input":input
			},function(data,status){
				last=data.trim();
				alert("Custom Submission has been posted successfully!\nStatus:"+status+"\nID:"+last);
			});
		}
	</script>
	<%
		}
	%>
</body>
</html>