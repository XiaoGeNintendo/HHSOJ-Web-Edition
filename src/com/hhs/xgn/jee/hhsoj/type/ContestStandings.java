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
	private ArrayList<ContestStandingRow> rows;
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
