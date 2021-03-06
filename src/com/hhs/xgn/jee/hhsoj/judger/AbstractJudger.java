package com.hhs.xgn.jee.hhsoj.judger;

import java.io.File;

import com.hhs.xgn.jee.hhsoj.type.CustomTestSubmission;
import com.hhs.xgn.jee.hhsoj.type.Problem;
import com.hhs.xgn.jee.hhsoj.type.Submission;
import com.hhs.xgn.jee.hhsoj.type.Users;

/**
 * A abstract judger which needs to be implemented. 
 * @author XGN
 *
 */
public abstract class AbstractJudger {
	/**
	 * Called when initizing. Returns false if failed
	 * @param s
	 * @param p
	 * @param u
	 * @return
	 */
	public abstract boolean init(Submission s,Problem p,Users u,JudgingThread self) throws Exception;
	
	/**
	 * Returns false if not accepted
	 * @param s
	 * @param p
	 * @param u
	 * @return
	 */
	public abstract boolean judgeNormal(Submission s,Problem p,Users u,File testfiles) throws Exception;
	
	/**
	 * Returns true if the hack is valid
	 * @param s
	 * @param p
	 * @param u
	 * @return
	 * @throws Exception
	 */
	public abstract boolean judgeHack(Submission s,Problem p,Users u,Problem orip,Submission oris) throws Exception;

	/**
	 * Test a custom test.
	 * @param s
	 */
	public abstract void judgeCustomTest(CustomTestSubmission s);

}
