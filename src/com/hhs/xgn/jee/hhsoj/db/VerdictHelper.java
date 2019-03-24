package com.hhs.xgn.jee.hhsoj.db;

/**
 * This is not a file-contact class. It is used to display verdict
 * @author XGN
 *
 */
public class VerdictHelper {
	public String render(String s){
		if(s.startsWith("Time Limit Exceeded") || s.startsWith("Memory Limit Exceeded")){
			return "<font color=#0000ff>"+s+"</font>";
		}
		if(s.equalsIgnoreCase("Accepted")){
			return "<font color=#00ff00><b>"+s+"</b></font>";
		}
		if(s.startsWith("Initalizing") || s.startsWith("Running") || s.startsWith("Judging") || s.startsWith("Compiling") || s.startsWith("In queue")){
			return "<font color=#787878>"+s+"</font>";
		}
		if(s.startsWith("Wrong Answer")){
			return "<font color=#ff0000>"+s+"</font>";
		}
		if(s.startsWith("Runtime Error")){
			return "<font color=#088a85>"+s+"</font>";
		}
		
		return "<font color=#201890>"+s+"</font>";
	}
}
