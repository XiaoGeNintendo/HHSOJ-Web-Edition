package com.hhs.xgn.jee.hhsoj.judger;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.concurrent.TimeUnit;

import com.hhs.xgn.jee.hhsoj.db.ConfigLoader;
import com.hhs.xgn.jee.hhsoj.db.SubmissionHelper;
import com.hhs.xgn.jee.hhsoj.type.Problem;
import com.hhs.xgn.jee.hhsoj.type.Submission;
import com.hhs.xgn.jee.hhsoj.type.TestResult;
import com.hhs.xgn.jee.hhsoj.type.Users;

public class LinuxJudger extends AbstractJudger {

	JudgingThread self;
	
	@Override
	public boolean init(Submission s, Problem p, Users u,JudgingThread self) {
		this.self=self;
		
		if(!s.getLang().equals("cpp") && !s.getLang().equals("hack")){
			s.setVerdict("Unsupported Language");
			s.setCompilerComment("Python/Java is not ready for Linux now!");
			new SubmissionHelper().storeStatus(s);
			return false;
		}
		
		return true;
	}

	@Override
	public boolean judgeNormal(Submission s, Problem p, Users u,File testfiles) throws Exception {
		int cnt=1;
		boolean ac=true;
		
		s.setVerdict("Initalizing");
		new SubmissionHelper().storeStatus(s);
		
		LinuxSandboxSetup(s,p);
		
		if(!LinuxCompileSolution(s)){
			return false;
		}
		
		for(File f:testfiles.listFiles()){ 
			

			if(f.isDirectory()){
				continue;
			}
			
			
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
		
		return ac;
	}

	@Override
	public boolean judgeHack(Submission s, Problem p, Users u,Problem orip,Submission oris) {
		try{
			//First we need to copy the extra stuff
			
			File validatorPath=new File(orip.getPath()+"/!validators/"+orip.getArg("Validator_"+oris.getTestset()));
			
			self.copyFile(validatorPath,new File(ConfigLoader.getPath()+"/judge/valid.exe"));
			
			//Chmod Operation for Linux
			ProcessBuilder pbch=new ProcessBuilder("chmod","777","valid.exe");
			pbch.directory(new File(ConfigLoader.getPath()+"/judge/"));
			Process pppp=pbch.start();
			pppp.waitFor();
			pppp.destroyForcibly();
			
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
		self.copyFile(f,new File(ConfigLoader.getPath()+"/judge/data/a.in"));
		
		// Use Std to generate output
		ProcessBuilder pb = new ProcessBuilder(new File(ConfigLoader.getPath()+"/judge/sol.exe").getAbsolutePath());
		pb.directory(new File(ConfigLoader.getPath()+"/judge/"));
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

	private String[] LinuxGetCompiler(String lang) {
		if (lang.equals("python")) {
			return new String[] {"exit"};
		}
		if (lang.equals("cpp")) {
			
			return new String[] { "g++", "Main.cpp", "-o","Main","-DONLINE_JUDGE", (self.con.isEnableCPP11()?"-std=c++11":"-DNOCPP"), "-O2"};
		}

		if (lang.equals("java")) {
			return new String[] { "javac", "-cp", "\".;*\"", "Main.java" };
		}
		return null;
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
		
		String content=self.readFile(ConfigLoader.getPath()+"/judge/judge.txt").split("\n")[0];
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
									  "Restrict Function",
									  "Judgement Failed",
									  "Runtime Error"};
		
		
		if(result==8){
			String verdict=int2str[result];
			s.setVerdict(verdict);
			s.setCompilerComment(self.readFile(ConfigLoader.getPath()+"/judge/temp/ce.txt"));
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
		ProcessBuilder pb=new ProcessBuilder("./checker.exe",
											 ConfigLoader.getPath()+"/judge/data/a.in",
											 ConfigLoader.getPath()+"/judge/temp/a.out",
											 ConfigLoader.getPath()+"/judge/data/a.out",
											 ConfigLoader.getPath()+"/judge/checker.txt");
		pb.directory(new File(ConfigLoader.getPath()+"/judge"));
		Process pro=pb.start();
		boolean ac=pro.waitFor(self.con.getWaitTimeout(),TimeUnit.SECONDS);
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
			s.getResults().add(new TestResult("Wrong Answer",time,mem,f.getName(),self.readFile(ConfigLoader.getPath()+"/judge/checker.txt")));
			new SubmissionHelper().storeStatus(s);
			return false;
		}
		s.getResults().add(new TestResult("Accepted",time,mem,f.getName(),self.readFile(ConfigLoader.getPath()+"/judge/checker.txt")));
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
			self.copyFile(new File(ConfigLoader.getPath()+"/runtime/Linux_config.ini"), new File(ConfigLoader.getPath()+"/judge/config.ini"));
			self.copyFile(new File(ConfigLoader.getPath()+"/runtime/Linux_okcall.cfg"), new File(ConfigLoader.getPath()+"/judge/okcall.cfg"));
			
			//Copy Solution to Temp
			self.copyFile(new File(ConfigLoader.getPath()+"/judge/Program."+self.getExtension(s.getLang())), new File(ConfigLoader.getPath()+"/judge/temp/Main."+self.getExtension(s.getLang())));

			
			//Now no need for these because of the change of the judging method
//			//Recopy solutions to Data
//			copyFile(new File(ConfigLoader.getPath()+"/judge/sol.exe"),new File(ConfigLoader.getPath()+"/judge/data/sol.cpp"));
//			
//			//Recopy Checker
//			copyFile(new File(ConfigLoader.getPath()+"/judge/checker.exe"),new File(ConfigLoader.getPath()+"/judge/checker.cpp"));
//			
			//LinuxCompile(s);
			
			//LinuxSanboxCompile(s);
			
			
			
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

	/**
	 * Compile the solution of Linux System
	 * @param s
	 * @throws Exception
	 */
	private boolean LinuxCompileSolution(Submission s) throws Exception{
		System.out.println("Compiling the given solution");

		s.setVerdict("Compiling");
		new SubmissionHelper().storeStatus(s);

		ProcessBuilder pb = new ProcessBuilder(LinuxGetCompiler(s.getLang()));
		pb.directory(new File(ConfigLoader.getPath()+"/judge/temp"));

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

		p.destroyForcibly();
		
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

			
			s.setVerdict("Compile Timeout");
			s.setCompilerComment("Compile Takes 15.00s");
			new SubmissionHelper().storeStatus(s);

			return false;
		}
	}


}
