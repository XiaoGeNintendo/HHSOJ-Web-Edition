package com.hhs.xgn.jee.hhsoj.type;

import java.util.ArrayList;

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
	
	public Submission(){
		results=new ArrayList<TestResult>();
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
}
