package com.hhs.xgn.jee.hhsoj.type;

import java.util.Map;

import com.hhs.xgn.jee.hhsoj.db.ConfigLoader;
import com.hhs.xgn.jee.hhsoj.db.ContestHelper;

/**
 * Problem class.
 * @author XGN
 * How to make a problem? First create the problem ID folder in /problems
 * then put the statement into problem folder
 */
public class Problem {
	private int id;
	private String name;
	private String tag;
	private Map<String, String> arg;
	private int type;
	
	private int conId;
	private String conIndex;
	public final static int PROBLEMSET=0;
	public final static int CONTEST=1;
	public final static int CODEFORCES=2;
	
	public boolean isHackable(String testset){
		return arg.containsKey("Validator_"+testset);
	}
	
	public String getPath(){
		if(type==PROBLEMSET){
			return ConfigLoader.getPath()+"/problems/"+id;
		}
		if(type==CONTEST){
			return ConfigLoader.getPath()+"/contests/"+conId+"/"+conIndex;
		}
		if(type==CODEFORCES){
			return null;
		}
		return null;
	}

	/**
	 * Get the contest where this problem is in
	 * @return
	 */
	public Contest getContest(){
		if(type!=Problem.CONTEST){
			return null;
		}
		return new ContestHelper().getContestDataById(""+conId);
	}
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getTag() {
		return tag;
	}

	public void setTag(String tag) {
		this.tag = tag;
	}

	public String getArg(String name){
		return arg.get(name);
	}
	
	public void setArg(Map<String,String> mp){
		this.arg=mp;
	}


	public int getType() {
		return type;
	}


	public void setType(int type) {
		this.type = type;
	}


	public int getConId() {
		return conId;
	}


	public void setConId(int conId) {
		this.conId = conId;
	}


	public String getConIndex() {
		return conIndex;
	}


	public void setConIndex(String conIndex) {
		this.conIndex = conIndex;
	}


	public Map<String, String> getArg() {
		return arg;
	}
}
