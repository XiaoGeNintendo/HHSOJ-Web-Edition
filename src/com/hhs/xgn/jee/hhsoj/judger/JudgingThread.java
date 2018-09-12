package com.hhs.xgn.jee.hhsoj.judger;

import java.io.*;
import java.util.List;
import java.util.concurrent.TimeUnit;

import com.hhs.xgn.jee.hhsoj.db.ProblemHelper;
import com.hhs.xgn.jee.hhsoj.db.SubmissionHelper;
import com.hhs.xgn.jee.hhsoj.type.Problem;
import com.hhs.xgn.jee.hhsoj.type.Submission;
import com.hhs.xgn.jee.hhsoj.type.TestResult;

public class JudgingThread extends Thread {
	public void run(){
		System.out.println("Judging Thread Initaize Ok!");
		while(true){
			
			ClearFolder();
			while(TaskQueue.hasElement()==false){
				
			}
			
			
			Submission s=TaskQueue.getFirstSubmission();
			Problem p=new ProblemHelper().getProblemData(Integer.parseInt(s.getProb()));
			try{
				
				TaskQueue.popFront();
				
				
				System.out.println("Now testing:"+s.getId());
				
				Thread.sleep(1000);
				
				if(!checkEnvironment(s)){
					continue;
				}
				
				copyFiles(s,p);
				
				if(!compileFiles(s)){
					continue;
				}
				
				File testfiles=new File(p.getPath()+"/tests");
				
				for(File f:testfiles.listFiles()){
					boolean goon=judgeOneTestCase(s,f,p);
					if(!goon){
						continue;
					}
				}
				
				s.setVerdict("Accepted");
				new SubmissionHelper().storeStatus(s);
				
			}catch(Exception e){
				e.printStackTrace();
				
				s.setVerdict("Judgement Failed");
				s.setCompilerComment(e.toString());
				new SubmissionHelper().storeStatus(s);
			}
		}
	}
	
	private boolean judgeOneTestCase(Submission s, File f,Problem p) throws IOException, NumberFormatException, InterruptedException {
		System.out.println("Testing...");
		
		//Copy input file
		copyFile(f,new File("hhsoj/judge/in.txt"));
		
		//Use Std to generate output
		ProcessBuilder pb=new ProcessBuilder("sol.exe");
		pb.directory(new File("hhsoj/judge"));
		pb.redirectOutput(new File("hhsoj/judge/std_out.txt"));
		Process pr=pb.start();
		
		//We made sure that std is right and no harmful, but may TLE
		boolean ac=pr.waitFor(Integer.parseInt(p.getArg("TL")), TimeUnit.MILLISECONDS);
		pr.destroyForcibly();
		
		if(ac){
			//Std ok
			
			//Then we run the user's program. We should run it in a sandbox
			runUserProgram(s,f,p);
			
		}else{
			//Std error
			s.setVerdict("Standard Program Time Limit Exceeded");
			s.getResults().add(new TestResult("Standard Program Time Limit", 0, 0, f.getName(), "std error"));
			new SubmissionHelper().storeStatus(s);
			return false;
		}
		
		return false;
	}

	private void runUserProgram(Submission s, File f, Problem p) {
		//We call the cpp program to run the program
		
	}

	private void ClearFolder() {
		System.out.println("Clearing folder");
		File ff=new File("hhsoj/judge");
		for(File f:ff.listFiles()){
			f.delete();
		}
	}

