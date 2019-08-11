<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserRenderer"%>
<%@page import="java.util.Comparator"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Blog"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.BlogHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>

<title>HHSOJ - User Search</title>
</head>
<body>
<div class="container">
	<!-- Default Template -->
	<h1 class="title">User Search</h1>
	<i class="subtitle">Who is the person you are looking for? --XGN</i>
	<hr />
	<jsp:include page="nav.jsp?at=blogs"></jsp:include>
		
	<%
		String userLooking=(String)session.getAttribute("username");
	
		class Chk{
			String chk(String x){
				return (request.getParameter(x)==null?"":request.getParameter(x));
			}	
		};
		
		Chk chk=new Chk();
		
		String matcher=chk.chk("username");
		
		try{
			"".matches(matcher);
		}catch(Exception e){
			matcher="";
			
			%>
			<center>
				<div class="alert alert-danger alert-dismissible fade show" style="width:500px;">
				    <button type="button" class="close" data-dismiss="alert">&times;</button>
				    <strong>Error!</strong> Please enter a valid regex!
		  		</div>
		  	</center>
			<%
		}
		
		String sort=chk.chk("sort");
		
	%>
	<!-- Default End-->
	
	<center>
		<form action="userSearch.jsp" method="get" style="width:500px;">
			<div class="input-group">
				<div class="input-group-prepend">
					<span class="input-group-text">Uername</span>
				</div>
				<input type="text" class="form-control" name="username" placeholder="Use Regex. eg: XG.*">
			</div>
			<div class="input-group">
				<div class="input-group-prepend">
					<span class="input-group-text">Sorting</span>
				</div>
				<select class="form-control" name="sort">
					<option value="az">A-Z</option>
					<option value="ratinga">Rating Asec.</option>
					<option value="ratingd">Rating Desc.</option>	
				</select>
			</div>
			<input class="btn btn-primary" type="submit" value="Submit">
		</form>
	
		<hr/>
		
		<table class="table table-bordered table-sm" style="width:80%;">
		
			<tr>
				<th width="80%">Username</th>
				<th width="20%">Rating</th>
			</tr>
			
			<%
				ArrayList<Users> users=new UserHelper().getAllUsers();
			
				users.sort(new Comparator<Users>(){
					public int compare(Users o1, Users o2){
						if(sort.equals("az")){
							return o1.getUsername().compareTo(o2.getUsername());
						}
						if(sort.equals("ratinga")){
							return Integer.compare(o1.getNowRating(), o2.getNowRating());
						}
						return -Integer.compare(o1.getNowRating(), o2.getNowRating());
					}
				});
				
				for(Users u:users){
					if(u.getUsername().matches(matcher)){
			%>
			<tr>
				<td><%=new UserRenderer().getUserText(u) %></td>
				<td><%=u.getNowRating() %></td>
			</tr>
			<%
					}
				}
			%>
		</table>
	
	</center>
	
</div>
</body>
</html>