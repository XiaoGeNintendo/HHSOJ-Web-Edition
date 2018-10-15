package com.hhs.xgn.jee.hhsoj.type;

/**
 * The blog class
 * @author XGN
 *
 */
public class Blog {
	private String title;
	private String html;
	private String user;
	private int vote;
	
	public Blog(){
		
	}
	
	public Blog(String t,String h,String u){
		title=t;
		html=h;
		user=u;
	}

	public int getVote(){
		return vote;
	}
	public void setVote(int v){
		vote=v;
	}
	public void addvote(){
		vote++;
	}
	public void downvote(){
		vote--;
	}
	
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getHtml() {
		return html;
	}

	public void setHtml(String html) {
		this.html = html;
	}

	public String getUser() {
		return user;
	}

	public void setUser(String user) {
		this.user = user;
	}
	
	
}
