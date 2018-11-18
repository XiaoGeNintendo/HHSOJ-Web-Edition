package com.hhs.xgn.jee.hhsoj.type;

import java.util.ArrayList;
import java.util.Map;

import com.google.gson.Gson;

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
	private Map<String,Integer> scores;
	private ArrayList<String> authors;
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
	public Map<String, Integer> getScores() {
		return scores;
	}
	public void setScores(Map<String, Integer> scores) {
		this.scores = scores;
	}
	public ArrayList<String> getAuthors() {
		return authors;
	}
	public void setAuthors(ArrayList<String> authors) {
		this.authors = authors;
	}
	
	
}
