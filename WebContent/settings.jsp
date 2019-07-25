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
	
	
	<h1 class="title">Change Settings</h1>
	<i class="subtitle">Leave the blank empty if you don't want to change it</i>
	<hr />
	<jsp:include page="nav.jsp?at=index"></jsp:include>
	
	<form onsubmit="return call()" action="dosetting.jsp" method="post" name="setting">
		<table align="center" id="login_table">
			<tr>
				<td>Username:</td>
				<td><input type="text" maxlength="50" name="username"/></td>
			</tr>
			
			<tr>
				<td>Password(required):</td>
				<td><input type="password" maxlength="50" name="password"/></td>
			</tr>
			
			<tr>
				<td>New Password:</td>
				<td><input type="password" maxlength="50" name="newPassword"/></td>
			</tr>
			
			<tr>
				<td>Sentence:</td>
				<td><input type="text" name="line"/></td>
			</tr>
			
			<tr>
				<td><acronym title="Input an address on Internet to your picture">Icon:</acronym></td>
				<td><input type="text" name="icon" value="http://..."/></td>
			</tr>
			
			<tr>
				<td><input type="checkbox" name="info" ></td>
				<td>Receive Contest Information?</td>
				
			</tr>
			
			<tr>
			
				<td colspan="2"  style="text-align:center;" >
					<input type="submit" value="Change" style="width:90px;">
				</td>
			</tr>
		</table>
	</form>
	
</body>
</html>