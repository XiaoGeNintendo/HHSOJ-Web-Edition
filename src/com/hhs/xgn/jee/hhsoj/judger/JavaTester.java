package com.hhs.xgn.jee.hhsoj.judger;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;

import com.hhs.xgn.jee.hhsoj.db.SubmissionHelper;
import com.hhs.xgn.jee.hhsoj.type.Problem;
import com.hhs.xgn.jee.hhsoj.type.Submission;
import com.hhs.xgn.jee.hhsoj.type.TestResult;

/**
 * Used to test java program
 * @author XGN	
 *
 */
public class JavaTester {
	/**
	 * Test the given java program
	 * @param s --submission file
	 * @param f --input file
	 * @param p --problem file
	 * @return continue testing?
	 */
	public boolean test(Submission s,File f,Problem p){
		
		try{
			JavaClassLoader jcl=new JavaClassLoader();
			jcl.loadClass(getClassFile(new File("hhsoj/judge/Program.class")), "Program");
		}catch(Exception e){
			s.setVerdict("Judgement Failed");
			s.getResults().add(new TestResult("Judgement Failed", 0, 0, f.getName(), "Java test failed:"+e));
			new SubmissionHelper().storeStatus(s);
			return false;
		}
		
		return false;
	}

	/**
	 * Get class file in byte
	 * @param file
	 * @return
	 */
	public byte[] getClassFile(File file) {
		//TODO
		return null;
		
	}
}
