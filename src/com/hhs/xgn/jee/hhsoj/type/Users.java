package com.hhs.xgn.jee.hhsoj.type;

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
	
	
}
