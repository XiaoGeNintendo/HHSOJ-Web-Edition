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
			
			if(con!=null && con.isClearFolder()){
				ClearFolder();
			}
			
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

				if(ConfigLoader.isLinux()){
					//Linux Method of Testing
					
					if(s.getLang().equals("python")){
						s.setVerdict("Unsupported Language");
						s.setCompilerComment("Python is not ready for Linux now!");
						continue;
					}
					
					if(!testfiles.isDirectory()){
						throw new Exception("Testcase is not ready");
					}
					
					int cnt=1;
					boolean ac=true;
					
					s.setVerdict("Initizing");
					new SubmissionHelper().storeStatus(s);
					LinuxSandboxSetup(s,p);
					
					for(File f:testfiles.listFiles()){
						s.setVerdict("Running");
						s.setNowTest(cnt);
						new SubmissionHelper().storeStatus(s);
						
						boolean goon=LinuxJudgeOneTestCase(s,f,p);
						
						if(!goon){
							ac=false;
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
					
					
				}else{
					
					//Windows Method of Testing
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
				}
				
				
			} catch (Exception e) {
				e.printStackTrace();

				s.setVerdict("Judgement Failed");
				s.setCompilerComment(e.toString());
				new SubmissionHelper().storeStatus(s);
			}
		}
	}

	/**
	 * Test one case in the linux program
	 * @param s
	 * @param f
	 * @param p
	 * @return
	 * @throws Exception 
	 */
	private boolean LinuxJudgeOneTestCase(Submission s, File f, Problem p) throws Exception {
		
		//Copy Input Files
		copyFile(f,new File(ConfigLoader.getPath()+"/judge/data/a.in"));
		
		// Use Std to generate output
		ProcessBuilder pb = new ProcessBuilder(new File(ConfigLoader.getPath()+"/judge/data/sol").getAbsolutePath());
		pb.directory(new File(ConfigLoader.getPath()+"/judge/data/"));
		pb.redirectInput(new File(ConfigLoader.getPath()+"/judge/data/a.in"));
		pb.redirectOutput(new File(ConfigLoader.getPath()+"/judge/data/a.out"));
		Process pr = pb.start();
		// We made sure that std is right and no harmful, but may TLE
    	long now = System.currentTimeMillis();
		boolean ac = pr.waitFor(Integer.parseInt(p.getArg("TL")), TimeUnit.MILLISECONDS);
		pr.destroyForcibly();
		System.out.println("STD TC=" + (System.currentTimeMillis() - now));
				
		if(!ac){
			// Std error
			s.setVerdict("Standard Program Time Limit Exceeded");
			s.getResults().add(new TestResult("Standard Program Time Limit Exceeded", 0, 0, f.getName(), "std error"));
			new SubmissionHelper().storeStatus(s);
			return false;
		}
		
//		//Prevent Sandbox Treating the Solution as a input/output file.
//		File std=new File(ConfigLoader.getPath()+"/judge/data/sol");
//		std.delete();
		
		return LinuxRunUserProgram(s,f,p);
	}

	
	private boolean LinuxRunUserProgram(Submission s, File f, Problem p) throws IOException, NumberFormatException, InterruptedException {

		ProcessBuilder pb=new ProcessBuilder("./test.sh");
		pb.directory(new File(ConfigLoader.getPath()+"/judge/"));
		pb.redirectOutput(new File(ConfigLoader.getPath()+"/judge/judge.txt"));
		pb.redirectError(new File(ConfigLoader.getPath()+"/judge/judge.txt"));
		Process pro=pb.start();
		boolean ac=pro.waitFor(Integer.parseInt(p.getArg("TL"))+10000,TimeUnit.MILLISECONDS);
		pro.destroyForcibly();
		if(!ac){
			s.setVerdict("Time Limit Exceeded");
			s.getResults().add(new TestResult("Time Limit Exceeded", Integer.parseInt(p.getArg("TL")), 0, f.getName(), "Sandbox TLE"));
			new SubmissionHelper().storeStatus(s);
			return false;
		}
		
		String content=readFile(ConfigLoader.getPath()+"/judge/judge.txt").split("\n")[0];
		String[] ans=content.split(" ");
		int result=Integer.parseInt(ans[0].trim());
		int mcost=Integer.parseInt(ans[1].trim());
		int tcost=Integer.parseInt(ans[2].trim());
		String[] int2str=new String[]{"Improper Verdict",
									  "Improper Verdict",
									  "Accepted", //OK 2
									  "Persentation Error", //OK 3
									  "Time Limit Exceeded",
									  "Memory Limit Exceeded",
									  "Wrong Answer", //OK 6
									  "Output Limit Exceeded",
									  "Compile Error", //CE 8
									  "Segmentation Fault",
									  "Divide By Zero",
									  "Abort Error",
									  "Runtime Error",
									  "Restricted Function",
									  "Judgement Failed",
									  "Runtime Error"};
		
		
		if(result==8){
			String verdict=int2str[result];
			s.setVerdict(verdict);
			s.setCompilerComment(readFile(ConfigLoader.getPath()+"/judge/temp/ce.txt"));
			new SubmissionHelper().storeStatus(s);
			return false;
		}
		
		if(result!=2 && result!=3 && result!=6){
			//Bad verdict
			String verdict=int2str[result];
			s.setVerdict(verdict);
			s.getResults().add(new TestResult(verdict, tcost, mcost, f.getName(), ""));
			new SubmissionHelper().storeStatus(s);
			return false;
		}
		
		
		//Good verdict. Continue to call the checker. The output file is hhsoj/judge/temp/a.out
		return LinuxChecker(s,f,p,tcost,mcost);
	}

	private boolean LinuxChecker(Submission s, File f, Problem p,int time,int mem) throws IOException, InterruptedException {
		ProcessBuilder pb=new ProcessBuilder("./checker",
											 ConfigLoader.getPath()+"/judge/data/a.in",
											 ConfigLoader.getPath()+"/judge/temp/a.out",
											 ConfigLoader.getPath()+"/judge/data/a.out",
											 ConfigLoader.getPath()+"/judge/checker.txt");
		pb.directory(new File(ConfigLoader.getPath()+"/judge"));
		Process pro=pb.start();
		boolean ac=pro.waitFor(15,TimeUnit.SECONDS);
		pro.destroyForcibly();
		if(!ac){
			s.setVerdict("Checker Error");
			s.getResults().add(new TestResult("Checker Error", time, mem, f.getName(), "Checker Time Limit Exceeded"));
			new SubmissionHelper().storeStatus(s);
			return false;
		}
		
		int exitCode=pro.exitValue();
		if(exitCode!=0){
			s.setVerdict("Wrong Answer");
			s.getResults().add(new TestResult("Wrong Answer",time,mem,f.getName(),readFile(ConfigLoader.getPath()+"/judge/checker.txt")));
			new SubmissionHelper().storeStatus(s);
			return false;
		}
		s.getResults().add(new TestResult("Accepted",time,mem,f.getName(),readFile(ConfigLoader.getPath()+"/judge/checker.txt")));
		new SubmissionHelper().storeStatus(s);
		
		return true;
	}

	/**
	 * Create data and temp folders <br/>
	 * Copy configs<br/>
	 * Copy Solutions To Data<br/>
	 * Copy Program To Temp<br/>
	 * Copy Checker <br/>
	 * Make the Linux Sandbox <br/>
	 * Compile the Programs <br/>
	 * Add CHMOD <br/>
	 * @param s
	 * @throws Exception
	 */
	private void LinuxSandboxSetup(Submission s,Problem p) throws Exception {
		
			//Create shell
			int langCode;
			if(s.getLang().equals("java")){
				langCode=3;
			}else{
				langCode=2;
			}
			
			PrintWriter pw=new PrintWriter(new File(ConfigLoader.getPath()+"/judge/test.sh"));
			pw.println("./judge -l "+langCode+" -D data -d temp -t "+p.getArg("TL")+" -m "+p.getArg("ML")+" -o 1048576");
			pw.close();
			
			File data=new File(ConfigLoader.getPath()+"/judge/data");
			File temp=new File(ConfigLoader.getPath()+"/judge/temp");
			if(data.exists() && data.isFile()){
				throw new Exception("Data is not folder");
			}
			if(temp.exists() && temp.isFile()){
				throw new Exception("Temp is not folder");
			}
			if(!data.exists()){
				data.mkdirs();
			}
			if(!temp.exists()){
				temp.mkdirs();
			}
			
			//Copy configs
			copyFile(new File(ConfigLoader.getPath()+"/runtime/Linux_config.ini"), new File(ConfigLoader.getPath()+"/judge/config.ini"));
			copyFile(new File(ConfigLoader.getPath()+"/runtime/Linux_okcall.cfg"), new File(ConfigLoader.getPath()+"/judge/okcall.cfg"));
			
			//Copy Solution to Temp
			copyFile(new File(ConfigLoader.getPath()+"/judge/Program."+getExtension(s.getLang())), new File(ConfigLoader.getPath()+"/judge/temp/Main."+getExtension(s.getLang())));

			
			//Recopy solutions to Data
			copyFile(new File(ConfigLoader.getPath()+"/judge/sol.exe"),new File(ConfigLoader.getPath()+"/judge/data/sol.cpp"));
			
			//Recopy Checker
			copyFile(new File(ConfigLoader.getPath()+"/judge/checker.exe"),new File(ConfigLoader.getPath()+"/judge/checker.cpp"));
			
			LinuxCompile(s);
			
			LinuxSanboxCompile(s);
			
			{
				//add chmod
				ProcessBuilder pb=new ProcessBuilder("chmod","-R","777","judge/");
				pb.inheritIO();
				pb.directory(new File(ConfigLoader.getPath()));
				Process px=pb.start();
				px.waitFor();
				px.destroyForcibly();
			}
	}

	private void LinuxSanboxCompile(Submission s) throws IOException, InterruptedException {
		//Make it
		ProcessBuilder pb=new ProcessBuilder("make");
		pb.inheritIO();
		pb.directory(new File(ConfigLoader.getPath()+"/runtime/source/Linux"));
		Process p=pb.start();
		p.waitFor();
		
		//Copy it
		ProcessBuilder pb2=new ProcessBuilder("cp","Judge",ConfigLoader.getPath()+"/judge/judge");
		pb2.inheritIO();
		pb2.directory(new File(ConfigLoader.getPath()+"/runtime/source/Linux"));
		Process p2=pb2.start();
		p2.waitFor();
	}

	/**
	 * Compile the solution and checker.
	 * @param s
	 * @throws Exception 
	 */
	private void LinuxCompile(Submission s) throws Exception {
		ProcessBuilder pb=new ProcessBuilder("g++","sol.cpp","-o","sol");
		pb.directory(new File(ConfigLoader.getPath()+"/judge/data"));
		pb.inheritIO();
		Process p=pb.start();
		//We assume that there's no hacks compiling the program
		p.waitFor();
		
		int ex=p.exitValue();
		if(ex!=0){
			throw new Exception("Standard Program Compile Error");
		}
		
		copyFile(new File(ConfigLoader.getPath()+"/runtime/testlib.h"),new File(ConfigLoader.getPath()+"/judge/testlib.h"));
		
		ProcessBuilder pb2=new ProcessBuilder("g++","checker.cpp","-o","checker");
		pb2.directory(new File(ConfigLoader.getPath()+"/judge"));
		pb2.inheritIO();
		Process p2=pb2.start();
		p2.waitFor();
		int ex2=p2.exitValue();
		if(ex2!=0){
			throw new Exception("Checker Compile Error");
		}
	}

	private void submitCodeforces(Submission s,Config c) {
		
		try{
			System.out.println("===========Python Start=============");
			ProcessBuilder pb=new ProcessBuilder("python","cf.py",c.getCodeforcesUsername(),c.getCodeforcesPassword(),s.getProb().substring(1),"Program."+getExtension(s.getLang()),s.getLang());
			pb.directory(new File(ConfigLoader.getPath()+"/judge/"));
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
		copyFile(f, new File(ConfigLoader.getPath()+"/judge/in.txt"));

		// Use Std to generate output
		ProcessBuilder pb = new ProcessBuilder(new File(ConfigLoader.getPath()+"/judge/sol.exe").getAbsolutePath());
		pb.directory(new File(ConfigLoader.getPath()+"/judge/"));
		pb.redirectInput(new File(ConfigLoader.getPath()+"/judge/in.txt"));
		pb.redirectOutput(new File(ConfigLoader.getPath()+"/judge/ans.txt"));
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
		ProcessBuilder pb = new ProcessBuilder(new File(ConfigLoader.getPath()+"/judge/sandbox.exe").getAbsolutePath(), "python \""+new File(ConfigLoader.getPath()+"/judge/Program.py").getAbsolutePath()+"\"",
				con.getWindowsUsername(), con.getWindowsPassword(), "in.txt", "out.txt", p.getArg("TL"),
				p.getArg("ML"));
		
		pb.directory(new File(ConfigLoader.getPath()+"/judge"));
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
		BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(ConfigLoader.getPath()+"/judge/V2.txt")));
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

		ProcessBuilder pb = new ProcessBuilder(new File(ConfigLoader.getPath()+"/judge/sandbox.exe").getAbsolutePath(), "Program.exe",
				con.getWindowsUsername(), con.getWindowsPassword(), "in.txt", "out.txt", p.getArg("TL"),
				p.getArg("ML"));
		
		pb.directory(new File(ConfigLoader.getPath()+"/judge"));
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
		BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(ConfigLoader.getPath()+"/judge/V2.txt")));
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
		ProcessBuilder pb=new ProcessBuilder("java","-jar","test.jar",p.getArg("TL"),p.getArg("ML"),f.getName());
		pb.directory(new File(ConfigLoader.getPath()+"/judge"));
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
			BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(ConfigLoader.getPath()+"/judge/data.txt")));
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
			ProcessBuilder pb = new ProcessBuilder(new File(ConfigLoader.getPath()+"/judge/checker").getAbsolutePath(), "in.txt",
					"out.txt", "ans.txt", "checker.txt");
			pb.directory(new File(ConfigLoader.getPath()+"/judge"));
			
			
			Process pro = pb.start();

			boolean notle = pro.waitFor(10000, TimeUnit.MILLISECONDS);
			
			pro.destroyForcibly();

			if (notle) {

				if (pro.exitValue() != 0) {
					// Wa
					s.setVerdict("Wrong Answer");
					s.getResults()
							.add(new TestResult("Wrong Answer", time, mem, file, readFile(ConfigLoader.getPath()+"/judge/checker.txt")));
					new SubmissionHelper().storeStatus(s);
					return false;
				}

				// Ac
				s.getResults().add(new TestResult("Accepted", time, mem, file, readFile(ConfigLoader.getPath()+"/judge/checker.txt")));
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
		File ff = new File(ConfigLoader.getPath()+"/judge");
		for (File f : ff.listFiles()) {
			f.delete();
		}
	}

	private boolean compileFiles(Submission s) throws IOException, InterruptedException {
		System.out.println("Compiling the given solution");

		s.setVerdict("Compiling");
		new SubmissionHelper().storeStatus(s);

		ProcessBuilder pb = new ProcessBuilder(getCompiler(s.getLang()));
		pb.directory(new File(ConfigLoader.getPath()+"/judge"));

		pb.redirectError(new File(ConfigLoader.getPath()+"/judge/compile.txt"));

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
				s.setCompilerComment(readFile(ConfigLoader.getPath()+"/judge/compile.txt"));
				new SubmissionHelper().storeStatus(s);

				return false;
			}

			s.setVerdict("Judging");
			s.setCompilerComment(readFile(ConfigLoader.getPath()+"/judge/compile.txt"));
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
			pb.directory(new File(ConfigLoader.getPath()+"/runtime"));
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

			return new String[] { "g++", "Program.cpp", "-o","Program.exe","-DONLINE_JUDGE", (con.isEnableCPP11()?"-std=c++11":"-DNOCPP"), "-O2"};
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
			File newSol = new File(ConfigLoader.getPath()+"/judge/sol.exe");
			copyFile(oldSol, newSol);
	
			// Copy Checker
			File oldChk = new File(p.getPath() + "/" + p.getArg("Checker"));
			File newChk = new File(ConfigLoader.getPath()+"/judge/checker.exe");
			copyFile(oldChk, newChk);
		}
		
		// Copy User's Program
		PrintWriter pw = new PrintWriter(ConfigLoader.getPath()+"/judge/Program." + getExtension(s.getLang()));
		pw.println(s.getCode());
		pw.close();

		
		// Copy Sandbox
		File snd = new File(ConfigLoader.getPath()+"/runtime/JudgerV2.exe");
		File nws = new File(ConfigLoader.getPath()+"/judge/sandbox.exe");
		copyFile(snd, nws);
		
		// Copy Java tester
		File jvt=new File(ConfigLoader.getPath()+"/runtime/JavaTester.jar");
		File njt=new File(ConfigLoader.getPath()+"/judge/test.jar");
		copyFile(jvt,njt);
		
		//Copy CF Submiter
		File cfs=new File(ConfigLoader.getPath()+"/runtime/SubmitCF.py");
		File ncf=new File(ConfigLoader.getPath()+"/judge/cf.py");
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

		File f = new File(ConfigLoader.getPath()+"/judge");
		if (!f.exists()) {
			f.mkdirs();
		}

		File f2 = new File(ConfigLoader.getPath()+"/runtime/JudgerV2.exe");
		if (!f2.exists()) {
			s.setVerdict("Library Missing");
			s.setCompilerComment(
					"JudgerV2.exe is missing.");
			new SubmissionHelper().storeStatus(s);
			return false;
		}

		File f3=new File(ConfigLoader.getPath()+"/runtime/JavaTester.jar");
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
