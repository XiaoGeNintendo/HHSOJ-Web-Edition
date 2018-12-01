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
	private ArrayList<Question> questions;
	
	/**
	 * returns whether the time is in contest running
	 * @param st
	 * @return
	 */
	public boolean inRange(long st){
		return info.getStartTime()<=st && st<=info.getEndTime();
	}
	
	public boolean isContestStarted(){
		return System.currentTimeMillis()>=info.getStartTime();
	}
	
	public boolean isContestEnded(){
		return System.currentTimeMillis()>info.getEndTime();
	}
	
	public boolean isContestRunning(){
		return isContestStarted() && !isContestEnded();
	}
	
	/**
	 * Use the given index to get the problem
	 * @param id
	 * @return null if not found
	 */
	public Problem getProblem(String id){
		ArrayList<Problem> arr=getProblems();
		for(Problem a:arr){
			if(a.getConIndex().equals(id)){
				return a;
			}
		}
		return null;
	}
	
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
		questions=new ArrayList<>();
	}
	
	/**
	 * Create a new contest without everything
	 * @param ci
	 */
	public Contest(ContestInfo ci,int Id) {
		info=ci;
		id=Id;
		standing=new ContestStandings();
		questions=new ArrayList<>();
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
	
	/**
	 * Returns the contest status with time information
	 * @return
	 */
	public String getStatusWithTime(){
		long now=System.currentTimeMillis();
		long st=info.getStartTime();
		long ed=info.getEndTime();
		if(now<st){
			return "<font color=#0000ff>Before</font>";
		}
		if(st<=now && now<=ed){
			long delta=ed-now;
			delta/=1000;
			return "<font color=#ff0000>Running "+delta/3600+"h"+delta%3600/60+"m"+delta%60+"s"+"</font>";
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

	public ArrayList<Question> getQuestions() {
		return questions;
	}

	public void setQuestions(ArrayList<Question> questions) {
		this.questions = questions;
	}
	
	
}
