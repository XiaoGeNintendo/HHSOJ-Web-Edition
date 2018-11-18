package com.hhs.xgn.jee.hhsoj.type;

import java.util.Map;

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
	
	public String getPath(){
		if(type==PROBLEMSET){
			return "hhsoj/problems/"+id;
		}
		if(type==CONTEST){
			return "hhsoj/contests/"+conId+"/"+conIndex;
		}
		if(type==CODEFORCES){
			return null;
		}
		return null;
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
