<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>

<title>HHSOJ-Login</title>
</head>
<body>

	<%
		String type = request.getParameter("back");
		if (type != null && type.equals("submit")) {
	%>
	<script>
		alert('Please login to submit.');
	</script>
	<%
		}
	%>

	<script>
		function call() {
			var un = this.document.forms['login']['username'].value;
			var psd = this.document.forms['login']['password'].value;
			if (un == undefined || psd == undefined) {
				alert('Why do you login with an out-dated explorer?');
				return false;
			}

			if (un == null || un == "") {
				alert('Username is required');
				return false;
			}

			if (psd == null || psd == "") {
				alert('Meow~ Don\'t you have a password?(●\'◡\'●)');
				return false;
			}

			return true;
		}
	</script>
	<div class="container">
		<h1 class="title">Login</h1>
		<i class="subtitle">We simply used files to store user's names and
			passwords --XGN</i>
		<hr />
		<jsp:include page="nav.jsp?at=login"></jsp:include>

		<div class="card login-form"><div class="card-body">
			<form action="dologin.jsp" onsubmit="return call()" method="post" name="login">
				<div class="input-group">
					<input type="text" class="form-control" placeholder="Username" name="username" maxlength="50" />
				</div>

				<div class="input-group">
					<input type="password" class="form-control" placeholder="Password" name="password" maxlength="50" />
				</div>
				
				<div class="input-group">
					<input type="hidden" name="type" value="<%=type%>">
					<input type="submit" value="Login" class="btn btn-primary" style="margin:5px auto;"/>
				</div>
				
				<a href="forget.jsp">(Forget Your Password?)</a>
			</form>
		</div></div>
	</div>
</body>
</html>