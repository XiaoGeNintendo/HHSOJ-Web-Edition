<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>

<title>HHSOJ-Register</title>
</head>
<body>
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
		
		
		for(var i=0;i<un.length;i++){
			if(un.charAt(i)>='A' && un.charAt(i)<='Z' || un.charAt(i)>='a' && un.charAt(i)<='z' || un.charAt(i)>='0' && un.charAt(i)<='9'){
				
			}else{
				alert('Username should contain alaphbet and numbers only');
				return false;
			}
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
	
	<div class="container">
		<h1 class="title">Register</h1>
		<i class="subtitle">F**K YOU LEATHERMAN!WHY DO THESE F**KING PROBLEMS? --IC</i>
		<hr />
		<jsp:include page="nav.jsp?at=register"></jsp:include>
		
		<div class="card login-form"><div class="card-body">
			<form action="doregister.jsp" onsubmit="return call()" method="post" name="register">
				<div class="input-group">
					<input type="text" class="form-control" placeholder="Username" name="username" maxlength="50" />
				</div>

				<div class="input-group">
					<input type="password" class="form-control" placeholder="Password" name="password" maxlength="50" />
				</div>
				
				<div class="input-group">
					<input type="text" class="form-control" placeholder="Email" name="email" maxlength="50" />
				</div>
				
				<div class="input-group">
					<input type="text" class="form-control" placeholder="Personal Line" name="line" />
				</div>
				
				<div class="input-group">
					<input type="submit" value="Register" class="btn btn-primary" style="margin:5px auto;"/>
				</div>
			</form>
		</div></div>
	</div>
</body>
</html>