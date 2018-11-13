<%@page import="com.hhs.xgn.jee.hhsoj.db.BlogHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Blog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="index.css" rel="stylesheet" type="text/css">
<title>HHSOJ - Edit Post</title>
</head>
<body>

	<%
		String userLooking;
		Blog b;
		try{
			userLooking=(String)session.getAttribute("username");
			int blogId=Integer.parseInt(request.getParameter("id"));
			b=new BlogHelper().getBlogDataByID(blogId);
			if(b==null){
				throw new Exception("Doesn't exist");
			}
			if(!b.getUser().equals(userLooking)){
				throw new Exception("You are not the author");
			}
			
		}catch(Exception e){
			out.println("Request Error");
			out.println("<!--"+e+"-->");
			return;
		}
		
	%>
	
	<!-- Default Template -->
	<h1 id="title">Editing the blog on HHSOJ</h1>
	<i id="subtitle">Contribution:-23 -- gwq2017</i>
	<hr />
	
	<jsp:include page="nav.jsp?at=blogs"></jsp:include>
	
	<!-- Default End -->

	<script type="text/javascript" src="js/wangEditor.js"></script>

	<b>Now logging in as <%=userLooking%></b>
	<br />
	<center>
		Title:<input type="text" width="50%" id="inpt" value="<%=b.getTitle() %>"/> <br /> <br />
	</center>

	<div id="div1">
		<%out.println(b.getHtml());%>
	</div>

	<br />

	<center>
		<button id="submit">Finish</button>
	</center>
	
	<script>
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
		
		//Add editor
		var E = window.wangEditor
		var editor2 = new E('#div1')
		editor2.create()

		//Add action

		document.getElementById("submit").addEventListener("click", function() {
			//Send a post request
			var para={
				"html":editor2.txt.html(),
				"title":document.getElementById("inpt").value,
				"id":<%=b.getId()%>
			}
			
			httpPost("doEditPost.jsp",para);
		})
	</script>

	
</body>
</html>