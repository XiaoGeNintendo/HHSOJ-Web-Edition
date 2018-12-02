package com.hhs.xgn.jee.hhsoj.judger;

import java.io.*;
import java.util.concurrent.TimeUnit;

import com.google.gson.Gson;
import com.hhs.xgn.jee.hhsoj.db.ConfigLoader;
import com.hhs.xgn.jee.hhsoj.db.ContestHelper;
import com.hhs.xgn.jee.hhsoj.db.ProblemHelper;
import com.hhs.xgn.jee.hhsoj.db.SubmissionHelper;
import com.hhs.xgn.jee.hhsoj.remote.CodeforcesHelper;
import com.hhs.xgn.jee.hhsoj.remote.CodeforcesSubmission;
import com.hhs.xgn.jee.hhsoj.type.Config;
import com.hhs.xgn.jee.hhsoj.type.Contest;
import com.hhs.xgn.jee.hhsoj.type.Problem;
import com.hhs.xgn.jee.hhsoj.type.Submission;
import com.hhs.xgn.jee.hhsoj.type.TestResult;

public class JudgingThread extends Thread {
	
	private Config con;
	
	public void run() {
		System.out.println("Judging Thread Initaize Ok!");
		while (true) {

			ClearFolder();
			while (TaskQueue.hasElement() == false) {

			}

			//Do new submission
			con=readGlobalConfig();
			
			Submission s = TaskQueue.getFirstSubmission();
			Problem p = new ProblemHelper().getProblemData(s.getProb());
			
			
			
			try {

				File testfiles = new File(p.getPath() + "/"+s.getTestset());
				
				TaskQueue.popFront();

				System.out.println("Now testing:" + s.getId());

				Thread.sleep(1000);

				
				
				if (!checkEnvironment(s)) {
					continue;
				}

				copyFiles(s, p);

				if(p.getType()==Problem.CODEFORCES){
					//Codeforces Special Judge
					if(!con.isEnableRemoteJudge()){
						//Not allowed
						s.setVerdict("Submit Failed");
						s.setCompilerComment("Remote Judge is not allowed");
						new SubmissionHelper().storeStatus(s);
						continue;
					}
					
					submitCodeforces(s,con);
					continue;
				}
				
				s.setNowTest(0);
				s.setMaxTest(testfiles.list().length);

				if (!compileFiles(s)) {
					continue;
				}


				if(!testfiles.isDirectory()){
					throw new Exception("Testcase is not ready");
				}
				
				int cnt = 1;

				boolean ac = true;

				for (File f : testfiles.listFiles()) {
					s.setVerdict("Running");
					s.setNowTest(cnt);
					new SubmissionHelper().storeStatus(s);
					boolean goon = judgeOneTestCase(s, f, p);
					if (!goon) {
						ac = false;
						break;
					}

					cnt++;
				}

				if (ac) {
					s.setVerdict("Accepted");
					new SubmissionHelper().storeStatus(s);
					
					if(s.isRated()){
						if(s.getTestset().equals("small")){
							//Contest Score
							Contest c=p.getContest();
							c.getStanding().countSmall(s,p.getConIndex(),c.getInfo().getScores().get(p.getConIndex()).getSmall());
							new ContestHelper().refreshContest(c);
						}else{
							//Count large score
							Contest c=p.getContest();
							c.getStanding().countLarge(s,p.getConIndex(),c.getInfo().getScores().get(p.getConIndex()).getLarge());
							new ContestHelper().refreshContest(c);
						}
						
					}
				}else{
					//Sorry poor guy..
					if(s.isRated()){
						if(s.getTestset().equals("small")){
							//Only work for small tests
							Contest c=p.getContest();
							c.getStanding().countWrong(s,p.getConIndex());
							new ContestHelper().refreshContest(c);
						}
					}
				}
				
			} catch (Exception e) {
				e.printStackTrace();

				s.setVerdict("Judgement Failed");
				s.setCompilerComment(e.toString());
				new SubmissionHelper().storeStatus(s);
			}
		}
	}

