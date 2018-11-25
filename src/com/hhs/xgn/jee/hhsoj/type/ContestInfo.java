package com.hhs.xgn.jee.hhsoj.type;

import java.util.ArrayList;
import java.util.Map;

import com.google.gson.Gson;
import com.hhs.xgn.jee.hhsoj.db.UserRenderer;

/**
 * Some contest information
 * @author XGN
 *
 */
public class ContestInfo {
	private String name;
	private long startTime;
	/**
	 * In milliseconds
	 */
	private int length;
	/**
	 * The scores of problem index
	 */
	private Map<String,ProblemScore> scores;
	private ArrayList<String> authors;
	
	public String getReadableLength(){
		int sec=length/1000;
		int min=sec/60;
		int hour=min/60;
		return hour+"h"+min%60+"m"+sec%60+"s";
	}
	public String getAuthorsHTML(){
		String s="";
		for(String a:authors){
			s+=new UserRenderer().getUserText(a)+"<br/>";
		}
		return s;
	}
	
	public String toJson(){
		return new Gson().toJson(this);
	}
	public long getEndTime(){
		return startTime+length;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public long getStartTime() {
		return startTime;
	}
	public void setStartTime(long startTime) {
		this.startTime = startTime;
	}
	public int getLength() {
		return length;
	}
	public void setLength(int length) {
		this.length = length;
	}
	public Map<String, ProblemScore> getScores() {
		return scores;
	}
	public void setScores(Map<String, ProblemScore> scores) {
		this.scores = scores;
	}
	public ArrayList<String> getAuthors() {
		return authors;
	}
	public void setAuthors(ArrayList<String> authors) {
		this.authors = authors;
	}
	
	
}
