package com.hhs.xgn.jee.hhsoj.judger;

import com.hhs.xgn.jee.hhsoj.type.Submission;

/**
 * A abstract judger which needs to be implemented. 
 * @author XGN
 *
 */
public abstract class AbstractJudger {
	public abstract void init();
	
	public abstract void judgeNormal(Submission s);
	
	public abstract void judgeCodeforces(Submission s);
	
	public abstract void judgeHack(Submission s);
}
