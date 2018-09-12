package com.hhs.xgn.jee.hhsoj.type;

import java.util.Map;

/**
 * Problem class.
 * @author XGN
 * How to make a problem? First create the problem ID folder in /problems
 * then put the statement into WebContent/statement
 */
public class Problem {
	private int id;
	private String name;
	private String tag;
	private Map<String, String> arg;
	
	public String getPath(){
		return "hhsoj/problems/"+id;
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
}
