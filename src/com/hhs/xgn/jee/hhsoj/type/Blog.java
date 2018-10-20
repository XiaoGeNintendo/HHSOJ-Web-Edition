package com.hhs.xgn.jee.hhsoj.type;

import java.text.SimpleDateFormat;
import java.util.Date;

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
	private int id;
	private long time;
	
	public Blog(){
		
	}
	
	public String getReadableTime(){
		return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(time));
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

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}



	public long getTime() {
		return time;
	}



	public void setTime(long time) {
		this.time = time;
	}
	
	
}