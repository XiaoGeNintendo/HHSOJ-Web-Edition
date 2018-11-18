package com.hhs.xgn.jee.hhsoj.type;

import com.google.gson.Gson;

/**
 * The contest standing column
 * @author XGN
 *
 */
public class ContestStandingColumn {
	private int rawScore;
	private int unsuccessfulSubmitCount;
	/**
	 * Absolute Time
	 */
	private long lastSubmissionTime;
	
	/**
	 * Get final score
	 * @return the final score of this problem
	 */
	public int getScore(){
		return Math.max(0,rawScore-unsuccessfulSubmitCount*50);
	}
	
	public ContestStandingColumn(){
		
	}
	
	public ContestStandingColumn(int score,int usc,int lst){
		rawScore=score;
		unsuccessfulSubmitCount=usc;
		lastSubmissionTime=lst;
	}
	
	public int getRawScore() {
		return rawScore;
	}
	public void setRawScore(int rawScore) {
		this.rawScore = rawScore;
	}
	public int getUnsuccessfulSubmitCount() {
		return unsuccessfulSubmitCount;
	}
	public void setUnsuccessfulSubmitCount(int unsuccessfulSubmitCount) {
		this.unsuccessfulSubmitCount = unsuccessfulSubmitCount;
	}
	public long getLastSubmissionTime() {
		return lastSubmissionTime;
	}
	public void setLastSubmissionTime(long lastSubmissionTime) {
		this.lastSubmissionTime = lastSubmissionTime;
	}
	public String toJson(){
		return new Gson().toJson(this);
	}
	
}
