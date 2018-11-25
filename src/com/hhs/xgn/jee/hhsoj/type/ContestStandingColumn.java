package com.hhs.xgn.jee.hhsoj.type;

import com.google.gson.Gson;

/**
 * The contest standing column
 * @author XGN
 *
 */
public class ContestStandingColumn {
	private int scoreSmall,scoreLarge;
	private int unsuccessfulSubmitCount;
	/**
	 * Absolute Time
	 */
	private long lastSubmissionTime;
	
	public void addUnsuccessfulSubmitCount(){
		unsuccessfulSubmitCount++;
	}
	
	/**
	 * Get final score
	 * @return the final score of this problem
	 */
	public int getScore(){
		return Math.max(0,scoreSmall+scoreLarge-unsuccessfulSubmitCount*50);
	}
	
	public ContestStandingColumn(){
		
	}
	
	public ContestStandingColumn(int scoreSmall,int usc,int lst){
		this.scoreSmall=scoreSmall;
		unsuccessfulSubmitCount=usc;
		lastSubmissionTime=lst;
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

	public int getScoreSmall() {
		return scoreSmall;
	}

	public void setScoreSmall(int scoreSmall) {
		this.scoreSmall = scoreSmall;
	}

	public int getScoreLarge() {
		return scoreLarge;
	}

	public void setScoreLarge(int scoreLarge) {
		this.scoreLarge = scoreLarge;
	}

	public int getRawScore() {
		// TODO Auto-generated method stub
		return scoreSmall+scoreLarge;
	}
	
}
