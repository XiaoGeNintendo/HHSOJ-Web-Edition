<%@page import="java.util.Date"%>
<%@page import="java.util.Map.Entry"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page
	import="com.hhs.xgn.jee.hhsoj.db.*,com.hhs.xgn.jee.hhsoj.type.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<jsp:include page="head.jsp"></jsp:include>
	<title>HHSOJ-Mailbox</title>
</head>
<body>
	<%
		String user=(String)session.getAttribute("username");
		if(user==null || user.equals("")){
			out.println("Login, ok?");
			return;
		}
		Users u=new UserHelper().getUserInfo(user);
		
		int lastView=u.getViewIndex();
		if(u.getViewIndex()!=u.getTalks().size()-1){
			u.setViewIndex(u.getTalks().size()-1);
			new UserHelper().refreshUser(u);
		}
		String with=request.getParameter("with");
	%>

	<!-- Default Template -->
	<h1 id="title">My Mailbox</h1>
	<i id="subtitle">Don't judge yourself that negatively! --ZKY&Zzzyt</i>
	<hr />
	<jsp:include page="nav.jsp?at=index"></jsp:include>
	<!-- Default End -->
	
	<center>
		<i>Showing mails with <%=(with==null?"Anyone":with) %> only</i> <br/>
		<a href="newMail.jsp<%=(with==null?"":"?with="+with)%>"><b>I wanna write a new mail...</b></a><br/>
		
	<%
		for(int i=u.getTalks().size()-1;i>=0;i--){
			Mail m=u.getTalks().get(i);
			if(with==null || m.getSender().equals(with) || m.getTo().equals(with)){
	%>
				<div class="card <%=(m.getSender().equals(user)?"bg-primary":"") %>" style="width:80%">
					<div class="card-header">
				    	<%if(i>lastView){ %>
				    		<i class="fa fa-bell-o" title="New message"></i>
				    	<%} %>
				    	
				    	<%=new UserRenderer().getUserText(m.getSender()) %> --&gt; <%=new UserRenderer().getUserText(m.getTo()) %> on <%=new Date(m.getTime()) %>
				    </div>
				    <div class="card-body">
				    	<%=m.getText() %>
				    </div>
				</div>
				<br/> <br/>
	<%
			}
		}
	%>
	
	</center>
</body>
</html>