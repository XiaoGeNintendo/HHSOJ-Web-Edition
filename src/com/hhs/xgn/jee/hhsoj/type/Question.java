package com.hhs.xgn.jee.hhsoj.type;

/**
 * The questions users ask in the contest
 * @author XGN
 *
 */
public class Question {
	private int contestId;
	private String asker;
	private String question;
	private int status;
	public static final int UNREPLIED=1;
	public static final int REPLIED=2;
	private String answer;
	
	public Question(){
		asker="admin";
		question="";
		status=UNREPLIED;
		answer="";
	}
	/**
	 * Is it public for all users?
	 */
	private boolean open;
	
	/**
	 * Reply to the question. Auto set the status
	 */
	public void reply(String s){
		status=REPLIED;
		answer=s;
	}
	
	public int getContestId() {
		return contestId;
	}
	public void setContestId(int contestId) {
		this.contestId = contestId;
	}
	public String getAsker() {
		return asker;
	}
	public void setAsker(String asker) {
		this.asker = asker;
	}
	public String getQuestion() {
		return question;
	}
	public void setQuestion(String question) {
		this.question = question;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public String getAnswer() {
		if(status==UNREPLIED){
			return "(Waiting to be answered)";
		}
		return answer;
	}
	public void setAnswer(String answer) {
		this.answer = answer;
	}
	public boolean isOpen() {
		return open;
	}
	public void setOpen(boolean open) {
		this.open = open;
	}
	
}
