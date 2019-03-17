package com.hhs.xgn.jee.hhsoj.remote;

import java.util.ArrayList;
import java.util.HashMap;

import com.hhs.xgn.jee.hhsoj.type.Problem;

/**
 * A class for Codeforces Problem
 * @author XGN
 *
 */
public class CodeforcesProblem {
	private int contestId;
	private String problemsetName;
	private String index;
	private String name;
	private String type;
	private float points;
	private ArrayList<String> tags;
	
	public Problem toProblem(){
		Problem p=new Problem();
		p.setType(Problem.CODEFORCES);
		p.setConId(contestId);
		p.setConIndex(index);
		p.setTag(tags+"");
		p.setName(name);
		HashMap<String,String> mp=new HashMap<>();
		mp.put("TL", "-");
		mp.put("ML", "-");
		
		p.setArg(mp);
		
		return p;
	}
	
	public CodeforcesProblem(){
		problemsetName="";
		index="";
		name="";
		type="";
		tags=new ArrayList<>();
	}

	public int getContestId() {
		return contestId;
	}

	public void setContestId(int contestId) {
		this.contestId = contestId;
	}

	public String getProblemsetName() {
		return problemsetName;
	}

	public void setProblemsetName(String problemsetName) {
		this.problemsetName = problemsetName;
	}

	public String getIndex() {
		return index;
	}

	public void setIndex(String index) {
		this.index = index;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public float getPoints() {
		return points;
	}

	public void setPoints(float points) {
		this.points = points;
	}

	public ArrayList<String> getTags() {
		return tags;
	}

	public void setTags(ArrayList<String> tags) {
		this.tags = tags;
	}
	
}
