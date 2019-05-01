package com.hhs.xgn.jee.hhsoj.type;

/**
 * A custom test submission is a add-on to the normal submission <br/>
 * Where the old stuff still holds and used to display, <br/>
 * but visible data and input data is here <br/>
 * The problem is "T" and output of the submission are stored in compiler information <br/>
 * @author XGN
 *
 */
public class CustomTestSubmission extends Submission {
	private String visible;
	private String input;
	
	public CustomTestSubmission(String code,String input,String visible,String author,String lang){
		setCode(code);
		setInput(input);
		setVisible(visible);
		setProb("T");
		setTestset("CustomTest");
		setUser(author);
		setSubmitTime(System.currentTimeMillis());
		setLang(lang);
	}
	
	public String getVisible() {
		return visible;
	}
	public void setVisible(String visible) {
		this.visible = visible;
	}
	public String getInput() {
		return input;
	}
	public void setInput(String input) {
		this.input = input;
	}
	
}
