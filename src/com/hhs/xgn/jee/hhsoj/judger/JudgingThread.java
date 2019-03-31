package com.hhs.xgn.jee.hhsoj.judger;

import java.io.*;
import java.util.concurrent.TimeUnit;

import com.google.gson.Gson;
import com.hhs.xgn.jee.hhsoj.db.ConfigLoader;
import com.hhs.xgn.jee.hhsoj.db.ContestHelper;
import com.hhs.xgn.jee.hhsoj.db.ProblemHelper;
import com.hhs.xgn.jee.hhsoj.db.SubmissionHelper;
import com.hhs.xgn.jee.hhsoj.db.UserHelper;
import com.hhs.xgn.jee.hhsoj.remote.CodeforcesHelper;
import com.hhs.xgn.jee.hhsoj.remote.CodeforcesSubmission;
import com.hhs.xgn.jee.hhsoj.type.Config;
import com.hhs.xgn.jee.hhsoj.type.Contest;
import com.hhs.xgn.jee.hhsoj.type.Problem;
import com.hhs.xgn.jee.hhsoj.type.Submission;
import com.hhs.xgn.jee.hhsoj.type.TestResult;
import com.hhs.xgn.jee.hhsoj.type.Users;

public class JudgingThread extends Thread {
	
	public Config con;
	
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
			Users u=new UserHelper().getUserInfo(s.getUser());
			
			try{
				File testfiles = new File(p.getPath() + "/"+s.getTestset());
				TaskQueue.popFront();
				System.out.println("Now testing:" + s.getId());
				Thread.sleep(1000);
				
				copyFiles(s,p);
				
				AbstractJudger judger=null;
				
				if(ConfigLoader.isLinux()){
					//TODO Linux Judger
					judger=new LinuxJudger();
				}else{
					judger=new WindowsJudger();
				}
				
				boolean res=judger.init(s,p,u,this);
				
				if(!res){
					continue;
				}
				
				if(p.getType()==Problem.CODEFORCES){
					if(!con.isEnableRemoteJudge()){
						//Not allowed
						s.setVerdict("Submit Failed");
						s.setCompilerComment("Remote Judge is not allowed");
						new SubmissionHelper().storeStatus(s);
						continue;
					}
					
					submitCodeforces(s, con, u);
					continue;
				}
				

				if(!testfiles.isDirectory()){
					throw new Exception("Testcase is not ready");
				}
				
				s.setNowTest(0);
				s.setMaxTest(testfiles.list().length);
				
				boolean isAc=judger.judgeNormal(s, p, u,testfiles);
				
				if (isAc) {
					s.setVerdict("Accepted");
					new SubmissionHelper().storeStatus(s);
					u.setProblemStatus(s.getProb(),Users.SOLVED);
					new UserHelper().refreshUser(u);
					
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
					u.setProblemStatus(s.getProb(),Users.ATTEMPTED);
					new UserHelper().refreshUser(u);
					
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
				
			}catch(Exception e){

				e.printStackTrace();

				s.setVerdict("Judgement Failed");
				s.setCompilerComment(e.toString());
				new SubmissionHelper().storeStatus(s);
			}
			
		
		}
	}

	

	private void submitCodeforces(Submission s,Config c,Users u) {
		
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
				s.getResults().set(0,new TestResult(cs.getVerdict(),cs.getTimeConsumedMillis(),cs.getMemoryConsumedBytes()/1024,"??","??"));
				
				new SubmissionHelper().storeStatus(s);
				if(!cs.getVerdict().equals("TESTING")){
					break;
				}
			}
			
			if(s.getVerdict().equals("Accepted")){
				u.setProblemStatus(s.getProb(),Users.SOLVED);
				
			}else{
				u.setProblemStatus(s.getProb(),Users.ATTEMPTED);
				
			}
			
			new UserHelper().refreshUser(u);
			
		}catch(Exception e){
			s.setVerdict("Judgement Failed");
			s.setCompilerComment(e+"");
			new SubmissionHelper().storeStatus(s);
		}
	}

	private Config readGlobalConfig() {
		return new ConfigLoader().load();
	}

	

	private void ClearFolder() {
		System.out.println("Clearing folder");
		File ff = new File(ConfigLoader.getPath()+"/judge");
		for (File f : ff.listFiles()) {
			f.delete();
		}
	}

	/**
	 * A file reader with limit
	 * @param file
	 * @return
	 * @throws IOException
	 */
	public String readFile(String file) throws IOException {
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
	
	/**
	 * Copy a file
	 * 
	 * @param fromFile
	 * @param toFile
	 *            <br/>
	 *            
	 * @throws IOException
	 */
	public void copyFile(File fromFile, File toFile) throws IOException {
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
		
		//Copy Linux Sandbox
		File lsb=new File(ConfigLoader.getPath()+"/runtime/Judge");
		File nls=new File(ConfigLoader.getPath()+"/judge/judge");
		copyFile(lsb,nls);
	}

	public String getExtension(String lang) {
		if (lang.equals("python")) {
			return "py";
		} else {
			return lang;
		}

	}


}
