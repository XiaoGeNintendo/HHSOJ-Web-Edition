<%@page import="com.hhs.xgn.jee.hhsoj.type.Problem"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserRenderer"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.ProblemHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.VerdictHelper"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.TestResult"%>
<%@page import="com.hhs.xgn.jee.hhsoj.type.Submission"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.SubmissionHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>


<title>HHSOJ-Submission <%=request.getParameter("id") %></title>
</head>
<body>
	<script src="https://ajax.aspnetcdn.com/ajax/jquery/jquery-1.9.0.min.js"></script>
	<script src="js/wangHighLighter-1.0.0-min.js" type="text/javascript"></script>
	
	
	<%
		int id=-1;
		Submission s=new Submission();
		Problem p=null;
		try{
			id=Integer.parseInt(request.getParameter("id"));
			s=new SubmissionHelper().getSubmission(id);
			s.getCompilerComment(); //test null
			p=new ProblemHelper().getProblemData(s.getProb());
			
		}catch(Exception e){
			out.println("Submission doesn't exist");
			out.println("<a href=\"javascript:location.replace(document.referrer);\">←Back</a>");
			return;
		}
		
		String userLooking=(String)session.getAttribute("username");
		if(s.isRated() && new ProblemHelper().getProblemData(s.getProb()).getContest().isContestRunning()){
			
			if(s.getUser().equals(userLooking)==false){
				s.setCode("No cheating during contests!!!");	
			}
			
			s.setResults(new ArrayList<>());
		}
	%>
	
	<script>
	
		function hack(){
			$.post("doHack.jsp",{id:<%=s.getId()%>,data:document.getElementById("hackData").value},function(text,status){
				if(status!=200){
					alert("hi,your hack has been received:\n"+text.trim());
				}else{
					alert("hi,your hack hasn't been received:\n"+"Error when sending information:"+status+" "+text.trim());
				}
			});
		}
		
		function code(){
			var highLightCode = wangHighLighter.highLight("<%=s.getLang().equals("cpp")?"C++":s.getLang()%>", "simple", "<%=s.getCode().replace("\\","\\\\").replace("\n", "\\n").replace("\r","\\r").replace("\t","\\t").replace("\"","\\\"").replace("</script>","</son>") %>");
			this.document.write("<div id=\"code\">");
			this.document.write(highLightCode);
			this.document.write("</div>");
		}
		
		function open(){
			this.document.getElementById("code").innerHTML="<pre>"+"<%=s.getCode().replace("\\","\\\\").replace("\n", "\\n").replace("\r","\\r").replace("\t","\\t").replace("\"","\\\"").replace("</script>","</son>").replace("<","&lt;").replace(">","&gt;") %>"+"</pre>";
		}
		
	</script>
	
	<!-- Default Template -->
	<h1 id="title">Submissions on HHSOJ</h1>
	<i id="subtitle">Ctrl+A Ctrl+C help me get AC!  --IC</i>
	<hr />
	<jsp:include page="nav.jsp?at=status"></jsp:include>
	<!-- Default End -->
	
	<center>
		<h1>Submission <%=id %> on HHSOJ</h1>
	</center>
	
		<h2>Basic Information</h2>
	
		Submission ID:<%=id %> <br/>
		Problem ID:<a href="problem.jsp?id=<%=s.getProb() %>"><%=s.getProb() %></a><br/>
		Submission Owner:<%out.println(new UserRenderer().getUserText(s.getUser()));%><br/>
		Submission Language:<%=s.getLang() %><br/>
		Submission Verdict:<%=new VerdictHelper().render(s.getHTMLVerdict())%><br/>
		Submission Time Cost:<%=s.getTimeCost() %><br/>
		Submission Memory Cost:<%=s.getMemoryCost() %><br/>
		Submission Submit Time:<%=s.getReadableTime() %><br/>
		Submission Testset:<%=s.getTestset() %> <br/>
		
		<h2>Code</h2>
		
		<%
			
			if(userLooking !=null && userLooking.equals(s.getUser())){
				
		%>
			<a href="javascript:open()">Copy code</a>
		<%
			}
		%>
		<script>
			code();
		</script>
		
		<br/>
		
		<%
			boolean[] query=new boolean[]{userLooking!=null,s.getVerdict().equals("Accepted"),p.isHackable(s.getTestset())};
			String[] sentence=new String[]{"You didn't login","Solution isn't accepted","Testset doesn't support hacking"};
			
			boolean tot=true;
			for(int i=0;i<query.length;i++){
				tot&=query[i];
			}
			
			
			if(tot){
		%>
			<div class="card bg-primary text-white">
			    <div class="card-body">
			    	Let me give a <button type="button" class="btn btn-danger" data-toggle="modal" data-target="#myModal">Hack</button> <br/>
			    </div>
			</div>
			
		<%
			}else{
				
		%>
			<div class="card bg-secondary text-white">
			    <div class="card-body">
			    	Solution Is Unhackable For: <br/>
			    	<ul>
			    		<%
			    			for(int i=0;i<query.length;i++){
			    				if(query[i]==false){
			    					out.println("<li>"+sentence[i]+"</li>");
			    				}
			    			}
			    		%>
			    	</ul>
			    </div>
			</div>
		<%
			}
		%>
		
		<br/>
		
		<h2>Compiler Comment</h2>
		<pre><%=s.getCompilerComment().replace("<","&lt;").replace(">","&gt;") %></pre>
		
		<h2>Testcases Information</h2>
		<%
			int cnt=1;
			for(TestResult tr:s.getResults()){
						
		%>
				<b>Test#<%=cnt %>:</b>
				<b><%=tr.getFile() %> </b>
				<b>Verdict:<%=new VerdictHelper().render(tr.getVerdict())%></b>
				<b>Time cost:<%=tr.getTimeCost() %>ms </b>
				<b>Memory cost:<%=tr.getMemoryCost() %>KB </b>
				<b>Checker comment:</b><br/>
				<pre><%=tr.getCheckerComment() %></pre>
				<br/><br/>
				
		<%
			cnt++;
			}
		%>
		
		<!-- 模态框 -->
		  <div class="modal fade" id="myModal">
		    <div class="modal-dialog">
		      <div class="modal-content">
		   
		        <!-- 模态框头部 -->
		        <div class="modal-header">
		          <h4 class="modal-title">Hack Submission <%=s.getId() %></h4>
		          <button type="button" class="close" data-dismiss="modal">&times;</button>
		        </div>
		   
		        <!-- 模态框主体 -->
		        <div class="modal-body">
		          	<textarea id="hackData" rows="5" cols="60" title="Hack data" placeholder="Input hack data"></textarea>
		        </div>
		   
		        <!-- 模态框底部 -->
		        <div class="modal-footer">
		          <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="hack()">Hack</button>
		          <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
		        </div>
		   
		      </div>
		    </div>
		  </div>
		  
</body>
</html>