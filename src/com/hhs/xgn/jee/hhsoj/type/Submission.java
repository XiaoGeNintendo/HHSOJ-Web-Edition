package com.hhs.xgn.jee.hhsoj.type;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import com.google.gson.Gson;

/**
 * Submission class
 * @author XGN
 *
 */
public class Submission {
	private String user;
	private String prob;
	private String code;
	private String lang;
	private String verdict;
	private ArrayList<TestResult> results;
	private String compilerComment;
	private int id;
	private String testset;
	private long submitTime;
	private int nowTest;
	private int maxTest;
	
	public String toJson(){
		return new Gson().toJson(this);
	}
	public String getReadableTime(){
		return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(submitTime));
	}
	
	public Submission(){
		results=new ArrayList<TestResult>();
	}
	
	public String getHTMLVerdict(){
		if(verdict.startsWith("Running on test")){
			return verdict+"<progress value=\""+nowTest+"\" max=\""+maxTest+"\"></progress>";
		}
		if(verdict.equals("Judging") || verdict.equals("Compiling") || verdict.equals("In queue")){
			return verdict+"<progress></progress>";
		}
		return verdict;
	}
	
	public int getTimeCost(){
		int tl=0;
		for(TestResult tr:results){
			tl=Math.max(tl, tr.getTimeCost());
		}
		
		return tl;
	}
	
	public int getMemoryCost(){
		int ml=0;
		for(TestResult tr:results){
			ml=Math.max(ml, tr.getMemoryCost());
		}
		return ml;
	}

	public String getUser() {
		return user;
	}

	public void setUser(String user) {
		this.user = user;
	}

	public String getProb() {
		return prob;
	}

	public void setProb(String prob) {
		this.prob = prob;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getLang() {
		return lang;
	}

	public void setLang(String lang) {
		this.lang = lang;
	}

	public String getVerdict() {
		return verdict;
	}

	public void setVerdict(String verdict) {
		this.verdict = verdict;
	}

	public ArrayList<TestResult> getResults() {
		return results;
	}

	public void setResults(ArrayList<TestResult> results) {
		this.results = results;
	}

	public String getCompilerComment() {
		return compilerComment;
	}

	public void setCompilerComment(String compilerComment) {
		this.compilerComment = compilerComment;
	}
	
	public int getId(){
		return id;
	}
	
	public void setId(int nid){
		id=nid;
	}
	public String getTestset() {
		return testset;
	}
	public void setTestset(String testset) {
		this.testset = testset;
	}
	public long getSubmitTime() {
		return submitTime;
	}
	public void setSubmitTime(long submitTime) {
		this.submitTime = submitTime;
	}

	public int getNowTest() {
		return nowTest;
	}

	/**
	 * -1 means waiting somehow. <br/>
	 * -2 means ended somehow
	 */
	public void setNowTest(int nowTest) {
		this.nowTest = nowTest;
	}

	public int getMaxTest() {
		return maxTest;
	}

	public void setMaxTest(int maxTest) {
		this.maxTest = maxTest;
	}

	@Override
	public String toString() {
		return "Submission [user=" + user + ", prob=" + prob + ", code=" + code + ", lang=" + lang + ", verdict="
				+ verdict + ", results=" + results + ", compilerComment=" + compilerComment + ", id=" + id
				+ ", testset=" + testset + ", submitTime=" + submitTime + ", nowTest=" + nowTest + ", maxTest="
				+ maxTest + "]";
	}
}
