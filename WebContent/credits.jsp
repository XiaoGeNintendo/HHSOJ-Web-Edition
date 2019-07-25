<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>

<title>HHSOJ - Credits</title>
	<style type="text/css">
		#credits-table {
			border-collapse: collapse;
			align-self: center;
			margin: 0px auto;
			border:1px solid #cccccc;
			background:#f0f0f0;
		}
		
		#credits-table th{
			text-align:center;
			padding: 10px;
			border: 1px solid #cccccc;
		}
		
		#credits-table td{
			text-align:center;
			padding: 10px;
			border: 1px solid #cccccc;
		}
	</style>
</head>
<body>

	<div class="container">
		<h1 class="title">Credits</h1>
		<i class="subtitle">I prefer cash :) --XGN</i>
		<hr />
		<jsp:include page="nav.jsp?at=index"></jsp:include>
		
		<center>
			<table id="credits-table">
				
				<tr id="creditHead">
					<th>Photo</th>
					<th>Name</th>
					<th>Description</th>
				</tr>
				
				<tr class="creditUser">
					<td>
						<img alt="XiaoGeNintendo" src="asset/XGN.png" height="100" width="100">
					</td>
					<td>XiaoGeNintendo</td>
					<td>The main developer.<br/><a href="mailto:gwq0419@163.com">Get him!</a></td>	
				</tr>
				
				<tr class="creditUser">
					<td>
						<img alt="Zzzyt" src="asset/Zzzyt.jpg" height="100" width="100">
					</td>
					<td>Zzzyt</td>
					<td>The CSS developer and the author of getoj.py<br/><a href="mailto:fcy2017068@126.com">Get him!</a></td>	
				</tr>
				
				<tr class="creditUser">
					<td>
						<img alt="XIZCM" src="asset/xizcm.jpg" height="100" width="100">
					</td>
					<td>XIZCM</td>
					<td>The author of getoj.sh<br/><a href="https://github.com/DamnXIZCM">Get him!</a></td>	
				</tr>
				
				<!-- Add your developers here -->
			</table>
			<br/>
			<a href="https://github.com/XiaoGeNintendo/HHSOJ-Web-Edition" class="btn btn-primary"><i class="fa fa-github"></i> Github Source Link</a>
		</center>
	</div>
</body>
</html>