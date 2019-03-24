<%@page import="com.hhs.xgn.jee.hhsoj.db.TypeMaster"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserRenderer"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.PatternMatcher"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.VerdictHelper"%>
<%@page import="java.util.Comparator"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.SubmissionHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Submission"%>
<%@page import="java.util.ArrayList"%>


<%
		
	String userPattern=request.getParameter("userId");
	String probPattern=request.getParameter("probId");
	String verdictPattern=request.getParameter("verdictId");

%>
			
		
			<tr>
				<th width="5%">Type</th>
				<th width="10%">#</th>
				<th width="15%">ProbID</th>
				<th width="35%">Verdict</th>
				<th width="10%">Time Cost</th>
				<th width="10%">Memory Cost</th>
				<th width="20%">User</th>
			</tr>
			
			<!-- Start for here -->
			<%
				
				ArrayList<Submission> sb=new SubmissionHelper().getAllSubmissions();
				
				sb.sort(new Comparator<Submission>(){
					public int compare(Submission o1, Submission o2){
						if(o1.getId()>o2.getId()){
							return -1;
						}
						if(o1.getId()<o2.getId()){
							return 1;
						}
						return 0;
					}
				});
				
				int id=-1;
				try{
					id=Integer.parseInt(request.getParameter("id"));
				}catch(Exception e){
					
				}
				
				int cnt=0;
				for(Submission s:sb){
					try{
						if(new PatternMatcher().match(s,userPattern,probPattern,verdictPattern)){
					
			%>
							<tr bgcolor="<%=(id==s.getId()?"cyan":(cnt%2==0?"white":"#efefef"))%>">
								<td><%=TypeMaster.render(s) %></td>
								<td><a href="submission.jsp?id=<%=s.getId()%>"> <%=s.getId() %> </a></td>
								
								<td><a href="problem.jsp?id=<%=s.getProb()%>"> <%=s.getProb() %><sup><abbr title="Testset:<%=s.getTestset() %>"><%=s.getTestset().substring(0,1).toUpperCase() %></abbr></sup> </a></td>
								<td><div lastmode="0"><%=new VerdictHelper().render(s.getHTMLVerdict())%></div></td>
								<td><%=s.getTimeCost() %></td>
								<td><%=s.getMemoryCost() %></td>
								<td><%out.println(new UserRenderer().getUserText(s.getUser())+(s.isRated()?"<sup><abbr title=\"In-contest submission\">#</abbr></sup>":"")); %></td>
							</tr>
			
			<%
						cnt++;
						}
					}catch(Exception e){			
			%>
						<tr bgcolor="<%=(id==s.getId()?"cyan":(cnt%2==0?"white":"#efefef"))%>">
							<td colspan="7">Error:<%=e %></td>
						</tr>
			<%
					}
				}
			%>
	