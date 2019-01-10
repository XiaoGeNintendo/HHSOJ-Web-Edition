package com.hhs.xgn.jee.hhsoj.db;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.nio.Buffer;
import java.util.*;

import com.google.gson.Gson;
import com.hhs.xgn.jee.hhsoj.type.*;
/**
 * Used for solving contests
 * @author XGN
 *
 */
public class ContestHelper {
	
	public synchronized File checkFolder(){
		File f=new File(ConfigLoader.getPath()+"/contests");
		if(!f.exists()){
			f.mkdirs();
		}
		return f;
	}
	public synchronized ArrayList<Contest> getAllContests(){
		File f=checkFolder();
		
		ArrayList<Contest> arr=new ArrayList<>();
		for(File sub:f.listFiles()){
			Contest c=readSingleContest(sub);
			if(c!=null){
				arr.add(c);
			}
			
		}
		
		return arr;
	}
	
	/**
	 * Get the contest with a root directory
	 * @param root - the root directory
	 * @return the contests nested in that directory
	 */
	public synchronized Contest readSingleContest(File root){
		//Does it have full.json?
		File full=new File(root.getAbsolutePath()+"/full.json");
		if(full.exists()){
			//Full file exists
			try{
				BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(full),"utf-8"));
				String json=br.readLine();
				br.close();
				return new Gson().fromJson(json, Contest.class);
			}catch(Exception e){
				e.printStackTrace();
				return null;
			}
		}
		
		//No full file exists
		File info=new File(root.getAbsolutePath()+"/info.json");
		if(info.exists()){
			//info.json exists
			try{
				BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(info)));
				String s, ans = "";
				while ((s = br.readLine()) != null) {
					ans += s + "\n";
				}
		
				br.close();
				
				ContestInfo ci=new Gson().fromJson(ans, ContestInfo.class);
				
				Contest ret=new Contest(ci,Integer.parseInt(root.getName()));
				
				//Generate full.json
				PrintWriter pw=new PrintWriter(full);
				pw.println(new Gson().toJson(ret));
				pw.close();
				return ret;
			}catch(Exception e){
				e.printStackTrace();
				return null;
			}
		}
		
		//Nothing exists!
		return null;
	}
	
	public Contest getContestDataById(String id){
		return readSingleContest(new File(ConfigLoader.getPath()+"/contests/"+id));
	}
	
	public void refreshContest(Contest c) {
		
		try{
			PrintWriter pw=new PrintWriter(ConfigLoader.getPath()+"/contests/"+c.getId()+"/full.json");
			pw.println(new Gson().toJson(c));
			pw.close();
		}catch(Exception e){
			
		}
	}
}
