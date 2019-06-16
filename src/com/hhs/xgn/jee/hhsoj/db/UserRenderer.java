package com.hhs.xgn.jee.hhsoj.db;



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
	
	public String getColorUP(Users u,String p){
		if(u==null || p==null || u.getProblemStatus()==null){
			return "white";
		}
		int s=u.getProblemStatus().getOrDefault(p, 0);
		if(s==0){
			return "white";
		}
		if(s==1){
			return "yellow";
		}
		if(s==2){
			return "green";
		}
		return "grey";
	}
	
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
		if(user.getSpecialRole()==null){
			return "<a href=\"users.jsp?username="+user.getUsername()+"\" class=\"user"+getRank(user.getNowRating())+"\">"+user.getUsername()+"</a>";
		}else{
			return "<a href=\"users.jsp?username="+user.getUsername()+"\">"+r(user.getSpecialColor(),user.getUsername())+"</a>";
		}
		
	}
	
	public static String r(String a,String b){
		return a.replaceAll("\\{\\{\\{username\\}\\}\\}", b);
	}
	/**
	 * Render the user text
	 * @param user
	 * @return
	 */
	public String getUserTextLarge(Users user){
		if(user.getSpecialRole()==null){
			return "<h1 class=\"user"+getRank(user.getNowRating())+"\">"+user.getUsername()+"</h1>";
		}else{
			return "<h1>"+r(user.getSpecialColor(),user.getUsername())+"</h1>";
		}
		
	}
	
	public String getUserText(String username){
		
		Users s=new UserHelper().getUserInfo(username);
		if(s==null){
			return "<a href=\"#\" class=\"userUnrated\">"+username+"</a>";
		}
		return getUserText(s);
	}
}
