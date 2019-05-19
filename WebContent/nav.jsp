<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<!-- Generated header -->
<%
	String nowAt = request.getParameter("at");
	String user = (String) session.getAttribute("username");

	if (nowAt == null) {
		out.println("ERROR:Permission denied");
		return;
	}

	String[] text = new String[] { "Home", "Problems", "Status", "Submit", "Community", "Contests" };
	String[] link = new String[] { "index.jsp", "problemset.jsp", "status.jsp", "submit.jsp", "blogs.jsp",
			"contests.jsp" };
%>
<div id="nav" class="navbar navbar-expand-sm">
	<ul class="navbar-nav ml-auto">
		<%
			for (int i = 0; i < text.length; i++) {
		%>
		<li class="nav-item"><a href="<%=link[i]%>"
			class="nav-link <%=(link[i].startsWith(nowAt) ? "selected" : "")%>"><%=text[i]%></a>
		</li>
		<%
			}
		%>
	</ul>

	<ul class="navbar-nav mr-auto">
		<%
			if (user == null) {
		%>
		<li class="nav-item">
		<a href="<%="login.jsp?back=" + nowAt%>" class="<%="nav-link" + (nowAt.equals("login") ? " selected" : "")%>">Login</a>
		</li>
		<li class="nav-item">
		<a href="register.jsp" class="<%="nav-link" + (nowAt.equals("register") ? " selected" : "")%>">Register</a>
		</li>
		<%
			} else {
				Users u=new UserHelper().getUserInfo(user);
		%>
		<li class="nav-item dropdown">
			<a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#"><%=user%></a>
	      	<div class="dropdown-menu">
		        <a class="dropdown-item" href="<%="users.jsp?username=" + user%>"><i class="fa fa-user"></i>Profile</a>
		        <a class="dropdown-item" href="mailbox.jsp"><i class="fa fa-comment"></i>Mailbox<sup><%=u.getTalks().size()-1-u.getViewIndex()%></sup></a>
		        <a class="dropdown-item" href="settings.jsp"><i class="fa fa-cog"></i>Settings</a>
		        <a class="dropdown-item" href="social.jsp"><i class="fa fa-cogs"></i>Preference</a>
		        <a class="dropdown-item" href="status.jsp?userId=<%=user%>"><i class="fa fa-legal"></i>Submissions</a>
		        <a class="dropdown-item" href="blogs.jsp?userF=<%=user%>"><i class="fa fa-pencil-square-o"></i>Blogs</a>
		    </div>
		</li>
		
		
		<li class="nav-item">
		<a href="lock.jsp" class="nav-link">Lock</a>
		</li>
		
		<li class="nav-item">
		<a href="<%="logout.jsp?back=" + nowAt%>" class="nav-link">Logout</a>
		</li>
		<%
			}
		%>
	</ul>
</div>
<div class="seperator"></div>
<br />
</body>
</html>