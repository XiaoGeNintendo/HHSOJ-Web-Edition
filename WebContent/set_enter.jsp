<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>

<title>HHSOJ-Problemsetter Menu</title>
<style type="text/css">
.w-e-text-container {
	background: #ffffff;
	height: 400px;
}
</style>
</head>
<body>
	<div class="container">
		<!-- Default Template -->
		<h1 class="title">Problemsetter Menu</h1>
		<i class="subtitle">Ninja Setters! -- HackerEarth</i>
		<hr />

		<jsp:include page="nav.jsp?at=problemset"></jsp:include>
		<%
			String userLooking = (String) session.getAttribute("username");
			if (userLooking == null) {
				out.println("Please login to continue");
				return;
			}
			Users u=new UserHelper().getUserInfo(userLooking);
			if(!u.isSetter()){
				out.println("Access denied");
				return;
			}
			
		%>
		<!-- Default End -->

		

	</div>
</body>
</html>