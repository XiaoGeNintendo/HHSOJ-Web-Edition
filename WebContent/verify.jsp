<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>
</head>
<body>
	<center>
		<h1>Verifying your email</h1>
		Hello! In order to keep the website safe, you need to verify your email address. <br/>
		Enter your username and password below and click "Send me an email". <br/>
		Then go to your email mailbox to check the verify code. <br/>
		Sorry for the inconvenience! <br/>
		
		<hr/>
		<div class="form-group">
	      <label>Username:</label>
	      <input class="form-control" id="usr" placeholder="Enter username">
	    </div>
	    <div class="form-group">
	      <label for="pwd">Password:</label>
	      <input type="password" class="form-control" id="pwd" placeholder="Enter password">
	    </div>
	    <button type="submit" onclick="sendE()" class="btn btn-primary">Send me an email</button>
	    
	    <hr/>
	    <div class="form-group">
	      <label>Code:</label>
	      <input class="form-control" id="code" placeholder="Enter Code">
	    </div>
	    <button type="submit" onclick="sendC()" class="btn btn-primary">Verify My Account</button>
		<a href="index.jsp">(Back to homepage)</a>   	
	</center>
	
	
	<script>
		function sendE(){
			alert("Request Sent. Please be patient and DON'T CLICK THE BUTTON MANY TIMES");
			var para={
				"user":document.getElementById("usr").value,
				"pwd":document.getElementById("pwd").value
			}
			$.post("doVerify.jsp",para,function(data,status){
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
				"pwd":document.getElementById("pwd").value,
				"code":document.getElementById("code").value
			}
			
			$.post("doCheck.jsp",para,function(data,status){
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