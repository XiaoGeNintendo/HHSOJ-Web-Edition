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
	private long length;
	/**
	 * The scores of problem index
	 */
	private Map<String,ProblemScore> scores;
	private ArrayList<String> authors;
	
	/**
	 * Delay start time
	 * @param time
	 */
	public void delay(long time){
		startTime+=time;
	}
	
	/**
	 * Increase contest length
	 * @param inc
	 */
	public void increaseLength(long inc){
		length+=inc;
	}
	
	public String getReadableLength(){
		long sec=length/1000;
		long min=sec/60;
		long hour=min/60;
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
	public long getLength() {
		return length;
	}
	public void setLength(long length) {
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
