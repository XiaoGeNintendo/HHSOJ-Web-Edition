<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>
<title>HHSOJ - Forget Password</title>
</head>
<body>
	<center>
		<h1>Resetting your password</h1>
		Reset your password by typing your username.<br/>
		Then click "send me an email" <br/>
		Then type the code you received in the box to reset your password <br/>
		
		<hr/>
		<div class="form-group">
	      <label>Username:</label>
	      <input class="form-control" id="usr" placeholder="Enter username">
	    </div>
	    <button type="submit" onclick="sendE()" class="btn btn-primary">Send me an email</button>
	    
	    <hr/>
	    <div class="form-group">
	      <label>Code:</label>
	      <input class="form-control" id="code" placeholder="Enter Code">
	    </div>
	    <button type="submit" onclick="sendC()" class="btn btn-primary">Verify My Account</button> <br/>
		<a href="index.jsp">(Back to homepage)</a>   	
	</center>
	
	
	<script>
		function sendE(){
			alert("Request Sent. Please be patient and DON'T CLICK THE BUTTON MANY TIMES");
			var para={
				"user":document.getElementById("usr").value,
			}
			$.post("doForget.jsp",para,function(data,status){
				if(status!="success"){
					alert("Failed: return status is "+status);
				}else{
					alert(data.trim());
				}
			})
		}
		
		function sendC(){
			alert("Request Sent. Please be patient and DON'T CLICK THE BUTTON MANY TIMES");
			var para={
				"user":document.getElementById("usr").value,
				"code":document.getElementById("code").value
			}
			
			$.post("doRecover.jsp",para,function(data,status){
				if(status!="success"){
					alert("Failed: return status is "+status);
				}else{
					alert(data.trim());
					
				}
			})
		}
	</script>
</body>
</html>