package com.hhs.xgn.jee.hhsoj.type;

/**
 * Test results
 * @author XGN
 *
 */
public class TestResult {
	private String verdict;
	private int timeCost;
	private int memoryCost;
	private String file;
	private String checkerComment;
	public TestResult(){
		
	}
	public TestResult(String verdict, int timeCost, int memoryCost, String file, String checkerComment) {
		this.verdict = verdict;
		this.timeCost = timeCost;
		this.memoryCost = memoryCost;
		this.file = file;
		this.checkerComment = checkerComment;
	}
	public String getVerdict() {
		return verdict;
	}
	public void setVerdict(String verdict) {
		this.verdict = verdict;
	}
	public int getTimeCost() {
		return timeCost;
	}
	public void setTimeCost(int timeCost) {
		this.timeCost = timeCost;
	}
	public int getMemoryCost() {
		return memoryCost;
	}
	public void setMemoryCost(int memoryCost) {
		this.memoryCost = memoryCost;
	}
	public String getFile() {
		return file;
	}
	public void setFile(String file) {
		this.file = file;
	}
	public String getCheckerComment() {
		return checkerComment;
	}
	public void setCheckerComment(String checkerComment) {
		this.checkerComment = checkerComment;
	}
	
}
