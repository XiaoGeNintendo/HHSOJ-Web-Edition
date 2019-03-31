package com.hhs.xgn.jee.hhsoj.judger;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.concurrent.TimeUnit;

import com.google.gson.Gson;
import com.hhs.xgn.jee.hhsoj.db.ConfigLoader;
import com.hhs.xgn.jee.hhsoj.db.SubmissionHelper;
import com.hhs.xgn.jee.hhsoj.type.Problem;
import com.hhs.xgn.jee.hhsoj.type.Submission;
import com.hhs.xgn.jee.hhsoj.type.TestResult;
import com.hhs.xgn.jee.hhsoj.type.Users;

public class WindowsJudger extends AbstractJudger {

	JudgingThread self;
	
	@Override
	public boolean init(Submission s, Problem p, Users u, JudgingThread self) throws Exception {
		// TODO Auto-generated method stub
		this.self=self;
		return true;
	}

	@Override
	public boolean judgeNormal(Submission s, Problem p, Users u, File testfiles) throws Exception {
		//Windows Method of Testing
		if (!compileFiles(s)) {
			return false;
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
		
		return ac;
	}

	@Override
	public boolean judgeHack(Submission s, Problem p, Users u,Problem orip,Submission oris) throws Exception {
		
		try{
			//First we need to copy the extra stuff
			
			File validatorPath=new File(orip.getPath()+"/"+oris.getTestset()+"/"+orip.getArg("Validator_"+oris.getTestset()));
			
			self.copyFile(validatorPath,new File(ConfigLoader.getPath()+"/judge/valid.exe"));
			
			self.writeToFile(new File(ConfigLoader.getPath()+"/judge/in"),s.getCode());
			
			ProcessBuilder pb=new ProcessBuilder(new File(ConfigLoader.getPath()+"/judge/valid.exe").getAbsolutePath());
			pb.directory(new File(ConfigLoader.getPath()+"/judge/"));
			pb.redirectInput(new File(ConfigLoader.getPath()+"/judge/in"));
			pb.redirectOutput(new File(ConfigLoader.getPath()+"/judge/report"));
			pb.redirectError(new File(ConfigLoader.getPath()+"/judge/report"));
			Process pro=pb.start();
			
			boolean notle=pro.waitFor(self.con.getWaitTimeout(),TimeUnit.SECONDS);
			
			pro.destroyForcibly();
			
			if(notle){
				//Great. Not tle
				int ret=pro.exitValue();
				
				if(ret!=0){
					//Oops
					s.setCompilerComment(self.readFile(ConfigLoader.getPath()+"/judge/report"));
					s.setVerdict("Invalid Input");
					new SubmissionHelper().storeStatus(s);
					return false;
				}
				
				//OK
				s.setVerdict("Defending");
				s.setCompilerComment(self.readFile(ConfigLoader.getPath()+"/judge/report"));
				new SubmissionHelper().storeStatus(s);
				return true;
			}else{
				//TLE
				throw new Exception("It takes too long to check the correctness");
			}
		}catch(Exception e){
			e.printStackTrace();
			s.setCompilerComment(e+"");
			s.setVerdict("Judgement Failed");
			new SubmissionHelper().storeStatus(s);
			return false;
		}
		
	}
	
	private String[] getCompiler(String lang) {
		if (lang.equals("python")) {
			return new String[] {"cmd.exe","/c","exit"};
		}
		if (lang.equals("cpp")) {
			
			return new String[] { "g++", "Program.cpp", "-o","Program.exe","-DONLINE_JUDGE", (self.con.isEnableCPP11()?"-std=c++11":"-DNOCPP"), "-O2"};
		}

		if (lang.equals("java")) {
			return new String[] { "javac", "-cp", "\".;*\"", "Program.java" };
		}
		return null;
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
			if (System.currentTimeMillis() - tme >= self.con.getWaitTimeout() * 1000) {

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
				s.setCompilerComment(self.readFile(ConfigLoader.getPath()+"/judge/compile.txt"));
				new SubmissionHelper().storeStatus(s);

				return false;
			}

			s.setVerdict("Judging");
			s.setCompilerComment(self.readFile(ConfigLoader.getPath()+"/judge/compile.txt"));
			new SubmissionHelper().storeStatus(s);

			return true;
		} else {
			// Compile timeout

			killCompiler(s);
			s.setVerdict("Compile Timeout");
			s.setCompilerComment("Compile Takes too much time");
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

	private boolean judgeOneTestCase(Submission s, File f, Problem p)
			throws IOException, NumberFormatException, InterruptedException {
		System.out.println("Testing...");

		// Copy input file
		self.copyFile(f, new File(ConfigLoader.getPath()+"/judge/in.txt"));

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
				self.con.getWindowsUsername(), self.con.getWindowsPassword(), "in.txt", "out.txt", p.getArg("TL"),
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
				self.con.getWindowsUsername(), self.con.getWindowsPassword(), "in.txt", "out.txt", p.getArg("TL"),
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
		boolean notle=pro.waitFor(self.con.getWaitTimeout(), TimeUnit.SECONDS);
		
		
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

			boolean notle = pro.waitFor(self.con.getWaitTimeout(), TimeUnit.SECONDS);
			
			pro.destroyForcibly();

			if (notle) {

				if (pro.exitValue() != 0) {
					// Wa
					s.setVerdict("Wrong Answer");
					s.getResults()
							.add(new TestResult("Wrong Answer", time, mem, file, self.readFile(ConfigLoader.getPath()+"/judge/checker.txt")));
					new SubmissionHelper().storeStatus(s);
					return false;
				}

				// Ac
				s.getResults().add(new TestResult("Accepted", time, mem, file, self.readFile(ConfigLoader.getPath()+"/judge/checker.txt")));
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
}
