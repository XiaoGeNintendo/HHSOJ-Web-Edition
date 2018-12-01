<%@page import="com.hhs.xgn.jee.hhsoj.type.Contest"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ContestHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>HHSOJ - Contest Config</title>
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
		if(id==null){
			return;
		}
		Contest c=new ContestHelper().getContestDataById(id);
		if(c==null){
			return;
		}
		
	%>
		<h1>HHSOJ Contest Configuration Platform for <%=c.getInfo().getName() %></h1>
		<hr/>
		<h2>Full Json Information</h2>
		<%=c.toJson() %>
		<hr/>
		<h2>Config</h2>
		<a href="sys.jsp?id=<%=c.getId() %>">Run system test</a> <br/>
		<a href="pr.jsp?id=<%=c.getId() %>">Pend Rating Change</a> <br/>
		<input id="time" placeholder="input 'x' "/>
		<button id="delay">Delay by x minutes</button>
		<button id="inclen">Increase length by x minutes</button>
		
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
			
			document.getElementById("delay").addEventListener("click",function(){
				//Post the data	
				var min=document.getElementById("time").value;
				//Send a post request
				var para = {
					"time" : min,
				}

				httpPost("delay.jsp?id=<%=c.getId()%>", para);
			});
			
			document.getElementById("inclen").addEventListener("click",function(){
				//Post the data	
				var min=document.getElementById("time").value;
				//Send a post request
				var para = {
					"time" : min,
				}

				httpPost("inc.jsp?id=<%=c.getId()%>", para);
			});
		</script>
</body>
</html>