<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="head.jsp"></jsp:include>
<style>
.sub,h2{
	font-family:"Consolas";
}
</style>
<title>HHSOJ-Verdict List</title>
</head>
<body>
<div class="container">
	<h1 class="title">Verdict List!</h1>
	<i class="subtitle">Wrong answer on test 97 --WrongAnswerOnTest97</i>
	<hr />
	<jsp:include page="nav.jsp?at=index"></jsp:include>
	<!-- Default End -->

	<div class="card"><div class="card-body">
		<h2>In queue</h2>
		<i class="sub">5 pages of in queue... --XGN</i>
		<p><br/>This verdict means your program will be judged soon and now it
		is waiting for other programs to judge.</p>
		<br/>
		<h2>Compiling</h2>
		<i class="sub">En? CE!! --Zzzyt</i>
		<p> <br/>This verdict means your program is compiling.</p>
		<br/>
		<h2>Compile Error</h2>
		<i class="sub">Ah!I forget to delete windows.h! --XGN</i>
		<p> <br/>This verdict means your program cannot pass our compile system.</p>
		<br/>
		<h2>Compile Timeout</h2>
		<i class="sub">T,int M=N>Z;struct Y{static int f(){return 0;}}...(and more)
			--Mike</i>
		<p> <br/>This verdict means your program tries to use some tricks to
		stuck our judger and it is killed.</p>
		<br/>
		<h2>Judging</h2>
		<i class="sub">Can you see me? --XGN</i>
		<p> <br/>This verdict means your code will be judged in a few seconds</p>
		<br/>
		<h2>Judgement Failed</h2>
		<i class="sub">java.io.FileNotFoundException --JRE</i>
		<p> <br/>This verdict means the judging server cannot judge your code
		because of some errors</p>
		<br/>
		<h2>Runtime Error</h2>
		<i class="sub">Exit code is 114514 --XGN</i>
		<p> <br/>Your code throws some exception during running. (eg Segment
		Fault)</p>
		<br/>
		<h2>Running on test xxx</h2>
		<i class="sub">Running on test 1024 --XGN</i>
		<p> <br/>Your code is running</p>
		<br/>
		<h2>Time Limit Exceeded</h2>
		<i class="sub">TLE on T14?? --Monkey.King</i>
		<p> <br/>Your code takes too much time to run</p>
		<br/>
		<h2>Memory Limit Exceeded</h2>
		<i class="sub">262144 --XGN</i>
		<p> <br/>Your code takes too much memory to run</p>
		<br/>
		<h2>Wrong Answer</h2>
		<i class="sub">Greedy? DP? --XGN</i>
		<p> <br/>Your code produces wrong answer</p>
		<br/>
		<h2>Checker Error</h2>
		<i class="sub">FAIL must run with the following arguments:xxx --Testlib</i>
		<p> <br/>The checker is not configured properly</p>
		<br/>
		<h2>Library Missing</h2>
		<i class="sub">Please copy all the files in hhsoj/runtime --Github XGN</i>
		<p> <br/>The server is not configured properly. Please contact the server</p>
		admin.
		<p><del>No that's the most common verdict,you don't need to contact the server admin</del></p>
		<br/>
		<h2>Restrict Function</h2>
		<i class="sub">Dirty Hacker --Undertale</i>
		<p> <br/>Only appears in windows java/Linux C++. You are trying to hack the judger I know.</p>
		<p> btw, using System.exit(0) is prohibited too.</p>
		<br/>
		<h2>Unsupported Language</h2>
		<i class="sub">ACDream -- XGN</i>
		<p> <br/>Don't submit Java/Python in Linux</p>
	</div></div>
</div>
</body>
</html>