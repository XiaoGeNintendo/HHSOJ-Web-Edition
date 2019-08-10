<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>

<title>HHSOJ-Change Settings</title>
<style type="text/css">
	#login_table {
		border: 0px;
	}
	
	#login_table th{
		padding: 2px;
		border: 0px;
	}
	
	#login_table th{
		padding: 2px;
		border: 0px;
	}
</style>
</head>
<body>
	<script>
	function call(){
		var psd=this.document.forms['setting']['password'].value;
		var un=this.document.forms['setting']['username'].value;
		if(psd==undefined || un==undefined){
			alert('Why do you register with an out-dated explorer?');
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
		
		return true;
	}
	</script>
	
	<%
		String userNow=(String)session.getAttribute("username");
		if(userNow==null){
			out.println("Permission denied");
			return;
		}
	%>
	
<div class="container">
	<h1 class="title">Change Settings</h1>
	<i class="subtitle">Leave the blank empty if you don't want to change it</i>
	<hr />
	<jsp:include page="nav.jsp?at=index"></jsp:include>
	
	<div class="card login-form"><div class="card-body">
		<form onsubmit="return call()" action="dosetting.jsp" method="post" name="setting">
			<div class="input-group">
				<input type="text" class="form-control" placeholder="Username" name="username" maxlength="50" />
			</div>
			<div class="input-group">
				<input type="password" class="form-control" placeholder="Password" name="password" maxlength="50" />
			</div>
			<div class="input-group">
				<input type="password" class="form-control" placeholder="New password" name="newPassword" maxlength="50" />
			</div>
			<div class="input-group">
				<input type="text" class="form-control" placeholder="Presonal line" name="line" maxlength="50" />
			</div>
			<div class="input-group">
				<input type="text" class="form-control" placeholder="URL to your icon" name="icon"/>
			</div>
			<div class="input-group">
				<input type="checkbox" name="info"/>
				<p>Receive Contest notification via email?</p>
			</div>
			<div class="input-group">
				<input type="submit" value="Change" class="btn btn-primary" style="margin:5px auto;"/>
			</div>
		</form>
	</div></div>
</div>
</body>
</html>