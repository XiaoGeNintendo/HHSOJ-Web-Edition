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
	
	<%
		String type=request.getParameter("type");
		if(type!=null && type.equals("submit")){
			
	%>
		<script>
			alert('Please login to submit.');
		</script>
	<%
		}
	
	%>
	
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
		<h1 id="title">Login</h1>
		<i id="subtitle">We simply used files to store user's names and passwords --XGN</i>
		<hr/>
		<jsp:include page="nav.jsp?at=login"></jsp:include>
		
		
		<form action="dologin.jsp" onsubmit="return call()" method="post" name="login">
			<table align="center" id="login_table">
				<tr>
					<td><p>Username:</p></td>
					<td><input type="text" maxlength="50" name="username"/></td>
				</tr>
				<tr>
					<td><p>Password:</p></td>
					<td><input type="password" maxlength="50" name="password"/></td>
				</tr>

				<tr>
					<td colspan="2" style="text-align:center;" >
						<input type="hidden" name="type" value="<%=type %>">
						<input type="submit" value="Login" style="width:90px;height:30px;margin-top:20px;" />
					</td>
				</tr>
			</table>
		</form>
</body>
</html>