	private void submitCodeforces(Submission s,Config c) {
		
		try{
			System.out.println("===========Python Start=============");
			ProcessBuilder pb=new ProcessBuilder("python","cf.py",c.getCodeforcesUsername(),c.getCodeforcesPassword(),s.getProb().substring(1),"Program."+getExtension(s.getLang()),s.getLang());
			pb.directory(new File("hhsoj/judge/"));
			pb.inheritIO();
			Process p=pb.start();
//			System.out.println("start waiting for");
			p.waitFor();
			p.destroyForcibly();
			int exitcode=p.exitValue();
			if(exitcode!=0){
				s.setVerdict("Submit Failed");
				s.setCompilerComment("The spider exit code is "+exitcode);
				new SubmissionHelper().storeStatus(s);
				return;
			}
			
			//Start Listening On Codeforces every 1000ms
			s.setVerdict("Judging");
			s.getResults().add(new TestResult("??", 0, 0, "??", "??"));
			while(true){
				Thread.sleep(1000);
				CodeforcesSubmission cs=CodeforcesHelper.getLastSubmission();
				
				s.setVerdict(cs.getExchangeVerdict());
				s.setNowTest(cs.getPassedTestCount()+1);
				s.getResults().set(0,new TestResult(cs.getVerdict(),cs.getTimeConsumedMillis(),cs.getMemoryConsumedBytes(),"??","??"));
				
				new SubmissionHelper().storeStatus(s);
				if(!cs.getVerdict().equals("TESTING")){
					break;
				}
			}
		}catch(Exception e){
			s.setVerdict("Judgement Failed");
			s.setCompilerComment(e+"");
			new SubmissionHelper().storeStatus(s);
		}
	}

	private Config readGlobalConfig() {
		return new ConfigLoader().load();
	}

	private boolean judgeOneTestCase(Submission s, File f, Problem p)
			throws IOException, NumberFormatException, InterruptedException {
		System.out.println("Testing...");

		// Copy input file
		copyFile(f, new File("hhsoj/judge/in.txt"));

		// Use Std to generate output
		ProcessBuilder pb = new ProcessBuilder(new File("hhsoj/judge/sol.exe").getAbsolutePath());
		pb.directory(new File("hhsoj/judge/"));
		pb.redirectInput(new File("hhsoj/judge/in.txt"));
		pb.redirectOutput(new File("hhsoj/judge/ans.txt"));
		Process pr = pb.start();

		// We made sure that std is right and no harmful, but may TLE
		long now = System.currentTimeMillis();
		boolean ac = pr.waitFor(Integer.parseInt(p.getArg("TL")), TimeUnit.MILLISECONDS);
		pr.destroyForcibly();

		System.out.println("STD TC=" + (System.currentTimeMillis() - now));

		if (ac) {
			// Std ok

			// Then we run the user's program. We should run it in a sandbox
			return runUserProgram(s, f, p);

		} else {
			// Std error
			s.setVerdict("Standard Program Time Limit Exceeded");
			s.getResults().add(new TestResult("Standard Program Time Limit Exceeded", 0, 0, f.getName(), "std error"));
			new SubmissionHelper().storeStatus(s);
			return false;
		}

	}

