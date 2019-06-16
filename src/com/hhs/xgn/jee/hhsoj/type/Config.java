package com.hhs.xgn.jee.hhsoj.type;

public class Config {
	private boolean enableCPP11;
	private String windowsUsername;
	private String windowsPassword;
	private String adminUsername;
	private String adminPassword;
	private String codeforcesUsername;
	private String codeforcesPassword;
	private boolean enableRemoteJudge;
	private long queryTime;
	private boolean clearFolder;
	private int waitTimeout;
	
	private boolean needEmailVerify;
	private String emailSmtp;
	private String emailSubject;
	private String emailUsername;
	private String emailPassword;
	private String emailSender;
	
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
	public String getCodeforcesUsername() {
		return codeforcesUsername;
	}
	public void setCodeforcesUsername(String codeforcesUsername) {
		this.codeforcesUsername = codeforcesUsername;
	}
	public String getCodeforcesPassword() {
		return codeforcesPassword;
	}
	public void setCodeforcesPassword(String codeforcesPassword) {
		this.codeforcesPassword = codeforcesPassword;
	}
	public boolean isEnableRemoteJudge() {
		return enableRemoteJudge;
	}
	public void setEnableRemoteJudge(boolean enableRemoteJudge) {
		this.enableRemoteJudge = enableRemoteJudge;
	}
	public long getQueryTime() {
		return queryTime;
	}
	public void setQueryTime(long queryTime) {
		this.queryTime = queryTime;
	}
	public boolean isClearFolder() {
		return clearFolder;
	}
	public void setClearFolder(boolean clearFolder) {
		this.clearFolder = clearFolder;
	}
	public int getWaitTimeout() {
		return waitTimeout;
	}
	public void setWaitTimeout(int waitTimeout) {
		this.waitTimeout = waitTimeout;
	}
	public boolean isNeedEmailVerify() {
		return needEmailVerify;
	}
	public void setNeedEmailVerify(boolean needEmailVerify) {
		this.needEmailVerify = needEmailVerify;
	}
	public String getEmailSmtp() {
		return emailSmtp;
	}
	public void setEmailSmtp(String emailSmtp) {
		this.emailSmtp = emailSmtp;
	}
	public String getEmailSubject() {
		return emailSubject;
	}
	public void setEmailSubject(String emailSubject) {
		this.emailSubject = emailSubject;
	}
	public String getEmailUsername() {
		return emailUsername;
	}
	public void setEmailUsername(String emailUsername) {
		this.emailUsername = emailUsername;
	}
	public String getEmailPassword() {
		return emailPassword;
	}
	public void setEmailPassword(String emailPassword) {
		this.emailPassword = emailPassword;
	}
	public String getEmailSender() {
		return emailSender;
	}
	public void setEmailSender(String emailSender) {
		this.emailSender = emailSender;
	}
	
}
