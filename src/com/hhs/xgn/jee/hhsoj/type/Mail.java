package com.hhs.xgn.jee.hhsoj.type;

public class Mail {
	private String sender;
	private String to;
	private String text;
	
	public Mail(){
		
	}
	
	public Mail(String s,String t,String tx){
		sender=s;
		to=t;
		text=tx;
	}
	
	public String getSender() {
		return sender;
	}
	public void setSender(String sender) {
		this.sender = sender;
	}
	public String getTo() {
		return to;
	}
	public void setTo(String to) {
		this.to = to;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	
}
