package com.hhs.xgn.jee.hhsoj.type;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

/**
 * The user type. it's javabean
 * @author XGN
 *
 */
public class Users {
	private String username;
	private String password;
	private int id;
	/**
	 * The quote of user
	 */
	private String line;
	private List<ContestRecord> ratings;
	private Map<Integer, Integer> blogStatus;
	private String userPic;
	
	public Users(){
		ratings=new ArrayList<ContestRecord>();
		blogStatus=new HashMap<>();
		userPic="asset/defaultUserpic.jpg";
	}
	
	public String getUserPic(){
		return userPic;
	}
	public void setUserPic(String UserPic){
		userPic=UserPic;
	}
	
	public void setBlogStatus(int a,int b){
		blogStatus.put(a, b);
	}
	
	public int getBlogStatus(int a){
		return blogStatus.getOrDefault(a, 0);
	}
	
	public int getNowRating(){
		if(ratings.isEmpty()){
			return 0;
		}
		int rating=1500;
		for(ContestRecord cr:ratings){
			rating+=cr.getRatingChange();
		}
		return rating;
	}
	
	public int getMaxRating(){
		if(ratings.isEmpty()){
			return 0;
		}
		int rating=1500;
		int mx=0;
		for(ContestRecord cr:ratings){
			rating+=cr.getRatingChange();
			mx=Math.max(mx,rating);
		}
		return mx;
	}
	
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getLine() {
		return line;
	}
	public void setLine(String line) {
		this.line = line;
	}
	
	public String toJson(){
		return new Gson().toJson(this);
	}

	public List<ContestRecord> getRatings() {
		return ratings;
	}

	public void setRatings(List<ContestRecord> ratings) {
		this.ratings = ratings;
	}
	
	
}
