package com.hhs.xgn.jee.hhsoj.type;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import com.google.gson.Gson;
import com.hhs.xgn.jee.hhsoj.db.ContestHelper;
import com.hhs.xgn.jee.hhsoj.db.SubmissionHelper;

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
	
	/**
	 * Return the languages in Javascript Text
	 * @return
	 */
	public String JSgetLang(){
		ArrayList<Submission> arr=new SubmissionHelper().getAllSubmissions();
		HashMap<String, Integer> cnt=new HashMap<>();
		
		for(Submission s:arr){
			if(s.getUser().equals(username)){
				cnt.put(s.getLang(), cnt.getOrDefault(s.getLang(),0)+1);
			}
		}
		
		String ans="[";
		for(Entry<String,Integer> e:cnt.entrySet()){
			ans+="['"+e.getKey()+"',"+e.getValue()+"],";
		}
		ans=ans.substring(0, ans.length()-1);
		ans+="]";
		
		return ans;
	}
	
	/**
	 * Return the verdict in Javascript Text
	 * @return
	 */
	public String JSgetVerdict(){
		ArrayList<Submission> arr=new SubmissionHelper().getAllSubmissions();
		HashMap<String, Integer> cnt=new HashMap<>();
		
		for(Submission s:arr){
			if(s.getUser().equals(username)){
				cnt.put(s.getVerdict(), cnt.getOrDefault(s.getVerdict(),0)+1);
			}
		}
		
		String ans="[";
		for(Entry<String,Integer> e:cnt.entrySet()){
			ans+="['"+e.getKey()+"',"+e.getValue()+"],";
		}
		ans=ans.substring(0, ans.length()-1);
		ans+="]";
		
		return ans;
	}
	
	/**
	 * Return the contest name in Javascript text
	 * @return
	 */
	public String JSgetContestName(){
		String s="['Inital Rating'";
		for(ContestRecord cr:ratings){
			s+=",'"+new ContestHelper().getContestDataById(cr.getId()+"").getInfo().getName()+"'";
		}
		s+="]";
		return s;
	}
	/**
	 * Return the rating information in Javascript text
	 * @return the rating text
	 */
	public String JSgetRating(){
		int rating=1500;
		String s="[1500";
		for(ContestRecord cr:ratings){
			rating+=cr.getRatingChange();
			s+=","+rating;
		}
		s+="]";
		return s;
	}
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
			return 1500;
		}
		int rating=1500;
		for(ContestRecord cr:ratings){
			rating+=cr.getRatingChange();
		}
		return rating;
	}
	
	public int getMaxRating(){
		if(ratings.isEmpty()){
			return 1500;
		}
		int rating=1500;
		int mx=1500;
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

	public Map<Integer, Integer> getBlogStatus() {
		return blogStatus;
	}

	public void setBlogStatus(Map<Integer, Integer> blogStatus) {
		this.blogStatus = blogStatus;
	}

	
	
	
}
