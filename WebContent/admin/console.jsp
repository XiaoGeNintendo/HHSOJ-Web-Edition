<%@page import="com.hhs.xgn.jee.hhsoj.db.ConfigLoader"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="https://ajax.aspnetcdn.com/ajax/jquery/jquery-1.9.0.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>HHSOJ - Admin Console</title>
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
	%>
	
	<h1>Console</h1>
	<i>Change file information here</i>
	<hr/>
	
	
	
	<center>
	
		<table border="1">
			<tr>
				<td>
					<b id="position"><%=ConfigLoader.getPath()+"/" %></b>
					</td>
			</tr>
		</table>
		
		<table width="90%" border="1">
			<tr>
				<td align="center">
					<textarea rows="20" cols="50" id="response" placeholder="response"></textarea>	
				</td>
				<td align="center">
					<textarea rows="20" cols="50" id="stream" placeholder="stream"></textarea>
				</td>
			</tr>
		</table>
		
		<input type="text" id="command" onkeydown="send(event)" style="max-width: 1000px; height: 30px; width: 100%;" placeholder="command.."/>
	</center>
	
	<hr/>
	<h1>Command Help</h1>
	
	<pre>
	[] means argument
	() means optimal argument
	
	1. cd [path] - Change the directory path to the [path]. if [path] is ".." it means go back.
	2. cls - Clear the response console
	3. list - List all the files under this path
	4. copy [file] - Copy everything in the [file] under this folder to the stream console
	5. write [file] - Write everything in the stream console to the [file].If it is not created, a new one will be created.
	6. mkdir [foldername] - Create a new directory named [foldername]
	7. del [filename] - Delete the given file/folder.
	</pre>
	
	<script>
	
		function add(obj,str){
			document.getElementById(obj).innerHTML+=str+"\n";
		}
		
		function send(e){
			var keynum
			if(window.event) // IE
			{
			  	keynum = e.keyCode
			}else if(e.which) // Netscape/Firefox/Opera
			{
				keynum = e.which
			}
			
			if(keynum!=13){
				return;
			}
			
			var com=document.getElementById("command").value;
			document.getElementById("command").value="";
			
			if(com=="cls"){
				document.getElementById("response").innerHTML="";
				return;
			}
			
			add("response",">"+com);
			
			var obj={"position":document.getElementById("position").innerHTML,"command":com,"stream":document.getElementById("stream").value};
			
			$.post('reconsole.jsp',obj,function(data,status){
				data=data.replace("\n","");
				data=data.replace("\r","");
				console.log(data);
				
				
				var json = JSON.parse(data);//获取到服务端返回的数据
		        
		        document.getElementById("position").innerHTML=json.position;
		        add("response",json.response);
		        add("response","Response status is "+status);
		        
		        document.getElementById("stream").innerHTML=json.stream;
			})
			
			
			
		}
	</script>
</body>
</html>