package com.hhs.xgn.jee.hhsoj.db;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.ArrayList;

import com.google.gson.Gson;
import com.hhs.xgn.jee.hhsoj.type.Submission;

/**
 * Class for submissions storing
 * @author XGN
 *
 */
public class SubmissionHelper {
	
	/**
	 * Gives a new id
	 * @return
	 */
	public synchronized int getNewId(){
		File f=new File("hhsoj/submission");
		if(!f.exists()){
			f.mkdirs();
		}
		
		return f.list().length+1;
	}
	
	/**
	 * Store the given submission
	 * @param s
	 */
	public synchronized void storeStatus(Submission s){
		try{
			Gson gson=new Gson();
			String json=gson.toJson(s);
			File f=new File("hhsoj/submission/"+s.getId());
			PrintWriter pw=new PrintWriter(f);
			pw.println(json);
			pw.close();
			
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public synchronized ArrayList<Submission> getAllSubmissions(){
		ArrayList<Submission> sb=new ArrayList<Submission>();
		
		File f=new File("hhsoj/submission");
		
		Gson gs=new Gson();
		for(File sub:f.listFiles()){
			
			try{
				BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(sub)));
				String s=br.readLine();
				br.close();
				
				Submission sss=gs.fromJson(s, Submission.class);
				if(sss!=null){
					sb.add(sss);
				}
				
			}catch(Exception e){
				e.printStackTrace();
			}
					
		}
		
		return sb;
	}
	
	public synchronized Submission getSubmission(int id){
		
		try{
			File f=new File("hhsoj/submission/"+id);
			Gson gs=new Gson();
			BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(f)));
			String s=br.readLine();
			br.close();
			
			return gs.fromJson(s, Submission.class);
		}catch(Exception e){
			return null;
		}
	}
}
