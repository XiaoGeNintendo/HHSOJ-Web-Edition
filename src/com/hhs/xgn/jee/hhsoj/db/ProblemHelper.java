package com.hhs.xgn.jee.hhsoj.db;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.hhs.xgn.jee.hhsoj.type.Problem;

/**
 * Helper for Problems loading
 * @author XGN	
 *
 */
public class ProblemHelper {
	
	public synchronized ArrayList<Problem> getAllProblems(){
		File f=new File("hhsoj/problems");
		if(!f.exists()){
			f.mkdirs();
		}
		
		ArrayList<Problem> arr=new ArrayList<Problem>();
		for(String sub:f.list()){
			arr.add(readSingleProblem(sub));
		}
		
		//System.out.println("Read "+arr.size()+" problems.");
		return arr;
	}
	
	/**
	 * Get the problem data by a unique problem name
	 * @param s
	 * @return
	 */
	public synchronized Problem getProblemData(String s){
		return readSingleProblem(s);
	}
	
	
	public synchronized Problem getProblemData(int id){
		return readSingleProblem(id+"");
	}
	
	public synchronized Problem readSingleProblem(String folder){
		return readSingleProblem(folder,"hhsoj/problems",true);
	}
	
	/* Folder Structure
	 * 
	 * 	hhsoj
	 * 		-problems
	 * 			-1000
	 * 				-arg.txt
	 * 				-tests
	 * 					-test inputs
	 * 				-other files (solution & checker)
	 * 
	 * arg.txt contains:
	 * 		- Solution=sol.exe
	 * 		- Checker=checker.exe
	 * 		- Name=A+b Problem
	 * 		- TL=1000
	 * 		- ML=1000
	 * 		- Tag=math,implementation
	 * 		- Statement=statement.jsp
	 */
	public synchronized Problem readSingleProblem(String folder,String root,boolean setId){
		String base=root+"/"+folder+"/";
		
		Problem p=new Problem();
		
		p.setArg(getArg(base+"arg.txt"));
		if(setId)p.setId(Integer.parseInt(folder));
		p.setName(p.getArg("Name"));
		p.setTag(p.getArg("Tag"));
		
		return p;
	}
	
	private synchronized Map<String,String> getArg(String file){
		File f=new File(file);
		
		try{
			BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(f)));
			
			Map<String,String> mp=new HashMap<String,String>();
			
			String line;
			while((line=br.readLine())!=null){
				int pos=line.indexOf("=");
				String key=line.substring(0, pos);
				String value=line.substring(pos+1);
				mp.put(key, value);
			}
			
			br.close();
			
			//System.out.println(mp);
			return mp;
		}catch(Exception e){
//			e.printStackTrace();
			return null;
		}
	}
}
