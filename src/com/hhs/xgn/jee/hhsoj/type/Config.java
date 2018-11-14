package com.hhs.xgn.jee.hhsoj.type;

public class Config {
	private boolean enableCPP11;
	private String windowsUsername;
	private String windowsPassword;
	private String adminUsername;
	private String adminPassword;
	
	public boolean isEnableCPP11() {
		return enableCPP11;
	}
	public void setEnableCPP11(boolean enableCPP11) {
		this.enableCPP11 = enableCPP11;
	}
	public String getWindowsUsername() {
		return windowsUsername;
	}
	public void setWindowsUsername(String windowsUsername) {
		this.windowsUsername = windowsUsername;
	}
	public String getWindowsPassword() {
		return windowsPassword;
	}
	public void setWindowsPassword(String windowsPassword) {
		this.windowsPassword = windowsPassword;
	}
	public String getAdminUsername() {
		return adminUsername;
	}
	public void setAdminUsername(String adminUsername) {
		this.adminUsername = adminUsername;
	}
	public String getAdminPassword() {
		return adminPassword;
	}
	public void setAdminPassword(String adminPassword) {
		this.adminPassword = adminPassword;
	}
	
}
