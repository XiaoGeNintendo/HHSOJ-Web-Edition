package com.hhs.xgn.jee.hhsoj.db;

/**
 * This is not a file-contact class. It is used to display verdict
 * @author XGN
 *
 */
public class VerdictHelper {
	public String render(String s){
		if(s.startsWith("Time Limit Exceeded") || s.startsWith("Memory Limit Exceeded")){
			return "<span style=\"color:#0000ff;\">"+s+"</span>";
		}
		if(s.equalsIgnoreCase("Accepted") || s.equalsIgnoreCase("Successful Hacking Attempt")){
			return "<span style=\"color:#00ff00;font-weight:bold;\">"+s+"</span>";
		}
		if(s.equalsIgnoreCase("Unsuccessful Hacking Attempt") || s.equalsIgnoreCase("Hacked")){
			return "<span style=\"color:#ff0000;font-weight:bold;\">"+s+"</span>";
		}
		if(s.startsWith("Defending") || s.startsWith("Initalizing") || s.startsWith("Running") || s.startsWith("Judging") || s.startsWith("Compiling") || s.startsWith("In queue")){
			return "<span style=\"color:#787878;\">"+s+"</span>";
		}
		if(s.startsWith("Wrong Answer")){
			return "<span style=\"color:#ff0000;\">"+s+"</span>";
		}
		if(s.startsWith("Runtime Error")){
			return "<span style=\"color:#088a85;\">"+s+"</span>";
		}
		
		return "<span style=\"color:#201890;\">"+s+"</span>";
	}
}
