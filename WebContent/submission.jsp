<%@page import="com.hhs.xgn.jee.hhsoj.type.Users"%>
<%@page import="com.hhs.xgn.jee.hhsoj.db.UserHelper"%>
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
<style>
	#editor{
        margin: auto;
        width: 50%; 
        height: 250px;
   	}
</style>

<title>HHSOJ-Submission <%=request.getParameter("id") %></title>
</head>
<body>
	
	<%
		int id=-1;
		Submission s=new Submission();
		Problem p=null;
		try{
			id=Integer.parseInt(request.getParameter("id"));
			s=new SubmissionHelper().getSubmission(id);
			s.getCompilerComment(); //test null
			p=new ProblemHelper().getProblemData(s.getProb());
			
			if(s.getProb().startsWith("H")){
				response.sendRedirect("viewHack.jsp?id="+id);
				return;
			}
			if(s.getProb().equals("T")){
				response.sendRedirect("viewCustomTest.jsp?id="+id);
			}
		}catch(Exception e){
			out.println("Submission doesn't exist");
			out.println("<a href=\"javascript:location.replace(document.referrer);\">←Back</a>");
			return;
		}
		
		String userLooking=(String)session.getAttribute("username");
		
		if(s.isRated() && new ProblemHelper().getProblemData(s.getProb()).getContest().isContestRunning()){
			s.setResults(new ArrayList<>());
		}
		
		Users u=null;
		if(userLooking!=null){
			u=new UserHelper().getUserInfo(userLooking);
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
		
		<div id="editor">Loading Code...</div>
		
		<script>
			var editor=ace.edit("editor",{
				wrap:true,
				maxLines:1000,
				autoScrollEditorIntoView:true		
			});
		    editor.setTheme("ace/theme/<%=(u==null?"xcode":u.getPreference().get("editorTheme").value)%>");
		    editor.session.setMode("ace/mode/<%=(s.getLang().equals("cpp")?"c_cpp":s.getLang())%>");
		    document.getElementById('editor').style.fontSize='<%=(u==null?"12px":u.getPreference().get("editorTheme").value)%>';
			editor.setReadOnly(true);
			
			$.get("api/getCode.jsp?id=<%=id%>",function(data,status){
				editor.setValue(data.trim());
			});
		</script>
		<br/>
		
		<%
			boolean[] query=new boolean[]{userLooking!=null,s.getVerdict().equals("Accepted"),p.isHackable(s.getTestset())};
			String[] sentence=new String[]{"You didn't login","Solution isn't accepted","Testset doesn't support hacking"};
			
			boolean tot=true;
			for(int i=0;i<query.length;i++){
				tot&=query[i];
			}
			
			if(s.getTestset().startsWith("hackAttempt_")){
		%>
			<div class="card bg-success text-white">
			    <div class="card-body">
			    	This is a hack defence to <a href="submission.jsp?id=<%=s.getTestset().substring(12) %>">this hacking attempt</a>
			    </div>
			</div>
		<%
			}else if(tot){
		%>
			<div class="card bg-primary text-white">
			    <div class="card-body">
			    	Let me give a <button type="button" class="btn btn-danger" data-toggle="modal" data-target="#myModal">Hack</button> <br/>
			    </div>
			</div>
			
		<%
			}else if(s.getVerdict().equals("Hacked")){
				String yp=s.getResults().get(s.getResults().size()-1).getFile();
				String zjs=yp.substring(yp.indexOf("#")+1);
		%>
			<div class="card bg-warning text-white">
			    <div class="card-body">
			    	Oops.. Too late.. <br/>
			    	This solution has already been hacked by <a href="submission.jsp?id=<%=zjs %>">this</a>
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