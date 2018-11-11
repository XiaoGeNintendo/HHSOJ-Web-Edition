package com.hhs.xgn.jee.hhsoj.db;

import com.hhs.xgn.jee.hhsoj.type.Submission;

/**
 * Matches Pattern Helper
 * @author XGN
 *
 */
public class PatternMatcher {
	public synchronized boolean match(Submission s,String userP,String probP,String verdictP){
		if(userP!=null && !userP.equals("") && !s.getUser().equals(userP)){
			return false;
		}
		if(probP!=null && !probP.equals("") && !s.getProb().equals(probP)){
			return false;
		}
		if(verdictP!=null && !verdictP.equals("") &&!s.getVerdict().contains(verdictP)){
			return false;
		}
		return true;
	}
}
