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
	public static final int SOLVED = 2;
	public static final int ATTEMPTED=1;
	public static final int UNTRIED=0;
	
	
	private String username;
	private String password;
	private int id;
	
	private String email;
	private boolean sendNotify;
	
	private boolean verified;
	private String verifyCode;
	private long lastVerify;
	
	
	private String forgetCode;
	private long lastForget;
	
	private String specialRole;
	private String specialColor;
	
	
	/**
	 * The quote of user
	 */
	private String line;
	private List<ContestRecord> ratings;
	private Map<Integer, Integer> blogStatus;
	private HashMap<String,Integer> problemStatus=new HashMap<>();
	private String userPic;
	
	private Preferences preference=new Preferences();
	
	/**
	 * If the user is banned
	 */
	private boolean banned;
	
	/**
	 * Inbox
	 */
	private List<Mail> talks;
	private int viewIndex;
	
	/**
	 * Is the user a problemsetter?
	 */
	private boolean isSetter=false;
	
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
		talks=new ArrayList<>();
		viewIndex=-1;
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

	public boolean isBanned() {
		return banned;
	}

	public void setBanned(boolean banned) {
		this.banned = banned;
	}

	public HashMap<String,Integer> getProblemStatus() {
		return problemStatus;
	}

	public void setProblemStatus(HashMap<String,Integer> problemStatus) {
		this.problemStatus = problemStatus;
	}

	public void setProblemStatus(String pid,int status){
		if(problemStatus==null){
			problemStatus=new HashMap<>();
		}
		
		problemStatus.put(pid, Math.max(problemStatus.getOrDefault(pid,UNTRIED), status));
	}
	
	public int count(int x){
		int ans=0;
		for(Entry<String,Integer> e:problemStatus.entrySet()){
			if(e.getValue()==x){
				ans++;
			}
		}
		return ans;
	}
	
	public String JScount(int x){
		String ans="";
		
		for(Entry<String,Integer> e:problemStatus.entrySet()){
			if(e.getValue()==x){
				ans+="<a href=\"problem.jsp?id="+e.getKey()+"\">"+e.getKey()+"</a> ";
			}
		}
		return ans;
	}

	public Preferences getPreference() {
		if(preference==null){
			preference=new Preferences();
		}
		return preference;
	}

	public void setPreference(Preferences preference) {
		this.preference = preference;
	}

	public List<Mail> getTalks() {
		return talks;
	}

	public void setTalks(List<Mail> talks) {
		this.talks = talks;
	}

	public int getViewIndex() {
		return viewIndex;
	}

	public void setViewIndex(int viewIndex) {
		this.viewIndex = viewIndex;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public boolean isSendNotify() {
		return sendNotify;
	}

	public void setSendNotify(boolean sendNotify) {
		this.sendNotify = sendNotify;
	}

	public String getSpecialRole() {
		return specialRole;
	}

	public void setSpecialRole(String specialRole) {
		this.specialRole = specialRole;
	}

	public String getSpecialColor() {
		return specialColor;
	}

	public void setSpecialColor(String specialColor) {
		this.specialColor = specialColor;
	}

	public boolean isVerified() {
		return verified;
	}

	public void setVerified(boolean verified) {
		this.verified = verified;
	}

	public String getVerifyCode() {
		return verifyCode;
	}

	public void setVerifyCode(String verifyCode) {
		this.verifyCode = verifyCode;
	}

	public long getLastVerify() {
		return lastVerify;
	}

	public void setLastVerify(long lastVerify) {
		this.lastVerify = lastVerify;
	}

	public String getForgetCode() {
		return forgetCode;
	}

	public void setForgetCode(String forgetCode) {
		this.forgetCode = forgetCode;
	}

	public long getLastForget() {
		return lastForget;
	}

	public void setLastForget(long lastForget) {
		this.lastForget = lastForget;
	}

	public boolean isSetter() {
		return isSetter;
	}

	public void setSetter(boolean isSetter) {
		this.isSetter = isSetter;
	}
}
