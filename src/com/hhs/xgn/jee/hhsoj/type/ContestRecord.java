package com.hhs.xgn.jee.hhsoj.type;

/**
 * A contest record
 * @author XGN
 *
 */
public class ContestRecord {
	/**
	 * Use this id to get the contest information
	 */
	private int id;
	
	/**
	 * The place user took
	 */
	private int place;
	/**
	 * The change of the rating
	 */
	private int ratingChange;
	
	public ContestRecord(){
		
	}
	
	public ContestRecord(int id,int place,int ratingc){
		this.id=id;
		this.place=place;
		this.ratingChange=ratingc;
	}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getPlace() {
		return place;
	}
	public void setPlace(int place) {
		this.place = place;
	}
	public int getRatingChange() {
		return ratingChange;
	}
	public void setRatingChange(int ratingChange) {
		this.ratingChange = ratingChange;
	}
	
	
}