	private boolean runUserProgram(Submission s, File f, Problem p) {
		// We call the cpp program to run the program

		try {

			if (s.getLang().equals("cpp")) {
				return runUserCpp(s, f, p);
			}

			if(s.getLang().equals("java")){
				return runUserJava(s,f,p);
			}
			
			if(s.getLang().equals("python")){
				return runUserPython(s,f,p);
			}
			
			throw new Exception("Unknown language");
		} catch (Exception e) {
			// Judgement Failed
			s.setVerdict("Judgement Failed");
			s.getResults().add(new TestResult("Judgement Failed", 0, 0, f.getName(), e.toString()));
			new SubmissionHelper().storeStatus(s);
			e.printStackTrace();
			return false;
		}
	}

		
	private boolean runUserPython(Submission s, File f, Problem p) throws Exception{
		ProcessBuilder pb = new ProcessBuilder(new File("hhsoj/judge/sandbox.exe").getAbsolutePath(), "python \""+new File("hhsoj/judge/Program.py").getAbsolutePath()+"\"",
				con.getWindowsUsername(), con.getWindowsPassword(), "in.txt", "out.txt", p.getArg("TL"),
				p.getArg("ML"));
		
		pb.directory(new File("hhsoj/judge"));
		//pb.redirectInput(new File("hhsoj/judge/in.txt"));
		//pb.redirectOutput(new File("hhsoj/judge/out.txt"));

		Process pro = pb.start();

		pro.waitFor();

		pro.destroyForcibly();

		if (pro.exitValue() != 0) {
			throw new Exception("Sandbox Error");
		}

		// Anyway kill the sandbox
		Runtime.getRuntime().exec("taskkill /f /im sandbox.exe /t");

		// Get everything
		BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream("hhsoj/judge/V2.txt")));
		int time = Integer.parseInt(br.readLine());
		int mem = Integer.parseInt(br.readLine());
		int exit = Integer.parseInt(br.readLine());
		int err = Integer.parseInt(br.readLine());
		br.close();

		if (err != 0) {
			// Sandbox error
			s.setVerdict("Judgement Failed");
			s.getResults().add(new TestResult("Judgement Failed", time, mem, f.getName(), "Sandbox error code=" + err));
			new SubmissionHelper().storeStatus(s);
			return false;
		}

		if (time > Integer.parseInt(p.getArg("TL"))) {
			// Tle
			s.setVerdict("Time Limit Exceeded");
			s.getResults().add(new TestResult("Time Limit Exceeded", Integer.parseInt(p.getArg("TL")), mem, f.getName(),
					"Time limit exceeded. :("));
			new SubmissionHelper().storeStatus(s);
			return false;
		}

		if (mem > Integer.parseInt(p.getArg("ML"))) {
			// Mle
			s.setVerdict("Memory Limit Exceeded");
			s.getResults()
					.add(new TestResult("Memory Limit Exceeded", time, mem, f.getName(), "Memory limit exceeded. :("));
			new SubmissionHelper().storeStatus(s);
			return false;
		}

		if (exit != 0) {
			// Re
			s.setVerdict("Runtime Error");
			s.getResults().add(
					new TestResult("Runtime Error", time, mem, f.getName(), "Runtime Error, exit code is " + exit));
			new SubmissionHelper().storeStatus(s);
			return false;
		}

		// Compare

		return processCompare(s, p, time, mem, f.getName());
	}

	private boolean runUserCpp(Submission s, File f, Problem p) throws Exception {

		ProcessBuilder pb = new ProcessBuilder(new File("hhsoj/judge/sandbox.exe").getAbsolutePath(), "Program.exe",
				con.getWindowsUsername(), con.getWindowsPassword(), "in.txt", "out.txt", p.getArg("TL"),
				p.getArg("ML"));
		
		pb.directory(new File("hhsoj/judge"));
		//pb.redirectInput(new File("hhsoj/judge/in.txt"));
		//pb.redirectOutput(new File("hhsoj/judge/out.txt"));

		Process pro = pb.start();

		pro.waitFor();

		pro.destroyForcibly();

		if (pro.exitValue() != 0) {
			throw new Exception("Sandbox Error");
		}

		// Anyway kill the sandbox
		Runtime.getRuntime().exec("taskkill /f /im sandbox.exe /t");

		// Get everything
		BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream("hhsoj/judge/V2.txt")));
		int time = Integer.parseInt(br.readLine());
		int mem = Integer.parseInt(br.readLine());
		int exit = Integer.parseInt(br.readLine());
		int err = Integer.parseInt(br.readLine());
		br.close();

		if (err != 0) {
			// Sandbox error
			s.setVerdict("Judgement Failed");
			s.getResults().add(new TestResult("Judgement Failed", time, mem, f.getName(), "Sandbox error code=" + err));
			new SubmissionHelper().storeStatus(s);
			return false;
		}

		if (time > Integer.parseInt(p.getArg("TL"))) {
			// Tle
			s.setVerdict("Time Limit Exceeded");
			s.getResults().add(new TestResult("Time Limit Exceeded", Integer.parseInt(p.getArg("TL")), mem, f.getName(),
					"Time limit exceeded. :("));
			new SubmissionHelper().storeStatus(s);
			return false;
		}

		if (mem > Integer.parseInt(p.getArg("ML"))) {
			// Mle
			s.setVerdict("Memory Limit Exceeded");
			s.getResults()
					.add(new TestResult("Memory Limit Exceeded", time, mem, f.getName(), "Memory limit exceeded. :("));
			new SubmissionHelper().storeStatus(s);
			return false;
		}

		if (exit != 0) {
			// Re
			s.setVerdict("Runtime Error");
			s.getResults().add(
					new TestResult("Runtime Error", time, mem, f.getName(), "Runtime Error, exit code is " + exit));
			new SubmissionHelper().storeStatus(s);
			return false;
		}

		// Compare

		return processCompare(s, p, time, mem, f.getName());

	}

	private boolean runUserJava(Submission s, File f, Problem p) throws Exception {
		ProcessBuilder pb=new ProcessBuilder("java.exe","-jar","test.jar",p.getArg("TL"),p.getArg("ML"),f.getName());
		pb.directory(new File("hhsoj/judge"));
		pb.inheritIO();
		Process pro=pb.start();
		boolean notle=pro.waitFor(10, TimeUnit.SECONDS);
		
		
		if(notle){
			//No TLE
			
			if(pro.exitValue()!=0){
				//JVM EXCEPTION
				TestResult tr=new TestResult("Runtime Error", 0, 0, f.getName(), "JVM Exit value is "+pro.exitValue());
				s.setVerdict("Runtime Error");
				s.getResults().add(tr);
				new SubmissionHelper().storeStatus(s);
				return false;
			}
			
			//Read data.txt
			BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream("hhsoj/judge/data.txt")));
			String json=br.readLine();
			br.close();
			
			Gson gs=new Gson();
			
			TestResult tr=gs.fromJson(json, TestResult.class);
			
			if(tr.getVerdict().equals("Accepted")){
				//Keep comparing
				return processCompare(s, p, tr.getTimeCost(), tr.getMemoryCost(), f.getName());
			}else{
				s.setVerdict(tr.getVerdict());
				s.getResults().add(tr);
				new SubmissionHelper().storeStatus(s);
				return false;
			}
		}else{
			//TLE
			pro.destroyForcibly();
			s.setVerdict("Time Limit Exceeded");
			s.getResults().add(new TestResult("Time Limit Exceeded", Integer.parseInt(p.getArg("TL")), 0, f.getName(), "JVM RUNS 10 SEC"));
			new SubmissionHelper().storeStatus(s);
			return false;
		}
	}
	
	private boolean processCompare(Submission s, Problem p, int time, int mem, String file) {

		try {
			ProcessBuilder pb = new ProcessBuilder(new File("hhsoj/judge/checker").getAbsolutePath(), "in.txt",
					"out.txt", "ans.txt", "checker.txt");
			pb.directory(new File("hhsoj/judge"));
			
			
			Process pro = pb.start();

			boolean notle = pro.waitFor(10000, TimeUnit.MILLISECONDS);
			
			pro.destroyForcibly();

			if (notle) {

				if (pro.exitValue() != 0) {
					// Wa
					s.setVerdict("Wrong Answer");
					s.getResults()
							.add(new TestResult("Wrong Answer", time, mem, file, readFile("hhsoj/judge/checker.txt")));
					new SubmissionHelper().storeStatus(s);
					return false;
				}

				// Ac
				s.getResults().add(new TestResult("Accepted", time, mem, file, readFile("hhsoj/judge/checker.txt")));
				new SubmissionHelper().storeStatus(s);
				return true;
			} else {
				// Checker tle
				throw new Exception("Checker Time Limit Exceeded");
			}
		} catch (Exception e) {
			s.setVerdict("Checker Error");
			s.getResults().add(new TestResult("Checker Error", time, mem, file, e.toString()));
			new SubmissionHelper().storeStatus(s);
			return false;
		}

	}

	private void ClearFolder() {
		System.out.println("Clearing folder");
		File ff = new File("hhsoj/judge");
		for (File f : ff.listFiles()) {
			f.delete();
		}
	}

	private boolean compileFiles(Submission s) throws IOException, InterruptedException {
		System.out.println("Compiling the given solution");

		s.setVerdict("Compiling");
		new SubmissionHelper().storeStatus(s);

		ProcessBuilder pb = new ProcessBuilder(getCompiler(s.getLang()));
		pb.directory(new File("hhsoj/judge"));

		pb.redirectError(new File("hhsoj/judge/compile.txt"));

		Process p = pb.start();

		long tme = System.currentTimeMillis();

		boolean killed = true;
		while (p.isAlive()) {
			if (System.currentTimeMillis() - tme >= 15 * 1000) {

				killed = false;
				break;
			}
		}

		if (killed) {
			// Fit in time
			int id = p.exitValue();

			if (id != 0) {
				// Compile Error
				s.setVerdict("Compile Error");
				s.setCompilerComment(readFile("hhsoj/judge/compile.txt"));
				new SubmissionHelper().storeStatus(s);

				return false;
			}

			s.setVerdict("Judging");
			s.setCompilerComment(readFile("hhsoj/judge/compile.txt"));
			new SubmissionHelper().storeStatus(s);

			return true;
		} else {
			// Compile timeout

			killCompiler(s);
			s.setVerdict("Compile Timeout");
			s.setCompilerComment("Compile Takes 15.00s");
			new SubmissionHelper().storeStatus(s);

			return false;
		}
	}

	private void killCompiler(Submission s) throws IOException {
		if (s.getLang().equals("cpp")) {
			ProcessBuilder pb = new ProcessBuilder("taskkill", "/f", "/im", "g++.exe", "/t");
			pb.directory(new File("hhsoj/runtime"));
			pb.start();
		}
	}

	private String readFile(String file) throws IOException {
		BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(file)));
		String s, ans = "";
		while ((s = br.readLine()) != null) {
			ans += s + "\n";
			if (ans.length() >= 1000) {
				ans += "...(and more)";
				break;
			}
		}

		br.close();
		return ans;
	}

	private String[] getCompiler(String lang) {
		if (lang.equals("python")) {
			return new String[] {"cmd.exe","/c","exit"};
		}
		if (lang.equals("cpp")) {

			return new String[] { "g++", "-static", "-DONLINE_JUDGE", (con.isEnableCPP11()?"-std=c++11":"-DNOCPP"), "-O2", "-Wl,--stack=268435456",
					"-s", "-x", "c++", "-o", "Program.exe", "Program.cpp" };
		}

		if (lang.equals("java")) {
			return new String[] { "javac", "-cp", "\".;*\"", "Program.java" };
		}
		return null;
	}

	/**
	 * 复制文件
	 * 
	 * @param fromFile
	 * @param toFile
	 *            <br/>
	 *            2016年12月19日 下午3:31:50
	 * @throws IOException
	 */
	private void copyFile(File fromFile, File toFile) throws IOException {
		FileInputStream ins = new FileInputStream(fromFile);
		FileOutputStream out = new FileOutputStream(toFile);
		byte[] b = new byte[1024];
		int n = 0;
		while ((n = ins.read(b)) != -1) {
			out.write(b, 0, n);
		}

		ins.close();
		out.close();
	}

	private void copyFiles(Submission s, Problem p) throws IOException {
		System.out.println("Copying files");

		// Copy Solution
		if(p.getType()!=Problem.CODEFORCES){
			File oldSol = new File(p.getPath() + "/" + p.getArg("Solution"));
			File newSol = new File("hhsoj/judge/sol.exe");
			copyFile(oldSol, newSol);
	
			// Copy Checker
			File oldChk = new File(p.getPath() + "/" + p.getArg("Checker"));
			File newChk = new File("hhsoj/judge/checker.exe");
			copyFile(oldChk, newChk);
		}
		
		// Copy User's Program
		PrintWriter pw = new PrintWriter("hhsoj/judge/Program." + getExtension(s.getLang()));
		pw.println(s.getCode());
		pw.close();

		// Copy Sandbox
		File snd = new File("hhsoj/runtime/JudgerV2.exe");
		File nws = new File("hhsoj/judge/sandbox.exe");
		copyFile(snd, nws);
		
		// Copy Java tester
		File jvt=new File("hhsoj/runtime/JavaTester.jar");
		File njt=new File("hhsoj/judge/test.jar");
		copyFile(jvt,njt);
		
		//Copy CF Submiter
		File cfs=new File("hhsoj/runtime/SubmitCF.py");
		File ncf=new File("hhsoj/judge/cf.py");
		copyFile(cfs,ncf);
	}

	private String getExtension(String lang) {
		if (lang.equals("python")) {
			return "py";
		} else {
			return lang;
		}

	}

	private boolean checkEnvironment(Submission s) {

		System.out.println("Checking environment");

		File f = new File("hhsoj/judge");
		if (!f.exists()) {
			f.mkdirs();
		}

		File f2 = new File("hhsoj/runtime/JudgerV2.exe");
		if (!f2.exists()) {
			s.setVerdict("Library Missing");
			s.setCompilerComment(
					"JudgerV2.exe is missing.");
			new SubmissionHelper().storeStatus(s);
			return false;
		}

		File f3=new File("hhsoj/runtime/JavaTester.jar");
		if (!f3.exists()) {
			s.setVerdict("Library Missing");
			s.setCompilerComment(
					"JavaTester.jar is missing.");
			new SubmissionHelper().storeStatus(s);
			return false;
		}
		
		
		return true;
	}
}
