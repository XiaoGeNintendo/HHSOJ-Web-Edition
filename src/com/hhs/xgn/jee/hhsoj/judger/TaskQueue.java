package com.hhs.xgn.jee.hhsoj.judger;

import java.util.ArrayList;
import java.util.Vector;

import com.hhs.xgn.jee.hhsoj.db.SubmissionHelper;
import com.hhs.xgn.jee.hhsoj.type.Submission;
import com.hhs.xgn.jee.hhsoj.type.TestResult;

/**
 * The judging queue
 * @author XGN
 *
 */
public class TaskQueue {

	private static Vector<Submission> queue=new Vector<Submission>();
	
	private static boolean open=false; 
	public synchronized static void openThread(){
		if(open) return;
		System.out.println("Static block runs");
		Thread t=new JudgingThread();
		t.setName("Judging Thread");
		
		t.start();
		open=true;
	}
	
	public synchronized static boolean hasElement(){
		return !queue.isEmpty();
	}
	
	public synchronized static Submission getFirstSubmission(){
		return queue.firstElement();
	}
	
	public synchronized static void popFront(){
		queue.remove(0);
	}
	
	public synchronized static int addTask(Submission s){
		s.setVerdict("In queue");
		s.setResults(new ArrayList<TestResult>());
		s.setCompilerComment("");
		s.setId(new SubmissionHelper().getNewId());
		s.setNowTest(-1);
		new SubmissionHelper().storeStatus(s);
		queue.add(s);
		
		System.out.println("Added task!"+queue);
		
		openThread();
		return s.getId();
	}
}
