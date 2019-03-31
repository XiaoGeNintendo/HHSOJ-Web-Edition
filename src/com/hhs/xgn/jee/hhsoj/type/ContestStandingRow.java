package com.hhs.xgn.jee.hhsoj.type;

import java.util.HashMap;
import java.util.Map.Entry;

import com.google.gson.Gson;


/**
 * The single row of a standing
 * @author XGN
 *
 */
public class ContestStandingRow {
	private String user;
	private HashMap<String, ContestStandingColumn> scores=new HashMap<>();
	
	public int getScore(){
		int s=0;
		for(Entry<String, ContestStandingColumn> e:scores.entrySet()){
			s+=e.getValue().getScore();
		}
		return s;
	}
	public String toJson(){
		return new Gson().toJson(this);
	}
	/**
	 * get the last submission time. 0 if no correct submission were made
	 * @return
	 */
	public long getPenalty(){
		long s=0;
		for(Entry<String, ContestStandingColumn> e:scores.entrySet()){
			s=Math.max(s, e.getValue().getLastSubmissionTime());
		}
		return s;
	}
	
	public String getUser() {
		return user;
	}
	public void setUser(String user) {
		this.user = user;
	}
	public HashMap<String, ContestStandingColumn> getScores() {
		return scores;
	}
	public void setScores(HashMap<String, ContestStandingColumn> scores) {
		this.scores = scores;
	}
	
}
