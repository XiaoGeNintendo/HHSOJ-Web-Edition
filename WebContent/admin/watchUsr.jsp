<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>HHSOJ - Admin Platform</title>
</head>
<body>
	<%
	try{
		boolean in=(Boolean)session.getAttribute("admin");
		if(!in){
			return;
		}
	}catch(Exception e){
		out.println("<!-- "+e+" -->");
		return;
	}
		
	String id=request.getParameter("id");
	if(id==null || id.equals("")){
		return;
	}
	
	Users u=new UserHelper().getUserInfo(id);
	%>
	<h1><%=u.getId()+":"+u.getUsername() %></h1>
	<hr/>
	
	<b>Contest Record</b>:<%=u.getRatings() %> <br/>
	<b>Rating</b>:<%=u.getNowRating() %>/<%=u.getMaxRating() %><br/>
	<b>Mail</b>: <%=u.getEmail() %> <br/>
	<b>Ban Status</b>: <%=u.isBanned() %> <br/>
	<b>Send Notify?</b>: <%=u.isSendNotify() %> <br/>
	<b>Is Problemsetter?</b>: <%=u.isSetter() %> <br/>
	
	<hr/>
	
	<a href="ban.jsp?id=<%=u.getUsername() %>">Ban/Unban</a> <br/>
	<a href="setset.jsp?id=<%=u.getUsername() %>">Set/Unset problemsetter role</a> <br/>
	
	<input id="role" value="<%=u.getSpecialRole().replace("<", "&lt;").replace(">","&gt;").replace("\"","&quot;")%>" placeholder="Special Role">
	<input id="color" value="<%=u.getSpecialColor().replace("<", "&lt;").replace(">","&gt;").replace("\"","&quot;")%>" placeholder="Special Render Method.">
	<button onclick="send()">Change Role</button>
	
	
	<hr/>
	<%=u.toJson() %>
	
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
	
		function send(){
			var para={
				"id":"<%=id%>",
				"role":document.getElementById("role").value,
				"color":document.getElementById("color").value
			}
			
			httpPost("changeCol.jsp",para);
		}
	</script>
</body>
</html>