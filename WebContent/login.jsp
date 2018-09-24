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
			var un=this.document.forms['login']['username'].value;
			var psd=this.document.forms['login']['password'].value;
			if(un==undefined || psd==undefined){
				alert('Why do you login with an out-dated explorer?');
				return false;
			}
			
			if(un==null || un==""){
				alert('Username is required');
				return false;
			}
			
			if(psd==null || psd==""){
				alert('Meow~ Don\'t you have a password?(●\'◡\'●)');
				return false;
			}
			
			return true;
		}
		
	</script>
	<center>
		<h1>Login</h1>
		<i>We simply used files to store user's names and passwords --XGN</i>
		<hr/>
		<form action="dologin.jsp" onsubmit="return call()" method="post" name="login">
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
					<td colspan="2">
						<input type="submit" value="Login">
					</td>
				</tr>
			</table>
		</form>
	</center>
</body>
</html>