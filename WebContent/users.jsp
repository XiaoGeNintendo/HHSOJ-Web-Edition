<%@page import="java.util.Map.Entry"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page
	import="com.hhs.xgn.jee.hhsoj.db.*,com.hhs.xgn.jee.hhsoj.type.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<jsp:include page="head.jsp"></jsp:include>
	
	<title>HHSOJ-<%=request.getParameter("username")%></title>
</head>
<body>
	<%
		String user = request.getParameter("username");
		UserHelper db = new UserHelper();
		Users u = db.getUserInfo(user);
		if (user == null || user.equals("") || u == null) {
			out.println("The users you are looking for is not registered :(");
			out.println("<br/><a href=\"index.jsp\">Back</a>");
			return;
		}
	%>

	<!-- Default Template -->
	<h1 id="title">Users on HHSOJ</h1>
	<i id="subtitle"><%=user%>'s space</i>
	<hr />
	<jsp:include page="nav.jsp?at=index"></jsp:include>
	<!-- Default End -->

	<%
		if(u.isBanned()){		
			out.println("This guy has been banned for some reason. :(");
			return;
		}
	%>
	
	<table border="1">
		<tr><td>
			<b>Goto:</b> <br/>
			<a href="#pre">Preferences</a> <br/>
			<a href="#sub">Submissions</a> <br/>
			<a href="#con">Contests</a> <br/>
			<a href="#solved">Problems</a> <br/>
		</td></tr>
	</table>
	
	<br/>
	
	<table width="80%">
		<tr>
			<th width="50%"></th>
			<th width="50%"></th>
		</tr>

		<tr>
			<td align="left">
				<%out.println(new UserRenderer().getRank(u.getNowRating())); %><br/>
				<%out.println((u.getSpecialRole()==null?"Normal user":UserRenderer.r(u.getSpecialColor(),u.getUsername()))); %>
				<%out.println(new UserRenderer().getUserTextLarge(u));%>
				<br/>
				<i><%=u.getLine()%> -- <%=user%></i> <br /> 
				<img alt="submission" src="asset/submissions.png" />
				<a href="status.jsp?userId=<%=u.getUsername()%>" >Submissions</a> <br /> 
				<img alt="posts" src="asset/posts.png" />
				<a href="blogs.jsp?userF=<%=u.getUsername()%>">Posts by him</a><br />
				<img alt="rating" src="asset/rating.png" />Contest Rating: <%=u.getNowRating()%>(Max.<%=u.getMaxRating()%>) <br /> 
				
	
					<%
						String userLooking = (String) session.getAttribute("username");
								if (user.equals(userLooking)) {
					%> 
							<img alt="setting" src="asset/settings.png"><a href="settings.jsp">Change Settings</a><br />
							<img alt="setting" src="asset/settings.png"><a href="social.jsp">Change Preference Settings</a><br />
							<img alt="talk" src="asset/posts.png"><a href="mailbox.jsp">My Mailbox</a><br />
							 
					<%
					 	}
								
						if(userLooking!=null){				
				%>
							<img alt="knock" src="asset/post.png"><a href="mailbox.jsp?with=<%=user%>">Knock knock..</a><br />
				<%
						}
				    %> 
				    
				
			 </td>
			<td align="right"><img src="<%=u.getUserPic()%>" /></td>
		</tr>
	</table>
	
	<a id="pre"></a>
	<b>Public Information</b> <br/>
	<%
		for(Entry<String,PreferUnit> e:u.getPreference().units.entrySet()){
			if(e.getValue().isPublic && !e.getValue().value.isEmpty()){
	%>
				<p id="pre_<%=e.getKey()%>"><%=e.getValue().shownName %>:<%=e.getValue().value %></p><br/>			
	<%
			}
		}
	%>
	
	<a id="sub"></a>
	<b>Submission Data</b> <br/>
	<div id="langChart"></div>
	<div id="verdictChart"></div>
	
	<a id="con"></a>
	<b>Contest History</b> <br/>
	
	<div id="ratingChart"></div>
	
	<table border="1">
		<tr>
			<th>Contest Name</th>
			<th>Rank</th>
			<th>Rating change</th>
		</tr>
		<%
			int prev=1500;
			for(ContestRecord cr:u.getRatings()){
		%>
				<tr>
					<td><a href="contestWelcome.jsp?id=<%=cr.getId() %>"><%=new ContestHelper().getContestDataById(""+cr.getId()).getInfo().getName() %></a></td>
					<td><%=cr.getPlace() %></td>
					<td><%=prev+"->"+(prev+cr.getRatingChange())+"("+cr.getRatingChange()+")" %></td>
				</tr>
		<%
				prev+=cr.getRatingChange();
			} 
		%>
	</table>
	
	<a id="solved"></a>
	<b>Problem Stats</b><br/>
	<table align="center" width="80%" border="1">
		<tr>
			<th align="center" width="50%">
				<i class="fa fa-star">Solved(<%=u.count(Users.SOLVED) %>)</i>
			</th>
			<th align="center" width="50%">
				<i class="fa fa-star-half-empty">Attempted(<%=u.count(Users.ATTEMPTED) %>)</i>
			</th>
		</tr>
		
		<tr>
			<td align="center">
				<%=u.JScount(Users.SOLVED) %>
			</td>
			<td align="center">
				<%=u.JScount(Users.ATTEMPTED) %>
			</td>
		</tr>
	</table>
	
	<script>
	
		var allContestName=<%=u.JSgetContestName()%>
		
		var chart2 = Highcharts.chart('ratingChart', {
			chart:{
				backgroundColor:'#fafaf8'
			},
		    title: {
		        text: 'Rating'
		    },
	
		    subtitle:{
		        text:"Rating of <%=user%>"
		    },
	
		    credits:{
		        enabled:false
		    },
		    series: [{
		    	name:"Rating",
		    	data:<%=u.JSgetRating()%>
		    }],
			
		    tooltip:{
		    	formatter:function(){
		    		return allContestName[this.x]+" - Rating: "+this.y;
		    	}
		    }
		});
		
		var verChart= Highcharts.chart("verdictChart",{
			chart:{
				backgroundColor:'#fafaf8'
			},

		    title: {
		        text: 'Verdict Pie Graph'
		    },

		    subtitle:{
		        text:"The most common verdicts of <%=user%>"
		    },

		    plotOptions:{
		        pie: {
		           allowPointSelect: true,
		           cursor: 'pointer',
		           dataLabels: {
		              enabled: true,
		              format: '<b>{point.name}</b>: {point.percentage:.1f} % ({point.y})',
		              style: {
		                 color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
		              }
		           }
		        }
		    },

		    credits:{
		        enabled:false
		    },
		    series: [{
		        type:"pie",
		        name:"Submissions",
		        data: <%=u.JSgetVerdict()%>
		    }]
		})
		
		var verChart= Highcharts.chart("langChart",{
			chart:{
				backgroundColor:'#fafaf8'
			},

		    title: {
		        text: 'Language Pie Graph'
		    },

		    subtitle:{
		        text:"Language Perferences of <%=user%>"
		    },

		    plotOptions:{
		        pie: {
		           allowPointSelect: true,
		           cursor: 'pointer',
		           dataLabels: {
		              enabled: true,
		              format: '<b>{point.name}</b>: {point.percentage:.1f} % ({point.y})',
		              style: {
		                 color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
		              }
		           }
		        }
		    },

		    credits:{
		        enabled:false
		    },
		    series: [{
		        type:"pie",
		        name:"Submissions",
		        data: <%=u.JSgetLang()%>
		    }]
		})
		
	</script>
</body>
</html>