package com.hhs.xgn.jee.hhsoj.type;

import com.google.gson.Gson;

/**
 * Contest class
 * @author XGN
 *
 */
public class Contest {
	private ContestInfo info;
	private int id;
	private ContestStandings standing;
	
	public String toJson(){
		return new Gson().toJson(this);
	}
	
	public Contest(){
		
	}
	public ContestInfo getInfo() {
		return info;
	}
	public void setInfo(ContestInfo info) {
		this.info = info;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public ContestStandings getStanding() {
		return standing;
	}
	public void setStanding(ContestStandings standing) {
		this.standing = standing;
	}
	
	
}
