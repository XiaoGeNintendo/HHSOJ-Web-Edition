package com.hhs.xgn.jee.hhsoj.judger;

import java.io.*;
import java.util.concurrent.TimeUnit;

import com.hhs.xgn.jee.hhsoj.db.ConfigLoader;
import com.hhs.xgn.jee.hhsoj.db.ContestHelper;
import com.hhs.xgn.jee.hhsoj.db.ProblemHelper;
import com.hhs.xgn.jee.hhsoj.db.SubmissionHelper;
import com.hhs.xgn.jee.hhsoj.db.UserHelper;
import com.hhs.xgn.jee.hhsoj.remote.CodeforcesHelper;
import com.hhs.xgn.jee.hhsoj.remote.CodeforcesSubmission;
import com.hhs.xgn.jee.hhsoj.type.Config;
import com.hhs.xgn.jee.hhsoj.type.Contest;
import com.hhs.xgn.jee.hhsoj.type.CustomTestSubmission;
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
				if(p.getType()==Problem.HACK){
					Submission ori=new SubmissionHelper().getSubmission(s.getProb().substring(1));
					Problem op=new ProblemHelper().getProblemData(ori.getProb());
					
					boolean b=judger.judgeHack(s, p, u,op,ori);
					if(b){
						//OK to get a defender
						
						//Create temp folder
						File folder=new File(op.getPath()+"/hackAttempt_"+s.getId());
						File in=new File(op.getPath()+"/hackAttempt_"+s.getId()+"/hack.in");
						folder.mkdirs();
						
						//Write hack data
						PrintWriter pw=new PrintWriter(in);
						pw.println(s.getCode());
						pw.close();
						
						//Write defence submission
						Submission def=new Submission();
						def.setProb(ori.getProb());
						def.setCode(ori.getCode());
						def.setLang(ori.getLang());
						def.setUser(ori.getUser());
						def.setSubmitTime(System.currentTimeMillis());
						def.setTestset("hackAttempt_"+s.getId());
						
						TaskQueue.addTask(def);
					}
					continue;
				}
				
				if(p.getType()==Problem.CUSTOM){
					CustomTestSubmission cts=(CustomTestSubmission)s;
					judger.judgeCustomTest(cts);
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
					
					if(s.getTestset().startsWith("hackAttempt_")){
						//A hacking attempt but failed
						
						String lastId=s.getTestset().substring(12);
						Submission lastHack=new SubmissionHelper().getSubmission(lastId);
						lastHack.setVerdict("Unsuccessful Hacking Attempt");
						new SubmissionHelper().storeStatus(lastHack);
						
						//Remove the testset
						for(File x:testfiles.listFiles()){
							x.delete();
						}
						testfiles.delete();
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
					
					if(s.getTestset().startsWith("hackAttempt_")){
						//A hacking attempt but succeeded
						
						String lastId=s.getTestset().substring(12);
						Submission lastHack=new SubmissionHelper().getSubmission(lastId);
						lastHack.setVerdict("Successful Hacking Attempt");
						new SubmissionHelper().storeStatus(lastHack);
						
						//Remove the testset
						for(File x:testfiles.listFiles()){
							x.delete();
						}
						testfiles.delete();
						
						//Set the old solution to be hacked
						String llid=lastHack.getProb().substring(1);
						Submission ll=new SubmissionHelper().getSubmission(llid);
						ll.setVerdict("Hacked");
						ll.getResults().add(new TestResult("Hacked", s.getTimeCost(), s.getMemoryCost(), "Hack #"+lastId, s.getResults().get(0).getCheckerComment()));
						new SubmissionHelper().storeStatus(ll);
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
			boolean ok=p.waitFor(10,TimeUnit.SECONDS);
			if(!ok){
				s.setVerdict("Submit Timeout");
				new SubmissionHelper().storeStatus(s);
				return;
			}
			p.destroyForcibly();
			int exitcode=p.exitValue();
			if(exitcode!=0){
				s.setVerdict("Submit Failed");
				s.setCompilerComment("The spider exit code is "+exitcode);
				new SubmissionHelper().storeStatus(s);
				return;
			}
			
			//Start Listening On Codeforces every 1000ms
			
			CodeforcesSubmission cs=CodeforcesHelper.getLastSubmission();
			
			s.setVerdict("Judging");
			s.getResults().add(new TestResult("??", 0, 0, "??", "??"));
			new SubmissionHelper().storeStatus(s);
			
			while(true){
				Thread.sleep(1000);
				
				
				Submission trans=CodeforcesHelper.getTransfer(cs);
				
				s.setVerdict(trans.getVerdict());
				s.setNowTest(trans.getNowTest());
				s.setMaxTest(s.getNowTest()+1);
				s.setResults(trans.getResults());
				
				new SubmissionHelper().storeStatus(s);
				if(!trans.getVerdict().contains("Running") && !trans.getVerdict().contains("In queue") && !trans.getVerdict().contains("Testing")){
					break;
				}
			}
			
			s.setMaxTest(s.getNowTest());
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
		if(p.getType()!=Problem.CODEFORCES && p.getType()!=Problem.HACK && p.getType()!=Problem.CUSTOM){
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


	public void writeToFile(File file, String code) throws FileNotFoundException {
		PrintWriter pw=new PrintWriter(file);
		pw.print(code);
		pw.close();
	}


}
