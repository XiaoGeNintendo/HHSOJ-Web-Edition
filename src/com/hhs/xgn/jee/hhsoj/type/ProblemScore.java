package com.hhs.xgn.jee.hhsoj.type;

/**
 * Problem Score Structure
 * @author XGN
 *
 */
public class ProblemScore {
	private int small;
	private int large;
	public ProblemScore(){
		
	}
	public ProblemScore(int s,int l){
		small=s;
		large=l;
	}
	
	public int getSmall() {
		return small;
	}
	public void setSmall(int small) {
		this.small = small;
	}
	public int getLarge() {
		return large;
	}
	public void setLarge(int large) {
		this.large = large;
	}
	
}
