package com.hhs.xgn.jee.hhsoj.db;

import org.apache.catalina.User;

import com.hhs.xgn.jee.hhsoj.type.Users;

/**
 * Used to render user
 * @author XGN
 *
 */
public class UserRenderer {
	/**
	 * Ranks given to a user
	 */
	String[] ranks=new String[]{"Unrated","Newbie","Pupil","Specialist","Expert","CandidateMaster","Master","InternationalMaster","Grandmaster","InternationalGrandmaster","LegendaryGrandmaster"};
	/**
	 * the max score to be this rank
	 */
	int[] scores=new int[]{0,1199,1399,1599,1899,2099,2299,2399,2599,2999,1000000000};
	
	/**
	 * Get user rank with a rating
	 * @param rating
	 * @return
	 */
	public String getRank(int rating){
		for(int i=0;i<ranks.length;i++){
			if(rating<=scores[i]){
				return ranks[i];
			}
		}
		return null;
	}
	
	/**
	 * Render the user text
	 * @param user
	 * @return
	 */
	public String getUserText(Users user){
		return "<a href=\"users.jsp?username="+user.getUsername()+"\" class=\"user"+getRank(user.getNowRating())+"\">"+user.getUsername()+"</a>";
	}
	
	/**
	 * Render the user text
	 * @param user
	 * @return
	 */
	public String getUserTextLarge(Users user){
		return "<h1 class=\"user"+getRank(user.getNowRating())+"\">"+user.getUsername()+"</h1>";
	}
	
	public String getUserText(String username){
		
		Users s=new UserHelper().getUserInfo(username);
		if(s==null){
			return "<a href=\"#\" class=\"userUnrated\">"+username+"</a>";
		}
		return getUserText(s);
	}
}
