package com.hhs.xgn.jee.hhsoj.type;

import java.util.ArrayList;
import java.util.Comparator;

import com.google.gson.Gson;

/**
 * Contest Standings Class
 * @author XGN
 *
 */
public class ContestStandings {
	private ArrayList<ContestStandingRow> rows=new ArrayList<>();
	
	/**
	 * Count the program to be wrong
	 * @param s
	 * @param index
	 */
	public void countWrong(Submission s,String index){
		ContestStandingRow csr=getContestStandingRowOfUser(s.getUser());
		ContestStandingColumn csc=csr.getScores().getOrDefault(index, new ContestStandingColumn(0, 0, 0));
		if(csc.getRawScore()!=0){
			return;
		}
		csc.addUnsuccessfulSubmitCount();
		csr.getScores().put(index, csc);
		
		sortStanding();
	}
	
	/**
	 * Given a submission that is accepted. Add some following scores into the submission.
	 * @param s
	 */
	public void countSmall(Submission s,String index,int score){
		ContestStandingRow csr=getContestStandingRowOfUser(s.getUser());
		ContestStandingColumn csc=csr.getScores().getOrDefault(index, new ContestStandingColumn(0, 0, 0));
		if(csc.getScoreSmall()!=0){
			csc.addUnsuccessfulSubmitCount();
		}
		csc.setScoreSmall(score);
		csc.setLastSubmissionTime(s.getSubmitTime());
		csr.getScores().put(index, csc);
		
		sortStanding();
	}
	
	/**
	 * Given a username, returns the Standing Row of him. <br/>
	 * If not found, add one auto and create one
	 * @param username
	 * @return
	 */
	public ContestStandingRow getContestStandingRowOfUser(String username){
		for(ContestStandingRow csr:rows){
			if(csr.getUser().equals(username)){
				return csr;
			}
		}
		ContestStandingRow csr=new ContestStandingRow();
		csr.setUser(username);
		rows.add(csr);
		return csr;
	}
	public String toJson(){
		return new Gson().toJson(this);
	}
	public void sortStanding(){
		rows.sort(new Comparator<ContestStandingRow>() {
			@Override
			public int compare(ContestStandingRow o1, ContestStandingRow o2) {
				if(o1.getScore()!=o2.getScore()){
					//Who is bigger who is first
					return -Integer.compare(o1.getScore(), o2.getScore());
				}
				return Long.compare(o1.getPenalty(), o2.getPenalty());
			}
		});
	}
	
	public ArrayList<ContestStandingRow> getRows() {
		return rows;
	}

	public void setRows(ArrayList<ContestStandingRow> rows) {
		this.rows = rows;
	}
	
	
}
