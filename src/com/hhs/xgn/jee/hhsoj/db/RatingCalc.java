package com.hhs.xgn.jee.hhsoj.db;

import com.hhs.xgn.jee.hhsoj.type.Contest;
import com.hhs.xgn.jee.hhsoj.type.ContestRecord;
import com.hhs.xgn.jee.hhsoj.type.ContestStandingRow;
import com.hhs.xgn.jee.hhsoj.type.ContestStandings;
import com.hhs.xgn.jee.hhsoj.type.Users;

/**
 * Rating calculator. Using Elo
 * @author XGN
 *
 */
public class RatingCalc {
	
	/**
	 * The constant of K
	 */
	public final double K=16;
	
	/**
	 * Calculate rating for the contest c
	 * @param c
	 */
	public void calc4(Contest c){
		int rank=1;
		for(ContestStandingRow csr:c.getStanding().getRows()){
			calcU(csr,c.getStanding(),c.getId(),rank);
			rank++;
		}
	}
	
	/**
	 * Get rating for the new user
	 * @param csr
	 * @param c
	 */
	public void calcU(ContestStandingRow csr,ContestStandings c,int id,int place){
		double w=0,we=0;
		
		int myRating=0;
		try{
			myRating=new UserHelper().getUserInfo(csr.getUser()).getNowRating();
		}catch(Exception e){
			System.out.println("Failed to pend for "+csr.getUser()+" for "+e);
			e.printStackTrace();
			return;
		}
		
		for(ContestStandingRow acs:c.getRows()){
			if(!acs.getUser().equals(csr.getUser())){
				//Calc w and we
				
				try{
				we+=P(myRating-new UserHelper().getUserInfo(acs.getUser()).getNowRating());
				}catch(Exception e){
					System.out.println("Failed to add P for "+acs.getUser()+" --> "+csr.getUser()+" For some reason "+e);
				}
				if(acs.getScore()<csr.getScore() || acs.getScore()==csr.getScore() && acs.getPenalty()>csr.getPenalty()){
					//csr wins acs
					w++;
				}
			}
		}
		
		int newRating=(int) (myRating+K*(w-we));
		System.out.println("Pending rating for "+csr.getUser()+":"+myRating+"->"+newRating);
		
		Users u=new UserHelper().getUserInfo(csr.getUser());
		u.getRatings().add(new ContestRecord(id,place,newRating-myRating));
		new UserHelper().refreshUser(u);
	}
	
	/**
	 * The function of P
	 */
	public double P(double delta){
		return 1/(1+Math.pow(10, -delta/400));
	}
	
}
