<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="index.css" rel="stylesheet" type="text/css">
<title>HHSOJ-Login</title>
</head>
<body>
	<a href="index.jsp">←Back</a>
	<script>
	function call(){
		var un=this.document.forms['register']['username'].value;
		var psd=this.document.forms['register']['password'].value;
		var email=this.document.forms['register']['email'].value;
		var line=this.document.forms['register']['line'].value;
		if(un==undefined || psd==undefined || email==undefined || line==undefined){
			alert('Why do you register with an out-dated explorer?');
			return false;
		}
		
		if(un==null || un==""){
			alert('Username is required');
			return false;
		}
		
		if(psd==null || psd==""){
			alert('password is required');
			return false;
		}
		
		if(email==null || email==""){
			alert('We need to have your email to prevent flood attack. Sorry for that.');
			return false;
		}
		if(line==null || line==""){
			alert('Input here something you would like to say!');
			return false;
		}
		return true;
	}
	</script>
	<center>
		<h1>Register</h1>
		<i>F**K YOU LEATHERMAN!WHY DO THESE F**KING PROBLEMS? --IC</i>
		<hr/>
		<form onsubmit="return call()" action="doregister.jsp" method="post" name="register">
			<table align="center">
				<tr>
					<td>Username:</td>
					<td><input type="text" maxlength="50" name="username"/></td>
				</tr>
				<tr>
					<td>Password:</td>
					<td><input type="password" maxlength="50" name="password"/></td>
				</tr>
				
				<tr>
					<td>Email:</td>
					<td><input type="text" maxlength="50" name="email"/></td>
				</tr>
				
				<tr>
					<td>sentence:</td>
					<td><input type="text" name="line"/></td>
				</tr>
				
				<tr>
				
					<td colspan="2">
						<input type="submit" value="Register">
					</td>
				</tr>
			</table>
		</form>
		
		
	</center>
</body>
</html>