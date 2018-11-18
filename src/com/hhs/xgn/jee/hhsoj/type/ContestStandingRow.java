package com.hhs.xgn.jee.hhsoj.type;

import java.util.Map;
import java.util.Map.Entry;

import com.google.gson.Gson;


/**
 * The single row of a standing
 * @author XGN
 *
 */
public class ContestStandingRow {
	private String user;
	private Map<String, ContestStandingColumn> scores;
	
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
	public Map<String, ContestStandingColumn> getScores() {
		return scores;
	}
	public void setScores(Map<String, ContestStandingColumn> scores) {
		this.scores = scores;
	}
	
}
