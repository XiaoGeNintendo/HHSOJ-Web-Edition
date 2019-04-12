package com.hhs.xgn.jee.hhsoj.type;

/**
 * A think prefer unit of the preferences
 * @author think
 *
 */
public class PreferUnit {
	public String shownName;
	public String value;
	public boolean isChosen;
	public String[] choice;
	
	public PreferUnit(){
		
	}
	public PreferUnit(String name,String value, boolean isChosen, String[] choice) {
		shownName=name;
		this.value = value;
		this.isChosen = isChosen;
		this.choice = choice;
	}
	
}