	private boolean compileFiles(Submission s) throws IOException, InterruptedException {
		System.out.println("Compiling the given solution");
		
		s.setVerdict("Compiling");
		new SubmissionHelper().storeStatus(s);
		
		ProcessBuilder pb=new ProcessBuilder(getCompiler(s.getLang()));
		pb.directory(new File("hhsoj/judge"));
		
		pb.redirectError(new File("hhsoj/judge/compile.txt"));
		
		
		Process p=pb.start();
		
		
		long tme=System.currentTimeMillis();
		
		boolean killed=true;
		while(p.isAlive()){
			if(System.currentTimeMillis()-tme>=15*1000){
				
				killed=false;
				break;
			}
		}
		
		
		
		if(killed){
			//Fit in time
			int id=p.exitValue();
			
			if(id!=0){
				//Compile Error
				s.setVerdict("Compile Error");
				s.setCompilerComment(readFile("hhsoj/judge/compile.txt"));
				new SubmissionHelper().storeStatus(s);
				
				return false;
			}
			
			s.setVerdict("Judging");
			s.setCompilerComment(readFile("hhsoj/judge/compile.txt"));
			new SubmissionHelper().storeStatus(s);
			
			return true;
		}else{
			//Compile timeout
			
			killCompiler(s);
			s.setVerdict("Compile Timeout");
			s.setCompilerComment("Compile Takes 15.00s");
			new SubmissionHelper().storeStatus(s);
			
			return false;
		}
	}

	private void killCompiler(Submission s) throws IOException {
		if(s.getLang().equals("cpp")){
			ProcessBuilder pb=new ProcessBuilder("taskkill", "/f", "/im" ,"g++.exe" ,"/t");
			pb.directory(new File("hhsoj/runtime"));
			pb.start();
		}
	}

	private String readFile(String file) throws IOException {
		BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(file)));
		String s,ans="";
		while((s=br.readLine())!=null){
			ans+=s+"\n";
			if(ans.length()>=1000){
				ans+="...(and more)";
				break;
			}
		}
		
		br.close();
		return ans;
	}

	private String[] getCompiler(String lang) {
		if(lang.equals("python")){
			return new String[]{};
		}
		if(lang.equals("cpp")){
			
			return new String[]{"g++","-static","-DONLINE_JUDGE","-std=c++11","-O2","-Wl,--stack=268435456","-s","-x","c++","-o","Program.exe","Program.cpp"};
		}
			
		if(lang.equals("java")){
			return new String[]{"javac","-cp","\".;*\"","Program.java"};
		}
		return null;
	}

	/**
     * 复制文件
     * @param fromFile
     * @param toFile
     * <br/>
     * 2016年12月19日  下午3:31:50
     * @throws IOException 
     */
    private void copyFile(File fromFile,File toFile) throws IOException{
        FileInputStream ins = new FileInputStream(fromFile);
        FileOutputStream out = new FileOutputStream(toFile);
        byte[] b = new byte[1024];
        int n=0;
        while((n=ins.read(b))!=-1){
            out.write(b, 0, n);
        }
        
        ins.close();
        out.close();
    }
    
	private void copyFiles(Submission s,Problem p) throws IOException {
		System.out.println("Copying files");
		int id=Integer.parseInt(s.getProb());
		
		
		//Copy Solution
		File oldSol=new File(p.getPath()+"/"+p.getArg("Solution"));
		File newSol=new File("hhsoj/judge/sol.exe");
		copyFile(oldSol,newSol);
		
		//Copy Checker
		File oldChk=new File(p.getPath()+"/"+p.getArg("Checker"));
		File newChk=new File("hhsoj/judge/checker.exe");
		copyFile(oldChk,newChk);
		
		//Copy User's Program
		PrintWriter pw=new PrintWriter("hhsoj/judge/Program."+getExtension(s.getLang()));
		pw.println(s.getCode());
		pw.close();
		
		
	}

	private String getExtension(String lang) {
		if(lang.equals("python")){
			return "py";
		}else{
			return lang;
		}
		
	}

	private boolean checkEnvironment(Submission s){
		
		System.out.println("Checking environment");
		
		File f=new File("hhsoj/judge");
		if(!f.exists()){
			f.mkdirs();
		}
		
		File f2=new File("hhsoj/runtime/oj.exe");
		if(!f2.exists()){
			s.setVerdict("Library Missing");
			s.setCompilerComment("Please contact the admin of the server and tell him/her that the oj.exe was not in the position it should be.The judging cannot continue untils the problem fixed.");
			new SubmissionHelper().storeStatus(s);
			return false;
		}
		
		return true;
	}
}
