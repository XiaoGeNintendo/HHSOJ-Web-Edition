package com.hhs.xgn.jee.hhsoj.remote;

import com.google.gson.JsonObject;

public class CodeforcesSubmission {
	private int id;
	private int contestId;
	private int creationTimeSeconds;
	private int relativeTimeSeconds;
	private CodeforcesProblem problem;
	private JsonObject author;
	private String programmingLanguage;
	private String verdict;
	private String testset;
	private int passedTestCount;
	private int timeConsumedMillis;
	private int memoryConsumedBytes;
	
	/**
	 * Returns verdict that in hhsoj
	 * @return
	 */
	public String getExchangeVerdict(){
		if(verdict.equals("OK")){
			return "Accepted";
		}
		
		String nw=verdict.toLowerCase().replace("_", " ");
		String ano=""+(char)(nw.charAt(0)-'a'+'A');
		for(int i=1;i<nw.length();i++){
			if(nw.charAt(i-1)==' '){
				ano+=(char)(nw.charAt(i)-'a'+'A');
			}else{
				ano+=nw.charAt(i);
			}
		}
		return ano;
	}
	
	public CodeforcesSubmission(){
		problem=new CodeforcesProblem();
		author=new JsonObject();
		programmingLanguage="";
		verdict="";
		testset="";
	}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getContestId() {
		return contestId;
	}
	public void setContestId(int contestId) {
		this.contestId = contestId;
	}
	public int getCreationTimeSeconds() {
		return creationTimeSeconds;
	}
	public void setCreationTimeSeconds(int creationTimeSeconds) {
		this.creationTimeSeconds = creationTimeSeconds;
	}
	public int getRelativeTimeSeconds() {
		return relativeTimeSeconds;
	}
	public void setRelativeTimeSeconds(int relativeTimeSeconds) {
		this.relativeTimeSeconds = relativeTimeSeconds;
	}
	public CodeforcesProblem getProblem() {
		return problem;
	}
	public void setProblem(CodeforcesProblem problem) {
		this.problem = problem;
	}
	public JsonObject getAuthor() {
		return author;
	}
	public void setAuthor(JsonObject author) {
		this.author = author;
	}
	public String getProgrammingLanguage() {
		return programmingLanguage;
	}
	public void setProgrammingLanguage(String programmingLanguage) {
		this.programmingLanguage = programmingLanguage;
	}
	public String getVerdict() {
		return verdict;
	}
	public void setVerdict(String verdict) {
		this.verdict = verdict;
	}
	public String getTestset() {
		return testset;
	}
	public void setTestset(String testset) {
		this.testset = testset;
	}
	public int getPassedTestCount() {
		return passedTestCount;
	}
	public void setPassedTestCount(int passedTestCount) {
		this.passedTestCount = passedTestCount;
	}
	public int getTimeConsumedMillis() {
		return timeConsumedMillis;
	}
	public void setTimeConsumedMillis(int timeConsumedMillis) {
		this.timeConsumedMillis = timeConsumedMillis;
	}
	public int getMemoryConsumedBytes() {
		return memoryConsumedBytes;
	}
	public void setMemoryConsumedBytes(int memoryConsumedBytes) {
		this.memoryConsumedBytes = memoryConsumedBytes;
	}
	
}
