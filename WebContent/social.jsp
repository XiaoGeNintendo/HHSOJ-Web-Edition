<%@page import="com.hhs.xgn.jee.hhsoj.type.PreferUnit"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
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
	
	<%
		String userNow=(String)session.getAttribute("username");
		if(userNow==null){
			out.println("Permission denied");
			return;
		}
		
		Users u=new UserHelper().getUserInfo(userNow);
		if(u==null){
			out.println("Permission denied");
			return;
		}
	%>
	
	
	<h1 id="title">Change Preferences</h1>
	<i id="subtitle">Information! --XGN</i>
	<hr />
	<jsp:include page="nav.jsp?at=index"></jsp:include>
	
	<form action="doprefere.jsp" method="post">
		<table align="center" id="login_table">
			<%
				for(Entry<String,PreferUnit> e:u.getPreference().units.entrySet()){
			%>
					<tr>
						<td>
							<%=e.getValue().shownName%>:
						</td>
						<td>			
			<%
					if(e.getValue().isChosen){
			%>
						<select name="value_<%=e.getKey()%>">
							<%
								for(String r:e.getValue().choice){
							%>
									<option value="<%=r %>" <%=(e.getValue().value.equals(r)?"selected":"") %>><%=r %></option>				
							<%
								}
							%>
						</select>
			<%
					}else{
			%>
						<input name="value_<%=e.getKey()%>" value="<%=e.getValue().value%>">
			<%
					}
			%>
					</td>
					<td>
					<input type="checkbox" name="public_<%=e.getKey() %>" <%=e.getValue().isPublic?"checked=\"checked\"":"" %>>Public This Information
					</td>
					</tr>				
			<%
				}
			%>
			<tr>
				<td colspan="3">
					<input type="submit" value="Submit">
				</td>
			</tr>
		</table>
	</form>

</body>
</html>