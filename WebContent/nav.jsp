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

	String[] text = new String[] { "Home", "Problems", "Status", "Submit", "Community","Contests" };
	String[] link = new String[] { "index.jsp", "problemset.jsp", "status.jsp", "submit.jsp", "blogs.jsp", "contests.jsp"};
%>
<div id="nav" class="navbar navbar-expand-sm">
<ul class="navbar-nav">
	<%
		for (int i = 0; i < text.length; i++) {
	%>
	<li class="nav-item">
	<a href="<%=link[i]%>"
		class="nav-link nav-link-left <%=(link[i].startsWith(nowAt) ? "selected" : "")%>"><%=text[i]%></a>
		</li>
	<%
		}
	%>


<%
	if(user==null){
		out.println("<a href=\"login.jsp?back="+nowAt+"\" class=\"nav-item nav-link-right "+(nowAt.equals("login")?"selected":"")+"\">Login</a>");
		out.println("<a href=\"register.jsp\" class=\"nav-item nav-link-right "+(nowAt.equals("register")?"selected":"")+"\">Register</a>");
	}else{
		out.println("<a href=\"users.jsp?username=" + user + "\" class=\"nav-item nav-link-right\">" + user + "</a>");
		out.println("<a href=\"logout.jsp?back="+nowAt+"\" class=\"nav-item nav-link-right\">Logout</a>");
	}

%>
</ul>
</div>
<div class="seperator"></div>
<br />
</body>
</html>