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

<title>HHSOJ-Blogs</title>
</head>
<body>
	<!-- Default Template -->
	<h1 id="title">User Search</h1>
	<i id="subtitle">Who is the person you are looking for? --XGN</i>
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
		String sort=chk.chk("sort");
		
	%>
	<!-- Default End-->
	
	<center>
		<form action="userSearch.jsp" method="get">
			<table>
				<tr>
					<td align="center">
						Username:
						<input name="username" placeholder="Regex Supported">
					</td>
				</tr>
				
				<tr>
					<td align="center">
						Sort as:
						<select name="sort">
							<option value="az">A-Z</option>
							<option value="ratinga">Rating Asec.</option>
							<option value="ratingd">Rating Desc.</option>
							
						</select>
					</td>
				</tr>
				<tr>
					<td align="center">
						<input type="submit" value="Submit">
					</td>
				</tr>
			</table>
		</form>
	
		<hr/>
		
		<table width="80%" border="1">
		
			<tr>
				<th align="center" width="80%">Username</th>
				<th align="center" width="20%">Rating</th>
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
				<td align="center"><%=new UserRenderer().getUserText(u) %></td>
				<td align="center"><%=u.getNowRating() %></td>
			</tr>
			<%
					}
				}
			%>
		</table>
	
	</center>
	
	
</body>
</html>