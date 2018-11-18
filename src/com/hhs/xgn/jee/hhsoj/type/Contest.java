package com.hhs.xgn.jee.hhsoj.type;

import java.io.File;
import java.util.ArrayList;

import com.google.gson.Gson;
import com.hhs.xgn.jee.hhsoj.db.ProblemHelper;

/**
 * Contest class
 * @author XGN
 *
 */
public class Contest {
	private ContestInfo info;
	private int id;
	private ContestStandings standing;
	
	/**
	 * Get all problems
	 * @return
	 */
	public ArrayList<Problem> getProblems(){
		File f=new File("hhsoj/contests/"+id+"/");
		ArrayList<Problem> arr=new ArrayList<Problem>();
		
		for(File sub:f.listFiles()){
			if(sub.isDirectory()){
				Problem p=new ProblemHelper().readSingleProblem(sub.getName(),"hhsoj/contests/"+id,false);
				p.setType(Problem.CONTEST);
				p.setConId(id);
				p.setConIndex(sub.getName());
				arr.add(p);
			}
		}
		
		return arr;
	}
	
	public String toJson(){
		return new Gson().toJson(this);
	}
	
	public Contest(){
		info=new ContestInfo();
		id=0;
		standing=new ContestStandings();
	}
	
	/**
	 * Create a new contest without everything
	 * @param ci
	 */
	public Contest(ContestInfo ci,int Id) {
		info=ci;
		id=Id;
		standing=new ContestStandings();
	}

	/**
	 * In html: Before/Running/Finished
	 * @return
	 */
	public String getStatus(){
		long now=System.currentTimeMillis();
		long st=info.getStartTime();
		long ed=info.getEndTime();
		if(now<st){
			return "<font color=#0000ff>Before</font>";
		}
		if(st<=now && now<=ed){
			return "<font color=#ff0000>Running</font>";
		}
		if(ed<now){
			return "<font color=#787878>Finished</font>";
		}
		return "Unknown";
	}
	public ContestInfo getInfo() {
		return info;
	}
	public void setInfo(ContestInfo info) {
		this.info = info;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public ContestStandings getStanding() {
		return standing;
	}
	public void setStanding(ContestStandings standing) {
		this.standing = standing;
	}
	
	
}
